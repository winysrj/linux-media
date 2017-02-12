Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33678 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750882AbdBLWuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 17:50:23 -0500
Date: Mon, 13 Feb 2017 00:50:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 4/4] media-ctl: add colorimetry support
Message-ID: <20170212225019.GF16975@valkosipuli.retiisi.org.uk>
References: <20170207160850.10299-1-p.zabel@pengutronix.de>
 <20170207160850.10299-5-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207160850.10299-5-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 07, 2017 at 05:08:50PM +0100, Philipp Zabel wrote:
> media-ctl can be used to propagate v4l2 subdevice pad formats from
> source pads of one subdevice to another one's sink pads. These formats
> include colorimetry information, so media-ctl should be able to print
> or change it using the --set/get-v4l2 option.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
