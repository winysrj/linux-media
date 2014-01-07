Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53225 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaAGQ7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 11:59:01 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so336566eaj.12
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 08:59:00 -0800 (PST)
Message-ID: <52CC3297.4020706@googlemail.com>
Date: Tue, 07 Jan 2014 18:00:07 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 13/22] [media] em28xx: initialize audio latter
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-14-git-send-email-m.chehab@samsung.com> <52C94207.1050101@googlemail.com> <20140105111750.353b5916@samsung.com>
In-Reply-To: <20140105111750.353b5916@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2014 14:17, schrieb Mauro Carvalho Chehab:
> Em Sun, 05 Jan 2014 12:29:11 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
>>> Better to first write the GPIOs of the input mux, before initializing
>>> the audio.
>> Why are you making this change ?
>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx-video.c | 40 ++++++++++++++++-----------------
>>>  1 file changed, 20 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>>> index b767262c642b..328d724a13ea 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>>> @@ -2291,26 +2291,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>>>  	em28xx_tuner_setup(dev);
>>>  	em28xx_init_camera(dev);
>>>  
>>> -	/* Configure audio */
>>> -	ret = em28xx_audio_setup(dev);
>>> -	if (ret < 0) {
>>> -		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
>>> -			__func__, ret);
>>> -		goto err;
>>> -	}
>>> -	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
>>> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
>>> -			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
>>> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
>>> -			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
>>> -	} else {
>>> -		/* install the em28xx notify callback */
>>> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
>>> -				em28xx_ctrl_notify, dev);
>>> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
>>> -				em28xx_ctrl_notify, dev);
>>> -	}
>>> -
>>>  	/* wake i2c devices */
>>>  	em28xx_wake_i2c(dev);
>>>  
>>> @@ -2356,6 +2336,26 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>>>  
>>>  	video_mux(dev, 0);
>>>  
>>> +	/* Configure audio */
>>> +	ret = em28xx_audio_setup(dev);
>>> +	if (ret < 0) {
>>> +		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
>>> +			__func__, ret);
>>> +		goto err;
>>> +	}
>>> +	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
>>> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
>>> +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
>>> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
>>> +			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
>>> +	} else {
>>> +		/* install the em28xx notify callback */
>>> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
>>> +				em28xx_ctrl_notify, dev);
>>> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
>>> +				em28xx_ctrl_notify, dev);
>>> +	}
>>> +
>>>  	/* Audio defaults */
>>>  	dev->mute = 1;
>>>  	dev->volume = 0x1f;
>> Well, the v4l/core split didn't change the order.
>> And if the current order would be wrong, then you would also have to
>> call audio_setup() each time the user switches the input.
> Maybe this is needed anyway. Btw, there's a bug on xawtv: if you maximize
> a window, audio stops playing. I didn't have time yet to identify why.
>
>> So unless you are trying to fix a real bug, I wouldn't change it.
>> The current order is sane and we likely could never change it back later
>> without risking regressions...
> Sometimes, ac97 is not properly detected here with HVR-950. Not sure
> what happens. I need to do more tests. Perhaps it happens only on USB 3.0
> ports.
So you are making yet another change to fix a bug, although you even
haven't identified yet what the bug is ?

> In any case, it makes sense to first wake up I2C devices, then to set
> the video mux, before start probing for audio, as the audio setting
> may depend on the video mux settings.
>
You are ignoring what I said.

1.) If the current order would really be wrong, we would have bugs. But
we don't know any bugs caused by the current order.
2.) If you change the order, it is also necessary to wake up or even do
the whole setup again after each input switch (video_mux() call).
This patch misses this fix. So there is a chance that you are causing
regressions.
3.) We can always do this change later, but we likely can't revert it
anymore after a while (without retesting all device that have been added
in the meantime)

The whole gpio sequences stuff and its unknown effects on the
power/reset state of the subdevices has already turned em28xx
maintenance into a nightmare.
There is lots of problematic code which can never be fixed without
testing all ~100 devices.
Let's not walk needlessly into the same trap with yet another piece of code.


