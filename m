Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41678 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3LCROM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 12:14:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 01/18] v4l: omap4iss: Add support for OMAP4 camera interface - Core
Date: Tue, 03 Dec 2013 18:14:15 +0100
Message-ID: <1506831.WPYrDVrDpX@avalon>
In-Reply-To: <20131203150243.33a00f58.m.chehab@samsung.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com> <1383523603-3907-2-git-send-email-laurent.pinchart@ideasonboard.com> <20131203150243.33a00f58.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 03 December 2013 15:02:43 Mauro Carvalho Chehab wrote:
> Em Mon,  4 Nov 2013 01:06:26 +0100
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> > 
> > This adds a very simplistic driver to utilize the CSI2A interface inside
> > the ISS subsystem in OMAP4, and dump the data to memory.
> > 
> > Check Documentation/video4linux/omap4_camera.txt for details.
> > 
> > This commit adds the driver core, registers definitions and
> > documentation.
> > 
> > Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> > 
> > [Port the driver to v3.12-rc3, including the following changes
> > - Don't include plat/ headers
> > - Don't use cpu_is_omap44xx() macro
> > - Don't depend on EXPERIMENTAL
> > - Fix s_crop operation prototype
> > - Update link_notify prototype
> > - Rename media_entity_remote_source to media_entity_remote_pad]
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  Documentation/video4linux/omap4_camera.txt |   60 ++
> >  drivers/staging/media/omap4iss/iss.c       | 1477 +++++++++++++++++++++++
> >  drivers/staging/media/omap4iss/iss.h       |  153 +++
> >  drivers/staging/media/omap4iss/iss_regs.h  |  883 +++++++++++++++++
> >  include/media/omap4iss.h                   |   65 ++
> >  5 files changed, 2638 insertions(+)
> >  create mode 100644 Documentation/video4linux/omap4_camera.txt
> >  create mode 100644 drivers/staging/media/omap4iss/iss.c
> >  create mode 100644 drivers/staging/media/omap4iss/iss.h
> >  create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
> >  create mode 100644 include/media/omap4iss.h
> 
> ...
> 
> > +	/*
> > +	 * atomic_set() doesn't include memory barrier on ARM platform for 
SMP
> > +	 * scenario. We'll call it here to avoid race conditions.
> > +	 */
> > +	atomic_set(stopping, 1);
> > +	smp_wmb();
> 
> Hmm... if atomic_set() is broken on ARM, you should be fixing its
> implementation, and not adding any hacks like the above on all places
> where atomic ops are needed.

I'll investigate that. Can I address that in a follow-up patch ?

-- 
Regards,

Laurent Pinchart

