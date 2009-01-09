Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:39308 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZAINUx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 08:20:53 -0500
Date: Fri, 9 Jan 2009 07:20:50 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Trent Piepho <xyzzy@speakeasy.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: USB: change interface to usb_lock_device_for_reset()
In-Reply-To: <20090109092845.79e9db8c@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0901090720050.3993@cnc.isely.net>
References: <20090108235304.46ac523b@pedra.chehab.org>
 <Pine.LNX.4.64.0901082224350.3993@cnc.isely.net> <Pine.LNX.4.64.0901082227020.3993@cnc.isely.net>
 <20090109023842.4a6c638c@pedra.chehab.org> <Pine.LNX.4.64.0901082240390.3993@cnc.isely.net>
 <20090109024758.6c4902f6@pedra.chehab.org> <Pine.LNX.4.64.0901082334100.3993@cnc.isely.net>
 <Pine.LNX.4.58.0901082146470.1626@shell2.speakeasy.net>
 <20090109092845.79e9db8c@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Jan 2009, Mauro Carvalho Chehab wrote:

> On Thu, 8 Jan 2009 21:56:15 -0800 (PST)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> 
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

Just for the record...

Acked-By: Mike Isely <isely@pobox.com>

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
