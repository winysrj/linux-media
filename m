Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3322 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3LPIzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 03:55:44 -0500
Message-ID: <52AEBFF0.4040404@xs4all.nl>
Date: Mon, 16 Dec 2013 09:55:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v2 0/7] V4L2 SDR API
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <52AC8B20.906@iki.fi> <52AC8FD6.2080504@xs4all.nl> <52AC99C1.4050108@iki.fi>
In-Reply-To: <52AC99C1.4050108@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2013 06:47 PM, Antti Palosaari wrote:
> On 14.12.2013 19:05, Hans Verkuil wrote:
>> On 12/14/2013 05:45 PM, Antti Palosaari wrote:
>>> Hello
>>> One possible problem I noticed is device node name.
>>>
>>> Documentation/devices.txt
>>>
>>>    65 block	SCSI disk devices (16-31)
>>> 		  0 = /dev/sdq		17th SCSI disk whole disk
>>> 		 16 = /dev/sdr		18th SCSI disk whole disk
>>> 		 32 = /dev/sds		19th SCSI disk whole disk
>>> 		    ...
>>> 		240 = /dev/sdaf		32nd SCSI disk whole disk
>>>
>>> 		Partitions are handled in the same way as for IDE
>>> 		disks (see major number 3) except that the limit on
>>> 		partitions is 15.
>>>
>>>
>>>    81 char	video4linux
>>> 		  0 = /dev/video0	Video capture/overlay device
>>> 		    ...
>>> 		 63 = /dev/video63	Video capture/overlay device
>>> 		 64 = /dev/radio0	Radio device
>>> 		    ...
>>> 		127 = /dev/radio63	Radio device
>>> 		224 = /dev/vbi0		Vertical blank interrupt
>>> 		    ...
>>> 		255 = /dev/vbi31	Vertical blank interrupt
>>>
>>>
>>> What I understand, /dev/sdr is not suitable node name as it conflicts
>>> with existing node name.
>>
>> Good catch, that won't work :-)
>>
>>> Any ideas?
>>
>> /dev/sdradio?
> 
> /dev/swradio?
> 
> 
> Lets do a small poll here. Everyone, but me, has a one vote ;)

I'm happy with swradio as well. It's probably better than sdradio, namespace-wise.

Regards,

	Hans
