Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:63968 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752116AbeDRL6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:58:20 -0400
Date: Wed, 18 Apr 2018 14:58:16 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 04/10] media: ov772x: add media controller support
Message-ID: <20180418115816.4awh2xejtng6q2ui@paasikivi.fi.intel.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
 <20180418112814.GA20486@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418112814.GA20486@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 01:28:14PM +0200, jacopo mondi wrote:
> Hi Akinobu,
> 
> On Mon, Apr 16, 2018 at 11:51:45AM +0900, Akinobu Mita wrote:
> > Create a source pad and set the media controller type to the sensor.
> >
> > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> 
> Not strictly on this patch, but I'm a bit confused on the difference
> between CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API...
> Doesn't media controller support mandate implementing subdev APIs as
> well?

The subdev uAPI depends on MC.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
