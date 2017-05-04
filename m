Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59909 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753283AbdEDNne (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 09:43:34 -0400
Message-ID: <1493905412.2381.20.camel@pengutronix.de>
Subject: Re: [PATCH v3.1 4/7] v4l: Switch from V4L2 OF not V4L2 fwnode API
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Date: Thu, 04 May 2017 15:43:32 +0200
In-Reply-To: <1493121374-13298-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
         <1493121374-13298-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-04-25 at 14:56 +0300, Sakari Ailus wrote:
> Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
> Async OF matching is replaced by fwnode matching and OF matching support
> is removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Benoit Parrot <bparrot@ti.com> # i2c/ov2569.c, am437x/am437x-vpfe.c and ti-vpe/cal.c
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com> # Atmel sama5d3 board + ov2640 sensor

Tested and works on v4.11 with Steve's imx-media-staging-md branch on
Nitrogen6X i.MX6Q + Toshiba TC358743 HDMI to MIPI CSI-2 bridge.

Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
