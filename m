Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:41725 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CJVsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:48:45 -0400
Received: by mail-ea0-f180.google.com with SMTP id j14so875496eak.11
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:48:44 -0700 (PDT)
Message-ID: <513CFFED.1010409@googlemail.com>
Date: Sun, 10 Mar 2013 22:49:33 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] bttv: fix audio mute on device close for the
 radio device node
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com> <201303101259.42692.hverkuil@xs4all.nl> <513C8F04.70809@googlemail.com> <201303101456.21102.hverkuil@xs4all.nl>
In-Reply-To: <201303101456.21102.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.03.2013 14:56, schrieb Hans Verkuil:
> On Sun March 10 2013 14:47:48 Frank Schäfer wrote:
>> Am 10.03.2013 12:59, schrieb Hans Verkuil:
>>> On Sun March 10 2013 12:40:35 Frank Schäfer wrote:
>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>> ---
>>>>  drivers/media/pci/bt8xx/bttv-driver.c |    5 ++++-
>>>>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
>>>>
>>>> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
>>>> index 2c09bc5..74977f7 100644
>>>> --- a/drivers/media/pci/bt8xx/bttv-driver.c
>>>> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
>>>> @@ -3227,6 +3227,7 @@ static int radio_open(struct file *file)
>>>>  	v4l2_fh_init(&fh->fh, vdev);
>>>>  
>>>>  	btv->radio_user++;
>>>> +	audio_mute(btv, btv->mute);
>>>>  
>>>>  	v4l2_fh_add(&fh->fh);
>>>>  
>>>> @@ -3248,8 +3249,10 @@ static int radio_release(struct file *file)
>>>>  
>>>>  	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
>>>>  
>>>> -	if (btv->radio_user == 0)
>>>> +	if (btv->radio_user == 0) {
>>>>  		btv->has_radio_tuner = 0;
>>>> +		audio_mute(btv, 1);
>>>> +	}
>>>>  	return 0;
>>>>  }
>>>>  
>>>>
>>> Sorry, but this isn't right.
>>>
>>> You should be able to just set the radio to a frequency and then exit. Since
>>> most cards have an audio out that loops to an audio input you don't want to
>>> have to keep the radio device open.
>> Ok, so I will drop this patch.
>>
>> AFAICS the above said also applies to the video device part, so it's
>> still not clear to me why both devices should be handled differently.
>> Anyway, I will regard it as a kind of "tradition".
> It is legacy. I doubt we would design it like that today. Also note that
> there is generally little point in just listening to TV without actually
> watching it (although some people do :-) ), so it makes sense to mute the
> audio when you stop watching TV.
>
> But radio has traditionally been implemented this way and we have to keep
> that.
>
> Regards,
>
> 	Hans
>

[...]

Am 10.03.2013 14:58, schrieb Mauro Carvalho Chehab:
...
> It is not tradition. Changing it would break userspace. For example, xawtv's
> "radio" program expects this behavior (see the "-q" and "-m" parameters).
>
> A typical radio usage is to do:
>
> 	$ radio -f 93.7 -q
>
> And when user is done listening to radio:
>
> 	$ radio -m
>
> Of course, for the above to work, the user needs to have a board wired into
> the audio device, or with an speaker directly connected into it.
>
> Regards,
> Mauro

Fair enough, thanks for your explanations.
Please excuse my questions about issues like this.
Without knowing the history and the reasons for the initial design
decisions it's sometimes difficult to understand why things are working
as they are and if they need to be fixed.

Regards,
Frank

