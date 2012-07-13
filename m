Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:29898 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab2GMMnl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 08:43:41 -0400
Message-ID: <50001810.4020200@iki.fi>
Date: Fri, 13 Jul 2012 15:44:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Subject: Re: [PATCH] omap3isp: preview: Fix output size computation depending
 on input format
References: <1341510334-9791-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341510334-9791-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> The preview engine crops 4 columns and 4 lines when CFA is enabled.
> Commit b2da46e52fe7871cba36e1a435844502c0eccf39 ("omap3isp: preview: Add
> support for greyscale input") inverted the condition by mistake, fix
> this.
> 
> Reported-by: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi


