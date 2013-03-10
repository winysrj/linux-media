Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3CJN6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 09:58:39 -0400
Date: Sun, 10 Mar 2013 10:58:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] bttv: fix audio mute on device close for the
 radio device node
Message-ID: <20130310105834.669a729a@redhat.com>
In-Reply-To: <513C8F04.70809@googlemail.com>
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
	<1362915635-5431-2-git-send-email-fschaefer.oss@googlemail.com>
	<201303101259.42692.hverkuil@xs4all.nl>
	<513C8F04.70809@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 10 Mar 2013 14:47:48 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 10.03.2013 12:59, schrieb Hans Verkuil:
> > On Sun March 10 2013 12:40:35 Frank Schäfer wrote:
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>  drivers/media/pci/bt8xx/bttv-driver.c |    5 ++++-
> >>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
> >>
> >> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> >> index 2c09bc5..74977f7 100644
> >> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> >> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> >> @@ -3227,6 +3227,7 @@ static int radio_open(struct file *file)
> >>  	v4l2_fh_init(&fh->fh, vdev);
> >>  
> >>  	btv->radio_user++;
> >> +	audio_mute(btv, btv->mute);
> >>  
> >>  	v4l2_fh_add(&fh->fh);
> >>  
> >> @@ -3248,8 +3249,10 @@ static int radio_release(struct file *file)
> >>  
> >>  	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
> >>  
> >> -	if (btv->radio_user == 0)
> >> +	if (btv->radio_user == 0) {
> >>  		btv->has_radio_tuner = 0;
> >> +		audio_mute(btv, 1);
> >> +	}
> >>  	return 0;
> >>  }
> >>  
> >>
> > Sorry, but this isn't right.
> >
> > You should be able to just set the radio to a frequency and then exit. Since
> > most cards have an audio out that loops to an audio input you don't want to
> > have to keep the radio device open.
> 
> Ok, so I will drop this patch.
> 
> AFAICS the above said also applies to the video device part, so it's
> still not clear to me why both devices should be handled differently.
> Anyway, I will regard it as a kind of "tradition".

It is not tradition. Changing it would break userspace. For example, xawtv's
"radio" program expects this behavior (see the "-q" and "-m" parameters).

A typical radio usage is to do:

	$ radio -f 93.7 -q

And when user is done listening to radio:

	$ radio -m

Of course, for the above to work, the user needs to have a board wired into
the audio device, or with an speaker directly connected into it.

Regards,
Mauro
