Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:59220 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0IOLiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 07:38:07 -0400
Subject: Re: [PATCH v9 3/4] V4L2: WL1273 FM Radio: Controls for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <4C87DF68.7070900@redhat.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1283168302-19111-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1283168302-19111-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1283168302-19111-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <4C87DF68.7070900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 14:36:22 +0300
Message-ID: <1284550582.25428.79.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi.

On Wed, 2010-09-08 at 21:09 +0200, ext Mauro Carvalho Chehab wrote:
> > +static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
> > +                                 struct v4l2_tuner *tuner)
> > +{
> > +     struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> > +     struct wl1273_core *core = radio->core;
> > +     int r = 0;
> > +
> > +     dev_dbg(radio->dev, "%s\n", __func__);
> > +     dev_dbg(radio->dev, "tuner->index: %d\n", tuner->index);
> > +     dev_dbg(radio->dev, "tuner->name: %s\n", tuner->name);
> > +     dev_dbg(radio->dev, "tuner->capability: 0x%04x\n", tuner->capability);
> > +     dev_dbg(radio->dev, "tuner->rxsubchans: 0x%04x\n", tuner->rxsubchans);
> > +     dev_dbg(radio->dev, "tuner->rangelow: %d\n", tuner->rangelow);
> > +     dev_dbg(radio->dev, "tuner->rangehigh: %d\n", tuner->rangehigh);
> 
> Ranges should be using tuner->rangelow/rangehigh to change band limits.

I just want to make sure that I understand you correctly. So the idea is
that with the g_tuner the driver can tell the frequency range that's
supported by the chip in RX mode, which is 76MHz to 108 MHz. The lowest
part is in the Japan band and the highest is in the Europe/USA band, the
middle section can be either...

Then the application can choose any sub-range of the above by calling
s_tuner with any values rangelow > 76MHz and rangehigh < 108MHz? After
that the driver just deals with the given frequencies by changing the
band if necessary?

Cheers,
Matti






