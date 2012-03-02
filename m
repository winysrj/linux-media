Return-path: <linux-media-owner@vger.kernel.org>
Received: from h1778886.stratoserver.net ([85.214.133.74]:58250 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2CBOYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 09:24:10 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
Date: Fri, 2 Mar 2012 15:23:53 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Rob Clark <rob@ti.com>, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Alexander Deucher <alexander.deucher@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1654816.MX2JJ87BEo@avalon> <1775349.d0yvHiVdjB@avalon>
In-Reply-To: <1775349.d0yvHiVdjB@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021523.54173.heiko@sntech.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 17. Februar 2012, 00:25:51 schrieb Laurent Pinchart:
> Hello everybody,
> 
> First of all, I would like to thank all the attendees for their
> participation in the mini-summit that helped make the meeting a success.
> 
> Here are my consolidated notes that cover both the Linaro Connect meeting
> and the ELC meeting. They're also available at
> http://www.ideasonboard.org/media/meetings/.
> 
> 
> Kernel Display and Video API Consolidation mini-summit at ELC 2012
> ------------------------------------------------------------------
> 
[...]
> ***  Display Panel Drivers ***
> 
>   Goal: Sharing display panel drivers between display controllers from
>   different vendors.
> 
>   Panels are connected to the display controller through a standard bus
> with a control channel (DSI and eDP are two major such buses). Various
> vendors have created proprietary interfaces for panel drivers:
> 
>   - TI on OMAP (drivers/video/omap2/displays).
>   - Samsung on Exynos (drivers/video/exynos).
>   - ST-Ericsson on MCDE
> (http://www.igloocommunity.org/gitweb/?p=kernel/igloo-
> kernel.git;a=tree;f=drivers/video/mcde)
>   - Renesas is working on a similar interface for SH Mobile.
> 
>   HDMI-on-DSI transmitters, while not panels per-se, can be supported
> through the same API.
> 
>   A Low level Linux Display Framework (https://lkml.org/lkml/2011/9/15/107)
>   has been proposed and overlaps with this topic.
> 
>   For DSI, a possible abstraction level would be a DCS (Display Command
> Set) bus. Panels and/or HDMI-on-DSI transmitter drivers would be
> implemented as DCS drivers.
> 
>   Action points:
>   - Marcus to work on a proposal for DCS-based panels (with Tomi Valkeinen
> and Morimoto-san).

It would also be interesting to see something similar for MIPI-DBI (type B for 
me) [aka rfbi on omap], as most epaper displays use this to transmit data and 
currently use half-baked interfaces.

So hopefully I'll be able to follow the discussion and can then try to convert 
your findings to the dbi case.

Heiko
