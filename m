Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54941 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1F2P6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 11:58:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: auto-loading omap3-isp
Date: Wed, 29 Jun 2011 17:59:04 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <4E0B3718.1030202@matrix-vision.de>
In-Reply-To: <4E0B3718.1030202@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291759.04498.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Wednesday 29 June 2011 16:30:48 Michael Jones wrote:
> I am trying to get omap3-isp.ko to be loaded upon bootup.  The problem
> is that iommu2.ko needs to be loaded first, which can't just be compiled
> into the kernel.  Udev will see '/sys/devices/platform/omap3isp' and
> load omap3-isp.ko, which fails because iommu2.ko hasn't been loaded yet.
>  iommu2 doesn't have a counterpart in /sys/devices/, so I don't know how
> to get udev to load it first.
> 
> I can think of a few ways to accomplish this, but they all amount to
> hacking the init sequence (e.g. the udev init script).  I'm looking for
> a better way.
> 
> How are others doing this?

I replace the tristate option by a bool option for the IOMMU config.

OMAP3 IOMMU support will move to the generic IOMMU API soon, so I'm not sure 
if it's worth fixing the problem it now.

-- 
Regards,

Laurent Pinchart
