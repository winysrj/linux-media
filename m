Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:2684 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755322AbdLOOit (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:38:49 -0500
Date: Fri, 15 Dec 2017 16:38:16 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/5] include: v4l2_async: Add 'owner' field to notifier
Message-ID: <20171215143816.lmnpcfdbt7l7yeox@paasikivi.fi.intel.com>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
 <1513189580-32202-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513189580-32202-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Dec 13, 2017 at 07:26:18PM +0100, Jacopo Mondi wrote:
> Notifiers can be registered as root notifiers (identified by a 'struct
> v4l2_device *') or subdevice notifiers (identified by a 'struct
> v4l2_subdev *'). In order to identify a notifier no matter if it is root
> or not, add a 'struct fwnode_handle *owner' field, whose name can be
> printed out for debug purposes.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

You'll have struct device either through the v4l2_device or v4l2_subdev. Do
you need an additional field for this?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
