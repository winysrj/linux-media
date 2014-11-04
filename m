Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:33301 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753071AbaKDKpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 05:45:07 -0500
Date: Tue, 4 Nov 2014 11:45:03 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Message-ID: <20141104114503.309cb54f@bbrezillon>
In-Reply-To: <5458A878.3010809@cisco.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>
	<5458A878.3010809@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 04 Nov 2014 11:20:40 +0100
Hans Verkuil <hansverk@cisco.com> wrote:

> Hi Boris,
> 
> On 11/04/14 10:54, Boris Brezillon wrote:
> > Rename mediabus formats and move the enum into a separate header file so
> > that it can be used by DRM/KMS subsystem without any reference to the V4L2
> > subsystem.
> > 
> > Old V4L2_MBUS_FMT_ definitions are now referencing MEDIA_BUS_FMT_ value.
> 
> I missed earlier that v4l2-mediabus.h contained a struct as well, so it can't be
> deprecated and neither can a #warning be added.
> 
> The best approach, I think, is to use a macro in media-bus-format.h
> that will either define just the MEDIA_BUS value when compiled in the kernel, or
> define both MEDIA_BUS and V4L2_MBUS values when compiled for userspace.
> 
> E.g. something like this:
> 
> #ifdef __KERNEL__
> #define MEDIA_BUS_FMT_ENTRY(name, val) MEDIA_BUS_FMT_ # name = val
> #else
> /* Keep V4L2_MBUS_FMT for backwards compatibility */
> #define MEDIA_BUS_FMT_ENTRY(name, val) \
> 	MEDIA_BUS_FMT_ # name = val, \
> 	V4L2_MBUS_FMT_ # name = val
> #endif

Okay, but this means we keep adding V4L2_MBUS_FMT_ definitions even for
new formats (which definitely doesn't encourage people to move on).
Moreover, we add a V4L2 prefix in what was supposed to be a subsystem
neutral header.

Anyway, these are just nitpicks, and if you prefer this approach
I'll rework my series :-).

> 
> An alternative approach is to have v4l2-mediabus.h include media-bus-format.h,
> put #ifndef __KERNEL__ around the enum v4l2_mbus_pixelcode and add a big comment
> there that applications should use the defines from media-bus-format.h and that
> this enum is frozen (i.e. new values are only added to media-bus-format.h).
> 
> But I think I like the macro idea best.

As you wish, my only intent is to use those bus format definitions in a
DRM driver :-).

Thanks,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
