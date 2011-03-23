Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1CWCsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 22:48:13 -0400
Received: by fxm17 with SMTP id 17so6976748fxm.19
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 19:48:12 -0700 (PDT)
Date: Wed, 23 Mar 2011 11:49:52 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tm6000: fix s-video input
Message-ID: <20110323114952.4ddedfb1@glory.local>
In-Reply-To: <4D845160.8030509@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
	<20110120150508.53c9b55e@glory.local>
	<4D388C44.7040500@arcor.de>
	<20110217141257.6d1b578b@glory.local>
	<4D5D8BFB.4070802@redhat.com>
	<20110318090855.773af168@glory.local>
	<4D845160.8030509@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stefan

> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Am 18.03.2011 01:08, schrieb Dmitri Belimov:
> > Hi
> >
> > Add compatibility for composite and s-video inputs. Some TV cards
> hasn't it.
> > Fix S-Video input, the s-video cable has only video signals no
> > audio.
> Call the function of audio configure kill chroma in signal. only b/w
> video.
> >
> > Known bugs:
> > after s-video the audio for radio didn't work, TV crashed hardly
> > after composite TV crashed hardly too.
> >
> > P.S. After this patch I'll want to rework the procedure of configure
> video. Now it has a lot of junk and dubles.
> >
> 
> Why you use caps to define video input and audio with avideo and/or
> aradio as flags? Better is , I think,  we use a struct for edge
> virtual input (Video type (s-vhs, composite, tuner), video input pin
> (video port a, video port b or both), video mode gpio, audio type ,
> audio input pin (adc 1, adc 2 or sif)). If we are called
> vidioc_s_input or radio_g_input setting input number. In tm6000_std.c
> we can use this input number and the input struct with the same number
> and can use all setting from here to set it.

It's very intresting but right now much better for me make full-working TV cards.
You can rework this part of code as you want. Or we can do it togehter.

With my best regards, Dmitry.

> Stefan Ringel
> 
> 
> > diff --git a/drivers/staging/tm6000/tm6000-cards.c
> b/drivers/staging/tm6000/tm6000-cards.c
> > index 88144a1..146c7e8 100644
> > --- a/drivers/staging/tm6000/tm6000-cards.c
> > +++ b/drivers/staging/tm6000/tm6000-cards.c
> > @@ -235,11 +235,13 @@ struct tm6000_board tm6000_boards[] = {
> > .avideo = TM6000_AIP_SIF1,
> > .aradio = TM6000_AIP_LINE1,
> > .caps = {
> > - .has_tuner = 1,
> > - .has_dvb = 1,
> > - .has_zl10353 = 1,
> > - .has_eeprom = 1,
> > - .has_remote = 1,
> > + .has_tuner = 1,
> > + .has_dvb = 1,
> > + .has_zl10353 = 1,
> > + .has_eeprom = 1,
> > + .has_remote = 1,
> > + .has_input_comp = 1,
> > + .has_input_svid = 1,
> > },
> > .gpio = {
> > .tuner_reset = TM6010_GPIO_0,
> > @@ -255,11 +257,13 @@ struct tm6000_board tm6000_boards[] = {
> > .avideo = TM6000_AIP_SIF1,
> > .aradio = TM6000_AIP_LINE1,
> > .caps = {
> > - .has_tuner = 1,
> > - .has_dvb = 0,
> > - .has_zl10353 = 0,
> > - .has_eeprom = 1,
> > - .has_remote = 1,
> > + .has_tuner = 1,
> > + .has_dvb = 0,
> > + .has_zl10353 = 0,
> > + .has_eeprom = 1,
> > + .has_remote = 1,
> > + .has_input_comp = 1,
> > + .has_input_svid = 1,
> > },
> > .gpio = {
> > .tuner_reset = TM6010_GPIO_0,
> > @@ -327,10 +331,13 @@ struct tm6000_board tm6000_boards[] = {
> > .avideo = TM6000_AIP_SIF1,
> > .aradio = TM6000_AIP_LINE1,
> > .caps = {
> > - .has_tuner = 1,
> > - .has_dvb = 1,
> > - .has_zl10353 = 1,
> > - .has_eeprom = 1,
> > + .has_tuner = 1,
> > + .has_dvb = 1,
> > + .has_zl10353 = 1,
> > + .has_eeprom = 1,
> > + .has_remote = 0,
> > + .has_input_comp = 0,
> > + .has_input_svid = 0,
> > },
> > .gpio = {
> > .tuner_reset = TM6010_GPIO_0,
> > @@ -346,10 +353,13 @@ struct tm6000_board tm6000_boards[] = {
> > .avideo = TM6000_AIP_SIF1,
> > .aradio = TM6000_AIP_LINE1,
> > .caps = {
> > - .has_tuner = 1,
> > - .has_dvb = 0,
> > - .has_zl10353 = 0,
> > - .has_eeprom = 1,
> > + .has_tuner = 1,
> > + .has_dvb = 0,
> > + .has_zl10353 = 0,
> > + .has_eeprom = 1,
> > + .has_remote = 0,
> > + .has_input_comp = 0,
> > + .has_input_svid = 0,
> > },
> > .gpio = {
> > .tuner_reset = TM6010_GPIO_0,
> > diff --git a/drivers/staging/tm6000/tm6000-stds.c
> b/drivers/staging/tm6000/tm6000-stds.c
> > index a4c07e5..da3e51b 100644
> > --- a/drivers/staging/tm6000/tm6000-stds.c
> > +++ b/drivers/staging/tm6000/tm6000-stds.c
> > @@ -1161,8 +1161,6 @@ int tm6000_set_standard(struct tm6000_core
> > *dev,
> v4l2_std_id * norm)
> > rc = tm6000_load_std(dev, svideo_stds[i].common,
> > sizeof(svideo_stds[i].
> > common));
> > - tm6000_set_audio_std(dev, svideo_stds[i].audio_default_std);
> > -
> > goto ret;
> > }
> > }
> > diff --git a/drivers/staging/tm6000/tm6000-video.c
> b/drivers/staging/tm6000/tm6000-video.c
> > index b550340..c80a316 100644
> > --- a/drivers/staging/tm6000/tm6000-video.c
> > +++ b/drivers/staging/tm6000/tm6000-video.c
> > @@ -1080,18 +1080,27 @@ static int vidioc_s_std (struct file *file,
> void *priv, v4l2_std_id *norm)
> > static int vidioc_enum_input(struct file *file, void *priv,
> > struct v4l2_input *inp)
> > {
> > + struct tm6000_fh *fh = priv;
> > + struct tm6000_core *dev = fh->dev;
> > +
> > switch (inp->index) {
> > case TM6000_INPUT_TV:
> > inp->type = V4L2_INPUT_TYPE_TUNER;
> > strcpy(inp->name, "Television");
> > break;
> > case TM6000_INPUT_COMPOSITE:
> > - inp->type = V4L2_INPUT_TYPE_CAMERA;
> > - strcpy(inp->name, "Composite");
> > + if (dev->caps.has_input_comp) {
> > + inp->type = V4L2_INPUT_TYPE_CAMERA;
> > + strcpy(inp->name, "Composite");
> > + } else
> > + return -EINVAL;
> > break;
> > case TM6000_INPUT_SVIDEO:
> > - inp->type = V4L2_INPUT_TYPE_CAMERA;
> > - strcpy(inp->name, "S-Video");
> > + if (dev->caps.has_input_svid) {
> > + inp->type = V4L2_INPUT_TYPE_CAMERA;
> > + strcpy(inp->name, "S-Video");
> > + } else
> > + return -EINVAL;
> > break;
> > default:
> > return -EINVAL;
> > diff --git a/drivers/staging/tm6000/tm6000.h
> b/drivers/staging/tm6000/tm6000.h
> > index ccd120f..99ae50e 100644
> > --- a/drivers/staging/tm6000/tm6000.h
> > +++ b/drivers/staging/tm6000/tm6000.h
> > @@ -129,6 +129,8 @@ struct tm6000_capabilities {
> > unsigned int has_zl10353:1;
> > unsigned int has_eeprom:1;
> > unsigned int has_remote:1;
> > + unsigned int has_input_comp:1;
> > + unsigned int has_input_svid:1;
> > };
> >
> > struct tm6000_dvb {
> >
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> >
> > With my best regards, Dmitry.
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>  
> iQEcBAEBAgAGBQJNhFFgAAoJEAWtPFjxMvFGATAH/RZnxOBnRF7bvpInTVcvDr3f
> siYCB6O+JKKLwA8dWzh5ejOi+cBcYWPqcgJcZ2s/0dedqEQ8/RVxGflrnYk66/vT
> KP3JkysbH3Nme9mE9AlSXSrCpGg6AG9u99SgyHkCJQKASkQX7dHg/prz4iMySIgi
> Ii05FHR2f5P5FmaH96eKjgzd8J8WSHe2excr07gKg2FL2bX8icnqt0Lz7S1/V0rQ
> ewdL9cOh+IBsIG8dOLBetB3rxlfEtheph7bHtBqJ2s9+yo9KVj8tynpGghgoNrAw
> ntDttbSrnCjcXaALKFfXBvAnv349jwbBLnyZU3PWjK560sdjg9bhLi515xYXwhM=
> =eldX
> -----END PGP SIGNATURE-----
> 
