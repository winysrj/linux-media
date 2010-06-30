Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:50912 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab0F3VaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 17:30:05 -0400
Message-ID: <4C2BB75A.1040902@arcor.de>
Date: Wed, 30 Jun 2010 23:30:02 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and losing blocks
References: <4C2BA19C.9080708@arcor.de> <4C2BA772.4010305@redhat.com>
In-Reply-To: <4C2BA772.4010305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.06.2010 22:22, schrieb Mauro Carvalho Chehab:
> Em 30-06-2010 16:57, Stefan Ringel escreveu:
>   
>> Hi Mauro,
>>
>> I have tested your patch, but that logic to detect the end of urb is wrong. Many blocks going to lost. 
>> byte 0x47 can 2 different state:
>> 1. sync byte
>> 2. data byte
>>
>> Your logic has that problem, that if receive the new urb and search the new sync byte, the first 0x47 will use and 
>> that are not always the sync byte.
>>     
> Stefan,
>
>   
>>     
>>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Date: Mon, 7 Jun 2010 15:10:14 +0000 (-0300)
>>> Subject: tm6000: Fix copybuf continue logic
>>> X-Git-Url: http://git.linuxtv.org/v4l-dvb.git?a=commitdiff_plain;h=dcdc55b917681378f84e6db26dcd56931ae2f1c8
>>>
>>> tm6000: Fix copybuf continue logic
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> ---
>>>
>>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>>> index 6bf2b13..9a0b5a7 100644
>>> --- a/drivers/staging/tm6000/tm6000-video.c
>>> +++ b/drivers/staging/tm6000/tm6000-video.c
>>> @@ -285,7 +285,7 @@ static int copy_streams(u8 *data, unsigned long len,
>>> 				break;
>>> 			case TM6000_URB_MSG_AUDIO:
>>> 			case TM6000_URB_MSG_PTS:
>>> -				cpysize = pktsize;	/* Size is always 180 bytes */
>>> +				size = pktsize;		/* Size is always 180 bytes */
>>> 				break;
>>> 			}
>>>       
> This is OK: with audio and TS URB's, the packet has always 180 bytes, and the "size" information
> from the header is not used.
>
>   
>>> 		} else {
>>> @@ -315,7 +315,7 @@ static int copy_streams(u8 *data, unsigned long len,
>>> 				break;
>>> 			}
>>> 		}
>>> -		if (ptr + pktsize > endp) {
>>> +		if (cpysize < size) {
>>> 			/* End of URB packet, but cmd processing is not
>>> 			 * complete. Preserve the state for a next packet
>>> 			 */
>>>       
>> I think that is wrong
>>
>>     
>>> @@ -323,7 +323,7 @@ static int copy_streams(u8 *data, unsigned long len,
>>> 			dev->isoc_ctl.size = size - cpysize;
>>> 			dev->isoc_ctl.cmd = cmd;
>>> 			dev->isoc_ctl.pktsize = pktsize - (endp - ptr);
>>> -			ptr += endp - ptr;
>>> +			ptr += cpysize;
>>> 		} else {
>>> 			dev->isoc_ctl.cmd = 0;
>>> 			ptr += pktsize;
>>>       
>> dito
>>
>>     
> Hm...
> 	cpysize = (endp - ptr > size) ? size : endp - ptr;
>
> and size = pktsize (for Audio/PTS), this is OK for audio and PTS.
>
> For VBI and video, "size" comes from the data package. It should be equal to 180 bytes
> as well, but, if it is different than 180, then we may have a problem.
>
> As, in practice, all packets have 180 byes of payload, and it is somewhat common to get
> broken URB 's with this device, I agree that it is safer to reverse those two hunks.
>
> Cheers,
> Mauro.
>   
Mauro here the log without your patch and enable vbi, t (numbers of
frames), t1 (time in seconds), t2 (rest time in milliseconds) are from
pts (sequence of 4 bytes filled to 180 bytes) decoding:

Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521501] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521503] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521504] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521506] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521508] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521510] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521511] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521513] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521515] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521516] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521518] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.521520] 4299325817: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538785] 4299325834: cmd=pts,
size=180
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538789] t 0x000135e8, t1
0x00000632, t2 0x000002d0
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538791] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538793] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538795] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538797] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538798] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538800] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538802] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538804] 4299325834: cmd=vbi,
size=28
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538805] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538807] 4299325834: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538809] 4299325834: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538810] 4299325834: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.538812] 4299325834: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561741] 4299325857: cmd=pts,
size=180
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561745] t 0x000135e9, t1
0x00000632, t2 0x000002e4
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561747] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561750] 4299325857: cmd=vbi,
size=40
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561751] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561753] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561755] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561757] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561759] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561761] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561763] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561765] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561766] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561768] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561770] 4299325857: cmd=vbi,
size=16
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.561772] 4299325857: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=pts,
size=180
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] t 0x000135ea, t1
0x00000632, t2 0x000002f8
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=68
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=44
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.579007] 4299325874: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601981] 4299325897: cmd=pts,
size=180
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601985] t 0x000135eb, t1
0x00000632, t2 0x0000030c
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601987] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601989] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601991] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601992] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601994] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601995] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601997] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.601999] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.602000] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.602002] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.602004] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.602006] 4299325897: cmd=vbi,
size=48
Jun 30 23:21:15 linux-b5ii kernel: [ 4658.602007] 4299325897: cmd=vbi,
size=32

-- 
Stefan Ringel <stefan.ringel@arcor.de>

