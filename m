Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:33523 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab2BSI41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 03:56:27 -0500
From: Keith Packard <keithp@keithp.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
In-Reply-To: <1775349.d0yvHiVdjB@avalon>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1654816.MX2JJ87BEo@avalon> <1775349.d0yvHiVdjB@avalon>
Date: Sat, 18 Feb 2012 13:56:49 +1300
Message-ID: <867gzlarhq.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<#part sign=pgpmime>
On Fri, 17 Feb 2012 00:25:51 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> ***  Synchronous pipeline changes ***
> 
>   Goal: Create an API to apply complex changes to a video pipeline atomically.
> 
>   Needed for complex camera use cases. On the DRM/KMS side, the approach is to
>   use one big ioctl to configure the whole pipeline.

This is the only credible approach for most desktop chips -- you must
have the whole configuration available before you can make any
commitment to supporting the requested modes.

>   One solution is a commit ioctl, through the media controller device, that
>   would be dispatched to entities internally with a prepare step and a commit
>   step.

The current plan for the i915 KMS code is to use a single ioctl -- the
application sends a buffer full of configuration commands down to the
kernel which can then figure out whether it can be supported or not.

The kernel will have to store the intermediate data until the commit
arrives anyways, and you still need a central authority in the kernel
controlling the final commit decision.

-- 
keith.packard@intel.com
