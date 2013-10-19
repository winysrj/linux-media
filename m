Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3JSQcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Oct 2013 12:32:50 -0400
Date: Sat, 19 Oct 2013 18:32:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
cc: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: make sure that all subdevices are powered on
 when needed
In-Reply-To: <5262570E.1020707@googlemail.com>
Message-ID: <Pine.LNX.4.64.1310191806060.19376@axis700.grange>
References: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com>
 <Pine.LNX.4.64.1310182228130.12288@axis700.grange> <5262570E.1020707@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank

On Sat, 19 Oct 2013, Frank Schäfer wrote:

> Am 18.10.2013 22:30, schrieb Guennadi Liakhovetski:
> > Hi Frank
> >
> > Thanks for the patch
> >
> > On Wed, 16 Oct 2013, Frank Schäfer wrote:
> >
> >> Commit 622b828ab7 ("v4l2_subdev: rename tuner s_standby operation to
> >> core s_power") replaced the tuner s_standby call in the em28xx driver with
> >> a (s_power, 0) call which suspends all subdevices.
> >> But it neglected to add corresponding (s_power, 1) calls to make sure that
> >> the subdevices are powered on again when needed.
> >>
> >> This patch fixes this issue by adding a (s_power, 1) call to
> >> function em28xx_wake_i2c().
> >>
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>  drivers/media/usb/em28xx/em28xx-core.c |    1 +
> >>  1 Datei geändert, 1 Zeile hinzugefügt(+)
> >>
> >> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> >> index fc157af..8896789 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-core.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> >> @@ -1243,6 +1243,7 @@ EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
> >>   */
> >>  void em28xx_wake_i2c(struct em28xx *dev)
> >>  {
> >> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);
> >>  	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
> >>  	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
> >>  			INPUT(dev->ctl_input)->vmux, 0, 0);
> > Do I understand it right, that you're proposing this as an alternative to 
> > my power-balancing patch?
> Yes.
> Your patch was nevertheless useful, because it pointed out further bugs
> in em28xx_v4l2_open().
> I've sent another RFC patch which should fix them, too.
> 
> >  It's certainly smaller and simpler, have you 
> > also tested it with the ov2640 and my clock patches to see, whether this 
> > really balances calls to .s_power() perfectly?
> Yes, I've tested the patch with the VAD Laplace webcam (ov2640), a
> Hauppauge HVR 900 and a Terratec Cinergy 200.
> Please note that the patch does not balance .s_power() calls perfectly,
> it only makes sure that the subdevices are powered on when needed.
> This also avoids the scary v4l2-clk warnings.

hmm, I'm not sure I quite understand - calls aren't balanced perfectly, 
but warnings are gone? Since warnings are gone, this means the use-count 
doesn't go negative. Does that mean, that now you enable the clock more 
often, then you disable it? Wouldn't it lock the driver module in the 
kernel via excessive module_get()? Or have I misunderstood something?

> Due to the various GPIO sequences, I see no chance to make s_power calls
> really balanced in such drivers.

I think those should be fixed actually. If there are indeed GPIO 
operations, that switch subdevice power on and off, they should be coded 
as such, perhaps as regulators. And - as discussed elsewhere - actually 
subdevice drivers should decide when power should be supplied to them, and 
when not.

Anyway, if your patch keeps the clock use count between 0 when unused and 
1, when used, I vote for it and would suggest to apply these fixes to 
em28xx. Mauro, can we do this? Shall we repost the set to make it easier?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
