Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63334 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1KQR5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 12:57:43 -0500
Received: by yenq3 with SMTP id q3so1392731yen.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 09:57:43 -0800 (PST)
Date: Thu, 17 Nov 2011 15:03:03 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: Cleanup proposal for media/gspca
Message-ID: <20111117180303.GA2074@devel2>
References: <20111116013445.GA5273@localhost>
 <CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
 <20111117110716.6343d46c@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117110716.6343d46c@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2011 at 11:07:16AM +0100, Jean-Francois Moine wrote:
> On Wed, 16 Nov 2011 15:19:04 -0300
> Ezequiel Garc??a <elezegarcia@gmail.com> wrote:
> 
> > In 'media/video/gspca/gspca.c' I really hated this cast (maybe because
> > I am too dumb to understand it):
> > 
> >   gspca_dev = (struct gspca_dev *) video_devdata(file);
> > 
> > wich is only legal because a struct video_device is the first member
> > of gspca_dev. IMHO, this is 'unnecesary obfuscation'.
> > The thing is the driver is surely working fine and there is no good
> > reasong for the change.
> > 
> > Is it ok to submit a patchset to change this? Something like this:
> > 
> > diff --git a/drivers/media/video/gspca/gspca.c
> > b/drivers/media/video/gspca/gspca.c
> > index 881e04c..5d962ce 100644
> > --- a/drivers/media/video/gspca/gspca.c
> > +++ b/drivers/media/video/gspca/gspca.c
> > @@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
> >  static int dev_open(struct file *file)
> >  {
> >  	struct gspca_dev *gspca_dev;
> > +	struct video_device *vdev;
> > 
> >  	PDEBUG(D_STREAM, "[%s] open", current->comm);
> > -	gspca_dev = (struct gspca_dev *) video_devdata(file);
> > +	vdev = video_devdata(file);
> > +	gspca_dev = video_get_drvdata(vdev);
> >  	if (!gspca_dev->present)
> 
> Hi Ezequiel,
> 
> You are right, the cast is not a good way (and there are a lot of them
> in the gspca subdrivers), but your patch does not work because the
> 'private_data' of the device is not initialized (there is no call to
> video_set_drvdata).
> 
> So, a possible cleanup could be:
> 
> > -	gspca_dev = (struct gspca_dev *) video_devdata(file);
> > +	gspca_dev = container_of(video_devdata(file), struct gspca_dev, vdev);
> 
> Is it OK for you?

Hi, and thanks a lot for your comments. Actually the _sample_ patch I sent 
was just to exemplify the real patch I had in mind, and not wasn't meant to
work.

Maybe later I can send the whole patch properly formatted. 
I know there are more of that in gspca, but right now I made 
changes just in gspca.c, tested with my pac7302 camera, 
so far so good: it is working. 

Anyway, I am _very_ noob and just starting with this kernel 
programming thing so any comments of any kind are
welcome.

Thanks,
Ezequiel.
