Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52213 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3A2Rhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 12:37:40 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so389757eek.28
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 09:37:39 -0800 (PST)
Message-ID: <5108090D.7080804@googlemail.com>
Date: Tue, 29 Jan 2013 18:38:21 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 11/12] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT
 available for radio devices
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com> <1359134822-4585-12-git-send-email-fschaefer.oss@googlemail.com> <201301281100.55798.hverkuil@xs4all.nl>
In-Reply-To: <201301281100.55798.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.01.2013 11:00, schrieb Hans Verkuil:
> On Fri January 25 2013 18:27:01 Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-video.c |    1 +
>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index dd05cfb..e97b095 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -1695,6 +1695,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>  	.vidioc_g_register    = vidioc_g_register,
>>  	.vidioc_s_register    = vidioc_s_register,
>> +	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
>>  #endif
>>  };
>>  
>>
> g_chip_ident can be moved out of ADV_DEBUG, both for video and radio devices.

Yes it can but I wasn't sure if we really should change it.
Anyway, with your vote for changing it, I will be glad to send a patch
(it's an additional change and I don't need to send a V2 of the series
then, which also makes life easier for Mauro).

Regards,
Frank

> Regards,
>
> 	Hans

