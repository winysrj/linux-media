Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45FRwE7014164
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:27:58 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m45FRkPC000371
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:27:46 -0400
Date: Mon, 5 May 2008 17:27:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481F0BFA.7010306@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805051710530.5648@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
	<481AF6CA.9030505@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>
	<481AFB30.5070508@hni.uni-paderborn.de>
	<481B3D2F.80203@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805022059090.31894@axis700.grange>
	<481F0BFA.7010306@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Some suggestions for the soc_camera interface
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 5 May 2008, Stefan Herbrechtsmeier wrote:

> > +        dev_dbg(icd->dev, "%s: Releasing camera reset\n",
> > +            __func__);
> > +        icl->reset(icd->dev, 1);
> > +    }
> >   
> It is right to use the icd->dev for the init/reset function or should this be
> icd->client->dev?

Actually, now that I look at it again, it is neither the former nor the 
latter one. We are calling a reset method, provided by the platform here. 
Platform knows nothing about i2c or video devices associated with the 
specific camera. It only knows about its physical connection - which 
camera host it is connected to, how to locate it on that host, and how to 
reset / power on or off. So, the parameter we pass to the reset, init, and 
power functions should be a void pointer from the respective 
soc_camera_link. I.e., soc_camera_link should get a new member like

	void	*arg;	/* platform data used as argument to init, reset, power */

and then you call icl->power(icl->arg).

> > @@ -136,0 +148,0 @@ static int mt9m001_init(struct soc_camer
> > 
> > static int mt9m001_release(struct soc_camera_device *icd)
> > {
> > +    struct soc_camera_link *icl = icd->client->dev.platform_data;
> > +
> >     /* Disable the chip */
> >     reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
> > +
> > +    if (icl && icl->reset) {
> > +        dev_dbg(icd->dev, "%s: Asserting camera reset\n",
> > +            __func__);
> > +        icl->reset(icd->dev, 0);
> > 
> > I know the original code does this too, but I don't understand why you have
> > to reset a camera when releasing it...
> >   
> I thing this is done to saving the time for a reset impulse.  The
> mt9m001_init() only release this pin.
> But this depends on the implementation of reset(). It has a value parameter so
> I think it changes the
> state of the pin depending on the value. Or should it reset the chip
> irrespective of the value?
> Maybe we should remove the value from the reset function to make things clear.

Exactly, this is implementation specidic, and in my implementation I 
didn't have any reset / power, so, I could well just throw them away. 
Let's see what you need there and adapt them to your needs.

> Some other question: Should I skip the soft reset if a hard reset is present?

Same - let's just see what your and my platforms and cameras need and let 
anyone else with different hardware either fix their hardware or provide 
patches:-)

> > ****************************************************************************
> > Patch 2
> > ****************************************************************************
> > 
> > + Rename SOCAM_HSYNC_* to SOCAM_HREF_* and introduce new
> >    SOCAM_HSYNC_*
> > 
> > This is what you've written in your earlier email:
> > 
> >   
> > > > 1. Renaming SOCAM_HSYNC_* to SOCAM_HREF_*
> > > > I think the current used Signal is HREF and not HSYNC.
> > > > - HREF is active during valid pixels
> > > > - HSYNC is a impulse at the start of each line before valid pixels and
> > > > need
> > > > some pixel skipping.
> > > >       
> > 
> > and the signal used on PXA270 _is_ HSYNC - also according to your
> > definition, it's only that wait counts have been set to 0, so, the signal
> > has become equivalent to HREF. And now that you support wait count != 0, it
> > _is_ becoming HSYNC and not HREF. Further, the macros are used to set signal
> > polarity, regardless of whether waits are used or not. So, if we ever get a
> > SoC, where HSYNC and HREF polarity can be controlled separately and we will
> > want to support that - _then_ we'll need these new macros. For now, I think,
> > you just need to support non-zero wait counts and don't need to change names
> > / introduce new ones. So, I'm dropping this one for now.
> >   
> At the OV9655 the HREF pin can configure as HREF or as HSYNC. Thats the reason
> why I change
> this. I will resubmit it together with my OV9655 driver.

I understood that, but I still don't think there's anything you have to 
change in the pxa-camera driver for that. But let's see when you submit 
your patches.

> > diff -r dd4685496fb7 linux/drivers/media/video/mt9m001.c
> > --- a/linux/drivers/media/video/mt9m001.c    Fri May 02 01:48:36 2008 -0300
> > +++ b/linux/drivers/media/video/mt9m001.c    Fri May 02 16:34:37 2008 +0200
> > @@ -659,6 +685,7 @@ static int mt9m001_probe(struct i2c_clie
> >     icd->width_max    = 1280;
> >     icd->height_min    = 32;
> >     icd->height_max    = 1024;
> > +    icd->x_skip_left = 0;
> >     icd->y_skip_top    = 1;
> >     icd->iface    = icl->bus_id;
> >   
> My new variable is longer than the others and break the tab formation. What is
> the best to do?

Use your esthetic feeling:-) But if it doesn't coincide with mine, I'll 
reject the patch:-))

> > So, I would say, patches 1 and 3 look useful to me. Please fix formatting
> > issues, add your Signed-off-by and submit in two separate emails.
> >   
> At the moment I update my system to the 2.6.25 kernel. When everything works
> fine, I submit the reworked
> patches the next days.

Great!

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
