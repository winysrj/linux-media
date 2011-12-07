Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33897 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab1LGVuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 16:50:11 -0500
Date: Wed, 7 Dec 2011 13:50:08 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Subject: Re: [PATCH v2 00/11] v4l2: OMAP4 ISS driver + Sensor + Board
 support
Message-ID: <20111207215008.GN31337@atomide.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sergio Aguirre <saaguirre@ti.com> [111130 15:40]:
> Hi everyone,
> 
> This is the second version of the OMAP4 ISS driver,
> now ported to the Media Controller framework AND supporting
> videobuf2 framework.

I suggest you do a device tree only binding for new drivers.

>  arch/arm/mach-omap2/board-4430sdp-camera.c    |  221 ++++
>  arch/arm/mach-omap2/board-omap4panda-camera.c |  198 ++++
>  arch/arm/mach-omap2/devices.c                 |   40 +

That leaves out most of the code above.

Regards,

Tony
