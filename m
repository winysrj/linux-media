Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZAIL3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 06:29:19 -0500
Date: Fri, 9 Jan 2009 09:28:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mike Isely <isely@pobox.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: USB: change interface to usb_lock_device_for_reset()
Message-ID: <20090109092845.79e9db8c@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901082146470.1626@shell2.speakeasy.net>
References: <20090108235304.46ac523b@pedra.chehab.org>
	<Pine.LNX.4.64.0901082224350.3993@cnc.isely.net>
	<Pine.LNX.4.64.0901082227020.3993@cnc.isely.net>
	<20090109023842.4a6c638c@pedra.chehab.org>
	<Pine.LNX.4.64.0901082240390.3993@cnc.isely.net>
	<20090109024758.6c4902f6@pedra.chehab.org>
	<Pine.LNX.4.64.0901082334100.3993@cnc.isely.net>
	<Pine.LNX.4.58.0901082146470.1626@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Jan 2009 21:56:15 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, 8 Jan 2009, Mike Isely wrote:
> > > Yes... Anyway, this is the real patch. I've added a small comment about this
> > > change... I'll commit this tomorrow, if you don't have a better suggestion.
> >
> > Looks good.
> 
> Or maybe like this?
> 
> diff -r f01b3897d141 linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> --- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Jan 09 00:27:32 2009 -0200
> +++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Fri Jan 09 02:45:48 2009 -0200
> @@ -3747,7 +3747,12 @@
>  	int ret;
>  	pvr2_trace(PVR2_TRACE_INIT,"Performing a device reset...");
>  	ret = usb_lock_device_for_reset(hdw->usb_dev,NULL);
> - 	if (ret == 1) {
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 29)
> +	/* Due to the API changes, the ret value for success changed */
> +	ret = ret != 1;
> +#endif
> +	if (ret == 0) {
>  		ret = usb_reset_device(hdw->usb_dev);
>  		usb_unlock_device(hdw->usb_dev);
>  	} else {
> 

Seems better! Could you please provide your SOB? I'll apply just the backport, then your patch.

Cheers,
Mauro
