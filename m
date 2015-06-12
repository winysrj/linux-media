Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37592 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750949AbbFLGln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:41:43 -0400
Date: Fri, 12 Jun 2015 09:41:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	j.anaszewski@samsung.com, cooloney@gmail.com,
	g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v1.3 1/5] v4l: async: Add a pointer to of_node to struct
 v4l2_subdev, match it
Message-ID: <20150612064109.GT5904@valkosipuli.retiisi.org.uk>
References: <1433971645-32304-1-git-send-email-sakari.ailus@iki.fi>
 <1434050281-27861-1-git-send-email-sakari.ailus@iki.fi>
 <4041793.jETg7P3oYY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4041793.jETg7P3oYY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 11, 2015 at 10:27:30PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 11 June 2015 22:18:01 Sakari Ailus wrote:
> > V4L2 async sub-devices are currently matched (OF case) based on the struct
> > device_node pointer in struct device. LED devices may have more than one
> > LED, and in that case the OF node to match is not directly the device's
> > node, but a LED's node.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Bryan, could you apply the patch to your tree? It's required by Jacek's
patchset you attempted to apply a few days back.

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
