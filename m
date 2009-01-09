Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:49695 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZAITG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 14:06:58 -0500
Date: Fri, 9 Jan 2009 11:06:55 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Mike Isely <isely@pobox.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: USB: change interface to usb_lock_device_for_reset()
In-Reply-To: <20090109092845.79e9db8c@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0901091105360.1626@shell2.speakeasy.net>
References: <20090108235304.46ac523b@pedra.chehab.org>
 <Pine.LNX.4.64.0901082224350.3993@cnc.isely.net> <Pine.LNX.4.64.0901082227020.3993@cnc.isely.net>
 <20090109023842.4a6c638c@pedra.chehab.org> <Pine.LNX.4.64.0901082240390.3993@cnc.isely.net>
 <20090109024758.6c4902f6@pedra.chehab.org> <Pine.LNX.4.64.0901082334100.3993@cnc.isely.net>
 <Pine.LNX.4.58.0901082146470.1626@shell2.speakeasy.net>
 <20090109092845.79e9db8c@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Jan 2009, Mauro Carvalho Chehab wrote:
> On Thu, 8 Jan 2009 21:56:15 -0800 (PST)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > On Thu, 8 Jan 2009, Mike Isely wrote:
> > > > Yes... Anyway, this is the real patch. I've added a small comment about this
> > > > change... I'll commit this tomorrow, if you don't have a better suggestion.
> > >
> > > Looks good.
> >
> > Or maybe like this?
> >
> > diff -r f01b3897d141 linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> > --- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Jan 09 00:27:32 2009 -0200
> > +++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Jan 09 02:45:48 2009 -0200
> > @@ -3747,7 +3747,12 @@
> >  	int ret;
> >  	pvr2_trace(PVR2_TRACE_INIT,"Performing a device reset...");
> >  	ret = usb_lock_device_for_reset(hdw->usb_dev,NULL);
> > - 	if (ret == 1) {
> > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 29)
> > +	/* Due to the API changes, the ret value for success changed */
> > +	ret = ret != 1;
> > +#endif
> > +	if (ret == 0) {
> >  		ret = usb_reset_device(hdw->usb_dev);
> >  		usb_unlock_device(hdw->usb_dev);
> >  	} else {
> >
>
> Seems better! Could you please provide your SOB? I'll apply just the backport, then your patch.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
