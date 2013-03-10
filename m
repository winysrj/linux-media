Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40761 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3CJNzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 09:55:35 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so1735440eek.8
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 06:55:34 -0700 (PDT)
Message-ID: <513C9107.6030408@googlemail.com>
Date: Sun, 10 Mar 2013 14:56:23 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] bttv: fix audio mute on device close for the
 video device node
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com> <201303101301.00039.hverkuil@xs4all.nl>
In-Reply-To: <201303101301.00039.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.03.2013 13:00, schrieb Hans Verkuil:
> On Sun March 10 2013 12:40:34 Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Could you describe exactly what bug is fixed? I tested it a fair amount
> when I created my bttv patches, so I'd like to know what I missed.

Yeah, sure. The whole thing is a bit tricky and I have to admit that the
patch isn't self-explaining enough.

The main issue it fixes is, that audio_mux() is called with the current
value of the mute control instead of mute=1.
So the device is muted on last close only if the mute control was 1.
Fixing this needs changing some other parts of the code, too.

What makes the patch bit complicated is the fact, that there are
actually two types of "mute" handled in function audio_mux():
1) gpio mute
2) subdevice muting
The "automute" feature also does its best to make things complicating.

And finally a follow-up fix is needed to avoid device unmuting already
when the drivers probing function is called (should not happen before
the first open).

Hmm... sorry... I should really have split this into two patches.
I will send an updated patch series with better explanations.

Regards,
Frank

>
> Regards,
>
> 	Hans
>
>> ---
>>  drivers/media/pci/bt8xx/bttv-driver.c |   22 +++++++++++-----------
>>  1 Datei geändert, 11 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
>> index 8610b6a..2c09bc5 100644
>> --- a/drivers/media/pci/bt8xx/bttv-driver.c
>> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
>> @@ -992,21 +992,20 @@ static char *audio_modes[] = {
>>  static int
>>  audio_mux(struct bttv *btv, int input, int mute)
>>  {
>> -	int gpio_val, signal;
>> +	int gpio_val, signal, mute_gpio;
>>  	struct v4l2_ctrl *ctrl;
>>  
>>  	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
>>  		   bttv_tvcards[btv->c.type].gpiomask);
>>  	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
>>  
>> -	btv->mute = mute;
>>  	btv->audio = input;
>>  
>>  	/* automute */
>> -	mute = mute || (btv->opt_automute && (!signal || !btv->users)
>> +	mute_gpio = mute || (btv->opt_automute && (!signal || !btv->users)
>>  				&& !btv->has_radio_tuner);
>>  
>> -	if (mute)
>> +	if (mute_gpio)
>>  		gpio_val = bttv_tvcards[btv->c.type].gpiomute;
>>  	else
>>  		gpio_val = bttv_tvcards[btv->c.type].gpiomux[input];
>> @@ -1022,7 +1021,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>>  	}
>>  
>>  	if (bttv_gpio)
>> -		bttv_gpio_tracking(btv, audio_modes[mute ? 4 : input]);
>> +		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
>>  	if (in_interrupt())
>>  		return 0;
>>  
>> @@ -1031,7 +1030,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>>  
>>  		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>>  		if (ctrl)
>> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
>> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>>  
>>  		/* Note: the inputs tuner/radio/extern/intern are translated
>>  		   to msp routings. This assumes common behavior for all msp3400
>> @@ -1080,7 +1079,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>>  		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>>  
>>  		if (ctrl)
>> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
>> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>>  		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
>>  				input, 0, 0);
>>  	}
>> @@ -1088,7 +1087,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>>  		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>>  
>>  		if (ctrl)
>> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
>> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>>  	}
>>  	return 0;
>>  }
>> @@ -1300,6 +1299,7 @@ static int bttv_s_ctrl(struct v4l2_ctrl *c)
>>  		break;
>>  	case V4L2_CID_AUDIO_MUTE:
>>  		audio_mute(btv, c->val);
>> +		btv->mute = c->val;
>>  		break;
>>  	case V4L2_CID_AUDIO_VOLUME:
>>  		btv->volume_gpio(btv, c->val);
>> @@ -3062,8 +3062,7 @@ static int bttv_open(struct file *file)
>>  			    sizeof(struct bttv_buffer),
>>  			    fh, &btv->lock);
>>  	set_tvnorm(btv,btv->tvnorm);
>> -	set_input(btv, btv->input, btv->tvnorm);
>> -
>> +	set_input(btv, btv->input, btv->tvnorm); /* also (un)mutes audio */
>>  
>>  	/* The V4L2 spec requires one global set of cropping parameters
>>  	   which only change on request. These are stored in btv->crop[1].
>> @@ -3124,7 +3123,7 @@ static int bttv_release(struct file *file)
>>  	bttv_field_count(btv);
>>  
>>  	if (!btv->users)
>> -		audio_mute(btv, btv->mute);
>> +		audio_mute(btv, 1);
>>  
>>  	v4l2_fh_del(&fh->fh);
>>  	v4l2_fh_exit(&fh->fh);
>> @@ -4209,6 +4208,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
>>  	btv->std = V4L2_STD_PAL;
>>  	init_irqreg(btv);
>>  	v4l2_ctrl_handler_setup(hdl);
>> +	audio_mute(btv, 1);
>>  
>>  	if (hdl->error) {
>>  		result = hdl->error;
>>

