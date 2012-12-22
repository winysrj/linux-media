Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LVQyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 11:54:17 -0500
Date: Sat, 22 Dec 2012 14:53:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: input: fix oops on device removal
Message-ID: <20121222145352.3bac5b64@redhat.com>
In-Reply-To: <50D5BDAE.4030502@googlemail.com>
References: <1355416457-19692-1-git-send-email-fschaefer.oss@googlemail.com>
	<50D48126.8050307@googlemail.com>
	<20121221213541.2dda362d@redhat.com>
	<50D5BDAE.4030502@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Dec 2012 15:03:26 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 22.12.2012 00:35, schrieb Mauro Carvalho Chehab:
> > Em Fri, 21 Dec 2012 16:32:54 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 13.12.2012 17:34, schrieb Frank Schäfer:
> >>> When em28xx_ir_init() fails du to an error in em28xx_ir_change_protocol(), it
> >>> frees the memory of struct em28xx_IR *ir, but doesn't set the corresponding
> >>> pointer in the device struct to NULL.
> >>> On device removal, em28xx_ir_fini() gets called, which then calls
> >>> rc_unregister_device() with a pointer to freed memory.
> >>>
> >>> Fixes bug 26572 (http://bugzilla.kernel.org/show_bug.cgi?id=26572)
> >>>
> >>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >>>
> >>> Cc: stable@kernel.org	# at least all kernels since 2.6.32 (incl.)
> >>> ---
> >>>  drivers/media/usb/em28xx/em28xx-input.c |    9 ++++-----
> >>>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)
> >>>
> >>> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> >>> index 660bf80..5c7d768 100644
> >>> --- a/drivers/media/usb/em28xx/em28xx-input.c
> >>> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> >>> @@ -538,7 +538,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >>>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> >>>  	rc = rc_allocate_device();
> >>>  	if (!ir || !rc)
> >>> -		goto err_out_free;
> >>> +		goto error;
> >>>  
> >>>  	/* record handles to ourself */
> >>>  	ir->dev = dev;
> >>> @@ -559,7 +559,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >>>  	rc_type = RC_BIT_UNKNOWN;
> >>>  	err = em28xx_ir_change_protocol(rc, &rc_type);
> >>>  	if (err)
> >>> -		goto err_out_free;
> >>> +		goto error;
> >>>  
> >>>  	/* This is how often we ask the chip for IR information */
> >>>  	ir->polling = 100; /* ms */
> >>> @@ -584,7 +584,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >>>  	/* all done */
> >>>  	err = rc_register_device(rc);
> >>>  	if (err)
> >>> -		goto err_out_stop;
> >>> +		goto error;
> >>>  
> >>>  	em28xx_register_i2c_ir(dev);
> >>>  
> >>> @@ -597,9 +597,8 @@ static int em28xx_ir_init(struct em28xx *dev)
> >>>  
> >>>  	return 0;
> >>>  
> >>> - err_out_stop:
> >>> +error:
> >>>  	dev->ir = NULL;
> >>> - err_out_free:
> >>>  	rc_free_device(rc);
> >>>  	kfree(ir);
> >>>  	return err;
> >> Ping !?
> >> Mauro, this patch is really easy to review and it fixes a 2 years old bug...
> >> Isn't this one of those patches that should be applied immediately ?
> > This one is not on my queue... Patchwork doesn't seem to catch it:
> >
> > http://patchwork.linuxtv.org/project/linux-media/list/?submitter=44&state=*
> 
> Hmm... I didn't notice that.

In any case, FYI, I typically don't even read any emails on my inbox with
the word "PATCH" on it. I just handle whatever it is in patchwork. So, c/c me
patches won't work, and just annoys me ;)

Instead, you need to check a few mins after posting a patch to see if patchwork
got it.

Unfortunately, patchwork doesn't (yet) notify the sender when a new patch
arrives there.

> > Hmm... perhaps it is due to the accent on your name. Weird that it got
> > other patches from you. You should likely thank python for discriminating
> > e-mails with accents.
> 
> My first guess would be the cc line. Maybe the comment confused patchwork...

It shouldn't. C/c should be accepted properly.

My guess is that it is related to accents. Patchwork has a very bad history
with accented e-mails: python has a very bad habit of aborting any script 
if an unknown character is detected. There are lots of patches inside
patchwork's git tree to fix it, but there are still some cases where python
insists to die with accented chars.

> > Could you please try to re-submit it being sure that your email got
> > properly encoded with UTF-8?
> 
> Sure, but 've definitely sent it UTF-8 encoded last time (using git
> send-email).

Your second patch arrived there fine. Thanks!

Mauro
