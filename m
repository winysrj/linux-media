Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57888 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3CORh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 13:37:26 -0400
Received: by mail-ee0-f43.google.com with SMTP id c50so1686819eek.30
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2013 10:37:25 -0700 (PDT)
Message-ID: <51435C87.6050405@googlemail.com>
Date: Fri, 15 Mar 2013 18:38:15 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/6] bttv: audio_mux(): do not change the value
 of the v4l2 mute control
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com> <1362952434-2974-3-git-send-email-fschaefer.oss@googlemail.com> <201303121441.16715.hverkuil@xs4all.nl>
In-Reply-To: <201303121441.16715.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for reviewing and sorry for the delayed reply !

Am 12.03.2013 14:41, schrieb Hans Verkuil:
> On Sun 10 March 2013 22:53:50 Frank Schäfer wrote:
>> There are cases where we want to call audio_mux() without changing the value of
>> the v4l2 mute control, for example
>> - mute mute on last close
>> - mute on device probing
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> I think it might be a good idea to take this one step further: pull the
> btv->audio assignment out of audio_mux as well. In other words, audio_mux
> no longer changes the bttv state.

Yes, that should be easy to do.

> I also think that the audio_mute and audio_input functions should be
> removed, just let the code call audio_mux directly. I think that is more
> transparent and one less intermediate call.

OTOH I think they improve readability.
Anyway, this will become obsolete with the next step you're suggesting:

> A next step would be to untangle the audio routing code and mute code
> from audio_mux: that's probably the core of all the confusion. The code
> relating to the input selection should be put in a separate function that
> is called only when you really want to switch inputs.

Yeah, it would be nice if we could do that, but I'm not sure if it's
entirely possible.
Mute + automute and the selected input seem to be coupled via gpio
settings. See the first third
of function audio_mux().
I will have to take a deeper look into the code to see if splitting the
function really makes sense...

> I'm not sure if you want to spend time on that last step, if not, then just
> do the first two suggestions and I'll test the result. But without really
> going to the core of the problem (one function mixing up muting and input
> selection) it remains hard to prove correctness of the code. If you have
> some time, then it would be very nice if this mess can be resolved once and
> for all.

I've put it on my TODO list, but I'm not sure if I'll find some time for
it this weekend.

Regards,
Frank

> Regards,
>
> 	Hans
>
>> ---
>>  drivers/media/pci/bt8xx/bttv-driver.c |    8 ++++----
>>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
>> index a584d82..a082ab4 100644
>> --- a/drivers/media/pci/bt8xx/bttv-driver.c
>> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
>> @@ -999,7 +999,6 @@ audio_mux(struct bttv *btv, int input, int mute)
>>  		   bttv_tvcards[btv->c.type].gpiomask);
>>  	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
>>  
>> -	btv->mute = mute;
>>  	btv->audio = input;
>>  
>>  	/* automute */
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
>>

