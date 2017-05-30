Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750951AbdE3OD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 10:03:27 -0400
Date: Tue, 30 May 2017 17:02:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4 1/4] media-ctl: add pad support to
 set/get_frame_interval
Message-ID: <20170530140253.GB1019@valkosipuli.retiisi.org.uk>
References: <1490892676-11634-1-git-send-email-p.zabel@pengutronix.de>
 <1496149479.5485.9.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496149479.5485.9.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 30, 2017 at 03:04:39PM +0200, Philipp Zabel wrote:
> Hi,
> 
> On Thu, 2017-03-30 at 18:51 +0200, Philipp Zabel wrote:
> > This allows to set and get the frame interval on pads other than pad 0.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> any more comments on these?

Apparently not. Pushed to master.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
