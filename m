Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0F3UWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 16:22:25 -0400
Message-ID: <4C2BA772.4010305@redhat.com>
Date: Wed, 30 Jun 2010 17:22:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and losing blocks
References: <4C2BA19C.9080708@arcor.de>
In-Reply-To: <4C2BA19C.9080708@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-06-2010 16:57, Stefan Ringel escreveu:
> Hi Mauro,
> 
> I have tested your patch, but that logic to detect the end of urb is wrong. Many blocks going to lost. 
> byte 0x47 can 2 different state:
> 1. sync byte
> 2. data byte
> 
> Your logic has that problem, that if receive the new urb and search the new sync byte, the first 0x47 will use and 
> that are not always the sync byte.

Stefan,

> 
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date: Mon, 7 Jun 2010 15:10:14 +0000 (-0300)
>> Subject: tm6000: Fix copybuf continue logic
>> X-Git-Url: http://git.linuxtv.org/v4l-dvb.git?a=commitdiff_plain;h=dcdc55b917681378f84e6db26dcd56931ae2f1c8
>>
>> tm6000: Fix copybuf continue logic
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>
>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>> index 6bf2b13..9a0b5a7 100644
>> --- a/drivers/staging/tm6000/tm6000-video.c
>> +++ b/drivers/staging/tm6000/tm6000-video.c
>> @@ -285,7 +285,7 @@ static int copy_streams(u8 *data, unsigned long len,
>> 				break;
>> 			case TM6000_URB_MSG_AUDIO:
>> 			case TM6000_URB_MSG_PTS:
>> -				cpysize = pktsize;	/* Size is always 180 bytes */
>> +				size = pktsize;		/* Size is always 180 bytes */
>> 				break;
>> 			}

This is OK: with audio and TS URB's, the packet has always 180 bytes, and the "size" information
from the header is not used.

>> 		} else {
>> @@ -315,7 +315,7 @@ static int copy_streams(u8 *data, unsigned long len,
>> 				break;
>> 			}
>> 		}
>> -		if (ptr + pktsize > endp) {
>> +		if (cpysize < size) {
>> 			/* End of URB packet, but cmd processing is not
>> 			 * complete. Preserve the state for a next packet
>> 			 */
> 
> I think that is wrong
> 
>> @@ -323,7 +323,7 @@ static int copy_streams(u8 *data, unsigned long len,
>> 			dev->isoc_ctl.size = size - cpysize;
>> 			dev->isoc_ctl.cmd = cmd;
>> 			dev->isoc_ctl.pktsize = pktsize - (endp - ptr);
>> -			ptr += endp - ptr;
>> +			ptr += cpysize;
>> 		} else {
>> 			dev->isoc_ctl.cmd = 0;
>> 			ptr += pktsize;
> 
> dito
> 

Hm...
	cpysize = (endp - ptr > size) ? size : endp - ptr;

and size = pktsize (for Audio/PTS), this is OK for audio and PTS.

For VBI and video, "size" comes from the data package. It should be equal to 180 bytes
as well, but, if it is different than 180, then we may have a problem.

As, in practice, all packets have 180 byes of payload, and it is somewhat common to get
broken URB 's with this device, I agree that it is safer to reverse those two hunks.

Cheers,
Mauro.
