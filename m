Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:48879 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1ELUle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 16:41:34 -0400
Message-ID: <4DCC45D7.8090405@usa.net>
Date: Thu, 12 May 2011 22:40:55 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	S-bastien RAILLARD <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
In-Reply-To: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11/05/11 15:12, Issa Gorissen wrote:
> From: Ralph Metzler <rjkm@metzlerbros.de>
>> Issa Gorissen writes:
>>  > Could you please take a look at the cxd2099 issues ?
>>  > 
>>  > I have attached a version with my changes. I have tested a lot of
>>  > different settings with the help of the chip datasheet.
>>  > 
>>  > Scrambled programs are not handled correctly. I don't know if it is the
>>  > TICLK/MCLKI which is too high or something, or the sync detector ? Also,
>>  > as we have to set the TOCLK to max of 72MHz, there are way too much null
>>  > packets added. Is there a way to solve this ?
>>
>> I do not have any cxd2099 issues.
>> I have a simple test program which includes a 32bit counter as payload 
>> and can pump data through the CI with full speed and have no packet
>> loss. I only tested decoding with an ORF stream and an Alphacrypt CAM
>> but also had no problems with this.
>>
>> Please take care not to write data faster than it is read. Starting two
>> dds will not guarantee this. To be certain you could write a small
>> program which never writes more packets than input buffer size minus
>> the number of read packets (and minus the stuffing null packets on ngene).
>>
>> Before blaming packet loss on the CI data path also please make
>> certain that you have no buffer overflows in the input part of 
>> the sec device.
>> In the ngene driver you can e.g. add a printk in tsin_exchange():
>>
>> if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
>> ...
>> } else
>>     printk ("buffer overflow !!!!\n");
>>
>>
>> Regards,
>> Ralph
Ralph,

Done some more tests, from by test tool, I found out that I have to skip
(rather often) bytes to find the sync one when reading from sec0. I
thought I only needed to do that at the start of the stream, not in the
middle; because I always read/write 188 bytes from it.

Could you share your test code ? I'm finding it difficult to interact
with this sec0 implementation.

Thx
--
Issa
