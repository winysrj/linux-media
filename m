Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38293 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGPFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 10:05:33 -0500
Message-ID: <1415372724.29873.7.camel@pengutronix.de>
Subject: Re: [PATCH v3 09/10] gpu: ipu-v3: Make use of media_bus_format enum
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 07 Nov 2014 16:05:24 +0100
In-Reply-To: <1415369269-5064-10-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1415369269-5064-10-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 07.11.2014, 15:07 +0100 schrieb Boris Brezillon:
> In order to have subsytem agnostic media bus format definitions we've
> moved media bus definition to include/uapi/linux/media-bus-format.h and
> prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
> 
> Reference new definitions in the ipu-v3 driver.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

