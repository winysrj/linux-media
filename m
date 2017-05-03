Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49591
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751108AbdECMxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 08:53:10 -0400
Date: Wed, 3 May 2017 09:53:03 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
Message-ID: <20170503095303.71cf3a75@vento.lan>
In-Reply-To: <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
        <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Tue, 2 May 2017 22:30:29 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Clemens,
> 
> On 4/1/17 5:50 PM, Clemens Ladisch wrote:
> > ETSI EN 300 468 V1.11.1 § 6.4.4.2 defines the bandwith field as having
> > four bits.  
> 
> I just used your patch and another to hopefully fix
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> 
> But I'm a little bit hesitant to merge it to v4l-utils git without
> Mauros acknowledgement.

Patches look correct, but the T2 parser has a more serious issue that
will require breaking ABI/API compatibility.

Let me explain a little more about te T2 delivery descriptor.

Such descriptor is present on DVB-T2 streams, but the specs allow
a "simplified" version of it, with just 4 bytes:
	16 bytes for system ID;
	16 bytes for bit field.

By the time this descriptor parser was written, the existing
DVB-T2 streams I got access were using this simplified version.

After those 4 bytes, the DVB spec[1] allows a variable number of elements, 
controlled by a C-like code, defined at the spec as[2]:

	for (i = 0; i < N, i++){
		cell_id			// 16 bits
		if (tfs_flag == 1) {
			frequency_loop_length	// 8 bits
			for (j = 0; j < frequency_loop_length; j++) {
				centre_frequency	// 32 bis
			}
		} else {
			centre_frequency	// 32 bis
		}
		subcell_info_loop_length	// 8 bits
		for (k = 0; k < subcell_info_loop_length; k++) {
			cell_id_extension	// 8 bits
			transposer_frequency	// 32 bits
		}
	}

where "N" is dynamically discovered, e. g. the logic checks if
there is still bytes left inside the descriptor, it will run the
loop. So, this is actually something like:
	while (pos < size) {
		// handle cell_ID logic
		pos += number_of_bytes_parsed;
	}
			

[1] https://www.dvb.org/resources/public/standards/a38_dvb-si_specification.pdf
[2] The code is not an exact copy of what's at the spec, as, at spec, all
    loops use "N" instead of the name of the real variable that controls
    the loop.

There are two problems with the current code:

1) This struct that stores the subcell data is wrong. It is currently
defined as:

	struct dvb_desc_t2_delivery_subcell {
		uint8_t cell_id_extension;
		uint16_t transposer_frequency;
	} __attribute__((packed));

However, the transposer frequency is actually 32 bits. From the specs:

	"transposer_frequency: This 32 bit field indicates the
	 centre frequency that is used by a transposer in the sub-cell
	 indicated. It is encoded in the same way as the centre_frequency
	 field."

2) Right now, the code assumes just one table of centre_frequency.
According with the specs (at least v1.13.1 - with is the latest
documentation), multiple tables can exist.

I remember I tested it some years after the initial version, with a
DVB-T2 stream. On that time, there was just one frequency table,
e. g. just one cell ID.

Yet, as now DVB-T2 is spreading, I won't doubt that we'll find some
places that use multiple cell IDs.

At the end of the day, what really matters for a DVB scan program
is that all center_frequency and transposer_frequency to be
added to the frequencies that will be scanned.

So, I'm thinking on a way to make a patch that would be
backward-compatible, e. g. adding both "centre_frequency" and
"transposer_frequency" at the centre_frequency table, and not
filling the subcell IDs, as the additional field there (the
subcell ID) is useless without the cell ID, and its parsing is
broken, anyway.

We may latter add a way to store the cell ID and subcell ID at the
end of the structure.

Regards,
Mauro
