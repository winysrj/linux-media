Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47048 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751511AbZCIWDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 18:03:33 -0400
Message-ID: <49B59230.1090305@gmx.de>
Date: Mon, 09 Mar 2009 23:03:28 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: V4L2 spec
References: <200903061523.15766.hverkuil@xs4all.nl> <49B14D3C.3010001@gmx.de> <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
In-Reply-To: <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> I think so. The better would be to convert DVB api to docbook (as used 
> by all other kernel documents), and add a developers document for the 
> kernel API for both at the kernel documentation structure).
>
> However, this is a huge task that someone should volunteer for doing, 
> otherwise, it won't happen.
>
> Cheers,
> Mauro
>
Sorry Mauro,

but i disagree with you.

Its a bad idea to expect someone else, the magic volunteer, doing work 
with *deep impact* on the dvb driver API structure or documentation.
Working on this topic determines complete usability of the driver, so 
MAIN DEVELOPERS have to REVIEW and CONTRIBUTE.
If they think, that they cannot do such work in parallel, they should to 
stop work on drivers for some time.

Status from application side of view at the moment: *not usable* without 
re-inventing the wheel.

The very same with the structures in frontend.h, a lot of things are not 
understandable. I give you some examples (i could give more...):

-  TRANSMISSION_MODE_4K is missing, but still mentioned in 300468 
v.1.9.1  "6.2.13.4 Terrestrial delivery system descriptor"
-  the same for BANDWIDTH_5_MHZ, also 300468 v.1.9.1  "6.2.13.4 
Terrestrial delivery system descriptor"
-  POLARIZATION for QPSK frontends  is nowhere defined in frontend.h at 
all, forcing applications to do its own definitions,
     "6.2.13.2 Satellite delivery system descriptor" gives clear 
definitions - so why are they not defined in frontend.h?
-  ATSC frontends are mixed cable and terrestrian, whereas older DVB-C 
and DVB-T are *strictly* separated
-  struct dvb_qpsk_parameters is missing (at least!) to be usable again
    * fe_modulation_t
    * fe_pilot_t
    * fe_rolloff_t
    * fe_delivery_system_t
    * west_east_flag
    * scrambling_sequence_selector
    * multiple_input_stream_flag

- nearly the same for dvb_qam_parameters, dvb_ofdm_parameters, 
dvb_atsc_parameters..., at least delivery_system needs to be here

Working on documentation would fix *all* of this problems.

Regards,
Winfried
