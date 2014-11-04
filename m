Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:33226 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaKDKXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 05:23:04 -0500
Message-ID: <5458A8F7.2050803@cisco.com>
Date: Tue, 04 Nov 2014 11:22:47 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com> <1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com> <5458A878.3010809@cisco.com>
In-Reply-To: <5458A878.3010809@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/04/14 11:20, Hans Verkuil wrote:
> Hi Boris,
> 
> On 11/04/14 10:54, Boris Brezillon wrote:
>> Rename mediabus formats and move the enum into a separate header file so
>> that it can be used by DRM/KMS subsystem without any reference to the V4L2
>> subsystem.
>>
>> Old V4L2_MBUS_FMT_ definitions are now referencing MEDIA_BUS_FMT_ value.
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

And v4l2-mediabus.h needs this as well:

#ifndef __KERNEL__
/* For backwards compatibility */
#define v4l2_mbus_pixelcode media_bus_format
#endif

Regards,

	Hans
