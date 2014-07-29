Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54152 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaG2Fhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 01:37:50 -0400
Message-ID: <53D73328.6040802@gentoo.org>
Date: Tue, 29 Jul 2014 07:37:44 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>
CC: Antti Palosaari <crope@iki.fi>, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>	<1406059938-21141-2-git-send-email-zzam@gentoo.org>	<53CF7E6D.20406@iki.fi>	<53D006F2.10300@gentoo.org> <20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>
In-Reply-To: <20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23.07.2014 22:10, Antonio Ospite wrote:
> On Wed, 23 Jul 2014 21:03:14 +0200
> Matthias Schwarzott <zzam@gentoo.org> wrote:
> 
> [...]
>> The crc value:
>> It protects the content of the file until it is in the demod - so
>> calculating it on my own would only check if the data is correctly
>> transferred from the driver into the chip.
>> But for this I needed to know the algorithm and which data is
>> checksummed exactly.
>>
>> Are the different algorithms for CRC values that give 16 bit of output?
>>
> 
> You could try jacksum[1] and see if any algorithm it supports
> gives you the expected result, there is a handful of 16 bits ones:
> 
>   jacksum -a all -F "#ALGONAME{i} = #CHECKSUM{i}" payload.bin
> 
Hi Antonio,

I tried jacksum on the complete firmware and on parts - but it never
matched the results from the chip.

I now found out, that the crc register changes after every 32bit write
to the data register - the fw control registers do not affect it.

So I can try what crc results from writing 32bit portions of data.
But even that did not help in guessing the algorithm, because I do not
want to do 100s of experiments.

some of my experiments:
crc=0x0000, data=0x00000000 -> crc=0x0000
crc=0x0000, data=0x00000001 -> crc=0x1021
crc=0x0000, data=0x00000002 -> crc=0x2042
crc=0x0000, data=0x00000004 -> crc=0x4084
crc=0x0000, data=0x00000008 -> crc=0x8108
crc=0x0000, data=0x00000010 -> crc=0x1231

Is there some systematic way to get the formula?
I can write arbitrary data and check what crc it results in.

I don't know if it is worth using the crc algorithm compared to storing
the crc with the firmware, because currently it is an end to end
verification of firmware data.

Regards
Matthias

