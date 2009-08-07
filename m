Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51870 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbZHGLBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 07:01:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH,RFC] Drop non-unlocked ioctl support in v4l2-dev.c
Date: Fri, 7 Aug 2009 13:03:22 +0200
Cc: linux-media@vger.kernel.org
References: <200908061709.41211.laurent.pinchart@ideasonboard.com> <eee1636b2ae21fc4189b27b511e7d22f.squirrel@webmail.xs4all.nl>
In-Reply-To: <eee1636b2ae21fc4189b27b511e7d22f.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071303.23217.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 06 August 2009 17:16:08 Hans Verkuil wrote:
> Hi Laurent,
>
> > Hi everybody,
> >
> > this patch moves the BKL one level down by removing the non-unlocked
> > ioctl in v4l2-dev.c and calling lock_kernel/unlock_kernel in the
> > unlocked_ioctl handler if the driver only supports locked ioctl.
> >
> > Opinions/comments/applause/kicks ?
>
> I've been thinking about this as well, and my idea was to properly
> implement this by letting the v4l core serialize ioctls if the driver
> doesn't do its own serialization (either through mutexes or lock_kernel).

A v4l-specific (or even device-specific) mutex would of course be better than 
the BKL.

Are there file operations other than ioctl that are protected by the BKL ? 
Blindly replacing the BKL by a mutex on ioctl would then introduce race 
conditions.

> The driver can just set a flag in video_device if it wants to do
> serialization manually, otherwise the core will serialize using a mutex
> and we should be able to completely remove the BKL from all v4l drivers.

Whether the driver fills v4l2_operations::ioctl or 
v4l2_operations::unlocked_ioctl can be considered as such a flag :-)

Many drivers are currently using the BKL in an unlocked_ioctl handler. I'm not 
sure it would be a good idea to move the BKL back to the v4l2 core, as the 
long term goal is to remove it completely and use fine-grain driver-level 
locking.

Regards,

Laurent Pinchart

