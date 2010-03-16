Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56357 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0CPW2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 18:28:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
Date: Tue, 16 Mar 2010 23:30:16 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003162330.17454.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 05 March 2010 15:54:58 Aguirre, Sergio wrote:
> Hi Laurent, Sakari,

Oops, just noticed I forgot to answer your e-mail, sorry.

> I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
> 'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
> Sony IMX046 8MP sensor).
> 
> I had first one NULL pointer dereference while the driver was
> registering devices and creating entities, which I resolved with
> the attached patch. (Is this patch acceptable, or maybe I am missing
> something...)

Either that, or make OMAP34XXCAM_VIDEODEVS dynamic (the value would be passed 
through platform data). The code will be removed (hopefully soon) anyway when 
the legacy video nodes will disappear.

> And now, I don't get quite clear on how the created nodes work out.
> 
> Now I have /dev/video[0-5], but I don't know how I'm I supposed to handle
> them...
> 
> Here's my current work-in-progress kernel:
> 
> 	http://dev.omapzoom.org/?p=saaguirre/linux-omap-camera.git;a=shortlog;h=re
> fs/heads/omap-devel-wip
> 
> Can you please give some guidance on it?

Basically, the driver creates OMAP34XXCAM_VIDEODEVS "legacy" video nodes, one 
for each sensor connected to the ISP. As your board has a single sensor, the 
driver will create the /dev/video0 legacy video node.

Legacy video nodes use hard-coded assumptions that were implemented according 
to Nokia's use cases on the N900. They can only offer a subset of the 
functions available in the hardware.

For full access to the ISP, you will need to use the new video nodes (1 to 5). 
Those video nodes are to be used in conjunction with the media controller. All 
the necessary patches aren't available yet, but they should be soon (it's 
hopefully a matter of days to get the userspace API there).

I will try to make a userspace test application available when the patches 
will be pushed to the linux-omap-camera tree.

-- 
Regards,

Laurent Pinchart
