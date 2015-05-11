Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49733 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbbEKMqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 08:46:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 01/18] media controller: add EXPERIMENTAL to Kconfig option for DVB support
Date: Mon, 11 May 2015 15:46:30 +0300
Message-ID: <1726768.VJHFY9ifNM@avalon>
In-Reply-To: <554C9F1A.6000502@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com> <35cb86bc03b693fd5ef6133c22c78aacfd63a0e2.1431046915.git.mchehab@osg.samsung.com> <554C9F1A.6000502@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 08 May 2015 13:33:46 Hans Verkuil wrote:
> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> > The Media Controller DVB support is still an experimental feature,
> > as it is under heavy development. It is already said that it is
> > an experimental feature at the help, but let make it even clearer
> > and louder, as we may need to adjust some bits when we start using it
> > on embedded drivers.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

And

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 3ef0f90b128f..8af89b084267 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -95,7 +95,7 @@ config MEDIA_CONTROLLER
> > 
> >  	  This API is mostly used by camera interfaces in embedded platforms.
> >  
> >  config MEDIA_CONTROLLER_DVB
> > 
> > -	bool "Enable Media controller for DVB"
> > +	bool "Enable Media controller for DVB (EXPERIMENTAL)"
> > 
> >  	depends on MEDIA_CONTROLLER
> >  	---help---
> >  	
> >  	  Enable the media controller API support for DVB.

-- 
Regards,

Laurent Pinchart

