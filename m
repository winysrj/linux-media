Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59470 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1LAQOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 11:14:12 -0500
Date: Thu, 1 Dec 2011 18:14:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 00/11] v4l2: OMAP4 ISS driver + Sensor + Board
 support
Message-ID: <20111201161407.GK29805@valkosipuli.localdomain>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the patchset!!

On Wed, Nov 30, 2011 at 06:14:49PM -0600, Sergio Aguirre wrote:
> Hi everyone,
> 
> This is the second version of the OMAP4 ISS driver,
> now ported to the Media Controller framework AND supporting
> videobuf2 framework.
> 
> This patchset should apply cleanly on top of v3.2-rc3 kernel tag.
> 
> This driver attempts to provide an fully open source solution to
> control the OMAP4 Imaging SubSystem (a.k.a. ISS).
> 
> Starts with just CSI2-A interface support, and pretends to be
> ready for expansion to add support to the many ISS block modules
> as possible.
> 
> Please see newly added documentation for more details:
> 
> Documentation/video4linux/omap4_camera.txt

I propose s/omap4_camera/omap4iss/, according to the path name in the
drivers/media/video directory.

> Any comments/complaints are welcome. :)
> 
> Changes since v1:
> - Simplification of auxclk handling in board files. (Pointed out by: Roger Quadros)
> - Cleanup of Camera support enablement for 4430sdp & panda. (Pointed out by: Roger Quadros)
> - Use of HWMOD declaration for assisted platform_device creation. (Pointed out by: Felipe Balbi)
> - Videobuf2 migration (Removal of custom iss_queue buffer handling driver)

I'm happy to see it's using videobuf2!

I have no other comments quite yet. :-)

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
