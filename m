Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41646 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389749AbeIURwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 13:52:18 -0400
Date: Fri, 21 Sep 2018 15:03:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, jacopo@jmondi.org,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
Message-ID: <20180921120342.ku3ed3jkn5puavu6@valkosipuli.retiisi.org.uk>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1658112.YQ0khu1noY@avalon>
 <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
 <6518376.j8BxZoQUpz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6518376.j8BxZoQUpz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Sep 21, 2018 at 01:01:09PM +0300, Laurent Pinchart wrote:
...
> > There is also the oddball one of the TC358743 which dynamically
> > switches the number of lanes in use based on the data rate required.
> > That's probably a separate discussion, but is currently dealt with via
> > g_mbus_config as amended back in Sept 2017 [1].
> 
> This falls into the case of dynamic configuration discovery and negotiation I 
> mentioned above, and we clearly need to make sure the v4l2_subdev API supports 
> this use case.

This could be added to struct v4l2_mbus_frame_desc; Niklas has driver that
uses the framework support here, so this would likely end up merged soon:

<URL:https://git.linuxtv.org/sailus/media_tree.git/tree/include/media/v4l2-subdev.h?h=vc&id=0cbd2b25b37ef5b2e6a14340dbca6d2d2d5af98e>

The CSI-2 bus parameters are missing there currently but nothing prevents
adding them. The semantics of set_frame_desc() needs to be probably defined
better than it currently is.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
