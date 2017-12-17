Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51806 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdLQQww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 11:52:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/5] include: v4l2_async: Add 'owner' field to notifier
Date: Sun, 17 Dec 2017 18:53:00 +0200
Message-ID: <2892432.nXKeGORp37@avalon>
In-Reply-To: <20171215143816.lmnpcfdbt7l7yeox@paasikivi.fi.intel.com>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org> <1513189580-32202-4-git-send-email-jacopo+renesas@jmondi.org> <20171215143816.lmnpcfdbt7l7yeox@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, 15 December 2017 16:38:16 EET Sakari Ailus wrote:
> Hi Jacopo,
> 
> On Wed, Dec 13, 2017 at 07:26:18PM +0100, Jacopo Mondi wrote:
> > Notifiers can be registered as root notifiers (identified by a 'struct
> > v4l2_device *') or subdevice notifiers (identified by a 'struct
> > v4l2_subdev *'). In order to identify a notifier no matter if it is root
> > or not, add a 'struct fwnode_handle *owner' field, whose name can be
> > printed out for debug purposes.
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> You'll have struct device either through the v4l2_device or v4l2_subdev. Do
> you need an additional field for this?

I agree with this comment. If there's a reason to add a new field, its life 
time constraints should be documented. The fwnodes are refcounted and you're 
not increasing the refcount here, you should explain why you don't need to.

-- 
Regards,

Laurent Pinchart
