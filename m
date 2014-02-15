Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45386 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100AbaBOKTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 05:19:31 -0500
Message-ID: <52FF3FA6.1080903@iki.fi>
Date: Sat, 15 Feb 2014 12:21:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH 0/2] OMAP3 ISP pipeline validation patches
References: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hello,
> 
> Those two patches fix the OMAP3 ISP pipeline validation when locating the
> external subdevice.
> 
> The code currently works by chance with memory-to-memory pipelines, as it
> tries to locate the external subdevice when none is available, but ignores the
> failure due to a bug. This patch set fixes both issues.
> 
> Peter, could you check whether this fixes the warning you've reported ?
> 
> Laurent Pinchart (2):
>   omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
>   omap3isp: Don't ignore failure to locate external subdev

To both:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
