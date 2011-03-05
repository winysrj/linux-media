Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab1CESWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2011 13:22:40 -0500
Message-ID: <4D727F64.7040805@redhat.com>
Date: Sat, 05 Mar 2011 15:22:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103031125.06419.laurent.pinchart@ideasonboard.com> <4D713CBD.7030405@redhat.com> <201103051402.34416.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103051402.34416.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-03-2011 10:02, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> Thanks for the review. Let me address all your concerns in a single mail.
> 
> - ioctl numbers
> 
> I'll send you a patch that reserves a range in Documentation/ioctl/ioctl-
> number.txt and update include/linux/media.h accordingly.

Ok, thanks.
> 
> - private ioctls
> 
> As already explained by David, the private ioctls are used to control advanced 
> device features that can't be handled by V4L2 controls at the moment (such as 
> setting a gamma correction table). Using those ioctls is not mandatory, and 
> the device will work correctly without them (albeit with a non optimal image 
> quality).
> 
> David said he will submit a patch to document the ioctls.

Ok.

> - media bus formats
> 
> As Hans explained, there's no 1:1 relationship between media bus formats and 
> pixel formats.

Yet, there are some relationship between them. See my comments on my previous email.

> - FOURCC and media bus codes documentation
> 
> I forgot to document some of them. I'll send a new patch that adds the missing 
> documentation.

Ok.
> 
> 
> Is there any other issue I need to address ? 

Nothing else, in the patches I've analysed so far. I'll take a look at the remaining
omap3isp after receiving the documentation for the private ioctl's.

> My understanding is that there's 
> no need to rebase the existing patches, is that correct ?

Yes, it is correct. Just send the new patches to be applied at the end of the series.
I'll eventually reorder them if needed to avoid breaking git bisect.

Thanks!
Mauro.
