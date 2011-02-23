Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:61000 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1BWQmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:42:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: link error w/ media-0006-sensors
Date: Wed, 23 Feb 2011 17:42:15 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D35BC6D.1050801@matrix-vision.de> <201101190030.30161.laurent.pinchart@ideasonboard.com> <4D627B00.4090309@matrix-vision.de>
In-Reply-To: <4D627B00.4090309@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231742.15294.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 21 February 2011 15:47:28 Michael Jones wrote:
> Hi Laurent,
> 
> sorry to resurrect this from a month ago...
> 
> I've continued to export omap_pm_set_min_bus_tput() to enable building
> the omap3-isp module, although Paul Wamsley's reply you referred to
> clearly indicates that this is the wrong approach.
> 
> Aren't you also building omap3-isp as a module?  How are you guys
> getting around this?

On MeeGo omap_pm_set_min_bus_tput() is exported. A quick fix would be to add a 
callback to board code, or even remove the call completely, as 
omap_pm_set_min_bus_tput() in a no-op in mainline. A good fix would be to 
export the functionality of omap_pm_set_min_bus_tput() in a generic API that 
could be used by drivers.

-- 
Regards,

Laurent Pinchart
