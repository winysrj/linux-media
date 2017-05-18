Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932157AbdERUsx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 16:48:53 -0400
Date: Thu, 18 May 2017 22:48:43 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Manny Vindiola <mannyv@gmail.com>, mchehab@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: fix missing blank line coding style
 issue in atomisp_tpg.c
Message-ID: <20170518204843.GA16508@kroah.com>
References: <1495072118-912-1-git-send-email-mannyv@gmail.com>
 <1495125080.7848.63.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1495125080.7848.63.camel@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 18, 2017 at 05:31:20PM +0100, Alan Cox wrote:
> On Wed, 2017-05-17 at 21:48 -0400, Manny Vindiola wrote:
> > This is a patch to the atomisp_tpg.c file that fixes up a missing
> > blank line warning found by the checkpatch.pl tool
> > 
> > Signed-off-by: Manny Vindiola <mannyv@gmail.com>
> > ---
> >  drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> > b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> > index 996d1bd..48b9604 100644
> > --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> > +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
> > @@ -56,6 +56,7 @@ static int tpg_set_fmt(struct v4l2_subdev *sd,
> >  		       struct v4l2_subdev_format *format)
> >  {
> >  	struct v4l2_mbus_framefmt *fmt = &format->format;
> > +
> >  	if (format->pad)
> >  		return -EINVAL;
> >  	/* only raw8 grbg is supported by TPG */
> 
> The TODO fille for this driver specifically says not to send formatting
> patches at this point.
> 
> There is no point making trivial spacing changes in code that needs
> lots of real work. It's like polishing your car when the doors have
> fallen off.

Unfortunatly, given that the code is in staging, that's not going to
happen, people are going to send cleanup patches, and that's ok.  They
should be easy to merge around, it's the price for being in the tree.

thanks,

greg k-h
