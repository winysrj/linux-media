Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:63215 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AWP5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 10:57:05 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so9007546lab.29
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 07:57:03 -0800 (PST)
Message-ID: <51000874.7080607@googlemail.com>
Date: Wed, 23 Jan 2013 16:57:40 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tuner-core: return tuner name with ioctl VIDIOC_G_TUNER
References: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com> <201301230835.29623.hverkuil@xs4all.nl>
In-Reply-To: <201301230835.29623.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.01.2013 08:35, schrieb Hans Verkuil:
> On Tue January 22 2013 20:46:21 Frank Schäfer wrote:
>> tuner_g_tuner() is supposed to fill struct v4l2_tuner passed by ioctl
>> VIDIOC_G_TUNER, but misses setting the name field.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> Cc: stable@kernel.org
>> ---
>>  drivers/media/v4l2-core/tuner-core.c |    1 +
>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>>
>> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
>> index b5a819a..95a47cf 100644
>> --- a/drivers/media/v4l2-core/tuner-core.c
>> +++ b/drivers/media/v4l2-core/tuner-core.c
>> @@ -1187,6 +1187,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>>  
>>  	if (check_mode(t, vt->type) == -EINVAL)
>>  		return 0;
>> +	strcpy(vt->name, t->name);
>>  	if (vt->type == t->mode && analog_ops->get_afc)
>>  		vt->afc = analog_ops->get_afc(&t->fe);
>>  	if (analog_ops->has_signal)
>>
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> And the reason is that the tuner field should be filled in by the bridge
> driver. That's because you may have multiple tuners and it's only the
> bridge driver that will know which tuner is which and what name to give
> it.

Hmmm... I don't understand.
Isn't his a per-tuner (subdev) operation ? If a device has multiple
tuners (subdevs) it is called for each of them.
So how can the returned tuner name be wrong and why should the bridge
driver know better than the subdevice itself which name is correct ?

Regards,
Frank


> Regards,
>
> 	Hans

