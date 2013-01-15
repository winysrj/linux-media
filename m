Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49413 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab3AORG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 12:06:27 -0500
Received: by mail-bk0-f52.google.com with SMTP id w5so210625bku.39
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 09:06:25 -0800 (PST)
Message-ID: <50F58CB1.8010305@googlemail.com>
Date: Tue, 15 Jan 2013 18:06:57 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] em28xx: return -ENOTTY for tuner + frequency ioctls if
 the device has no tuner
References: <1358081450-5705-1-git-send-email-fschaefer.oss@googlemail.com> <201301141020.24697.hverkuil@xs4all.nl>
In-Reply-To: <201301141020.24697.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2013 10:20, schrieb Hans Verkuil:
> On Sun January 13 2013 13:50:50 Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++++
>>  1 Datei geändert, 8 Zeilen hinzugefügt(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index 2eabf2a..4a7f73c 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -1204,6 +1204,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>>  	struct em28xx         *dev = fh->dev;
>>  	int                   rc;
>>  
>> +	if (dev->tuner_type == TUNER_ABSENT)
>> +		return -ENOTTY;
>>  	rc = check_dev(dev);
>>  	if (rc < 0)
>>  		return rc;
>> @@ -1224,6 +1226,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>>  	struct em28xx         *dev = fh->dev;
>>  	int                   rc;
>>  
>> +	if (dev->tuner_type == TUNER_ABSENT)
>> +		return -ENOTTY;
>>  	rc = check_dev(dev);
>>  	if (rc < 0)
>>  		return rc;
>> @@ -1241,6 +1245,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>>  	struct em28xx_fh      *fh  = priv;
>>  	struct em28xx         *dev = fh->dev;
>>  
>> +	if (dev->tuner_type == TUNER_ABSENT)
>> +		return -ENOTTY;
>>  	if (0 != f->tuner)
>>  		return -EINVAL;
>>  
>> @@ -1255,6 +1261,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>>  	struct em28xx         *dev = fh->dev;
>>  	int                   rc;
>>  
>> +	if (dev->tuner_type == TUNER_ABSENT)
>> +		return -ENOTTY;
>>  	rc = check_dev(dev);
>>  	if (rc < 0)
>>  		return rc;
>>
> Rather than doing this in each ioctl, I recommend using v4l2_disable_ioctl
> instead. See for example drivers/media/pci/ivtv/ivtv-streams.c.

Hmm, thanks.
I just did the same we currently do for the VIDIOC_G/S/QUERY_STD and
VIDIOC_G/S_AUDIO ioctls, but yeah, disabling seems to be better.
Btw, what about VIDIOC_G/S_PARAM ? Do they make sense for cameras ?

Regards,
Frank


