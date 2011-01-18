Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36718 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1ARXad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 18:30:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: link error w/ media-0006-sensors
Date: Wed, 19 Jan 2011 00:30:27 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D35BC6D.1050801@matrix-vision.de>
In-Reply-To: <4D35BC6D.1050801@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101190030.30161.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Tuesday 18 January 2011 17:14:37 Michael Jones wrote:
> Hi Laurent & Sakari,
> 
> On Laurent's media-0006-sensors branch, when compiling with
> CONFIG_VIDEO_OMAP3=m, I got the following linking error:
> 
> ERROR: "omap_pm_set_min_bus_tput" [drivers/media/video/isp/omap3-isp.ko]
> undefined!
> 
> I can get rid of the error with the patch below. But as always, I
> wonder: Why didn't anybody else come across this error? Are you all
> compiling with VIDEO_OMAP3=y? Is there a config file somewhere I can see
> where someone is using that?
> 
> And would anything be wrong with the patch below?

Martin Hostettler sent the same patch to linux-omap today ("[PATCH] OMAP: PM: 
Export omap_pm_set_min_bus_tput to modules"). See Please see Paul Wamsley's 
answer on the list.

-- 
Regards,

Laurent Pinchart
