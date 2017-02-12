Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33624 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750882AbdBLWpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 17:45:01 -0500
Date: Mon, 13 Feb 2017 00:44:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 3/4] media-ctl: propagate frame interval
Message-ID: <20170212224426.GE16975@valkosipuli.retiisi.org.uk>
References: <20170207160850.10299-1-p.zabel@pengutronix.de>
 <20170207160850.10299-4-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207160850.10299-4-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Feb 07, 2017 at 05:08:49PM +0100, Philipp Zabel wrote:
> Same as the media bus format, the frame interval should be propagated
> from output pads to connected entities' input pads.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
