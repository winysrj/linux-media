Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1311 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CJN4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 09:56:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 2/2] bttv: fix audio mute on device close for the radio device node
Date: Sun, 10 Mar 2013 14:56:21 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com> <201303101259.42692.hverkuil@xs4all.nl> <513C8F04.70809@googlemail.com>
In-Reply-To: <513C8F04.70809@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303101456.21102.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 10 2013 14:47:48 Frank Schäfer wrote:
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

It is legacy. I doubt we would design it like that today. Also note that
there is generally little point in just listening to TV without actually
watching it (although some people do :-) ), so it makes sense to mute the
audio when you stop watching TV.

But radio has traditionally been implemented this way and we have to keep
that.

Regards,

	Hans

> 
> >
> > Audio should be muted when the module is unloaded, though.
> >
> > The relationship between TV and radio tuners was discussed last year. The
> > following proposal was accepted:
> >
> > ------- start -----------
> > How to handle tuner ownership if both a video and radio node share the same
> > tuner?
> >
> > Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will make the filehandle
> > the owner if possible. EBUSY is returned if someone else owns the tuner and you
> > would need to switch the tuner mode.
> >
> > Ditto for ioctls that expect a valid tuner configuration like QUERYSTD. This is
> > likely to be driver dependent, though. Just opening a device node should not
> > switch ownership.
> >
> > G_FREQUENCY: should just return the last set frequency for radio or TV: requires
> > that that is remembered when switching ownership. This is what happens today, so
> > G_FREQUENCY does not have to switch ownership.
> >
> > G_TUNER: the rxsubchans, signal and afc fields all require ownership of the tuner.
> > So in principle you would want to switch ownership when G_TUNER is called. On the
> > other hand, that would mean that calling v4l2-ctl --all -d /dev/radio0 would change
> > tuner ownership to radio for /dev/video0. That's rather unexpected.
> >
> > So just set rxsubchans, signal and afc to 0 if the device node doesn't own the tuner.
> >
> > Closing a device node should not switch ownership. E.g. if nobody has a radio device
> > open, should the tuner switch back to TV mode automatically? The answer is that it
> > shouldn't.
> >
> > How about hybrid tuners? The code to handle tuner ownership should be shared between
> > DVB and V4L2.
> > ----------- end --------------
> >
> > All very nice, but nobody had the chance to actually work on this.
> >
> > But this is how it should work.
> 
> Interesting, thanks !
> 
> Regards,
> Frank
> 
> >
> > Regards,
> >
> > 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
