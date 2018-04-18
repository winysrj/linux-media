Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:47154 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbeDRNFT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 09:05:19 -0400
Date: Wed, 18 Apr 2018 16:05:04 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 04/10] media: ov772x: add media controller support
Message-ID: <20180418130504.bfmnk5rnrkcmiqjh@paasikivi.fi.intel.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
 <20180418112814.GA20486@w540>
 <20180418115816.4awh2xejtng6q2ui@paasikivi.fi.intel.com>
 <20180418121317.GF20486@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418121317.GF20486@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 02:13:17PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Wed, Apr 18, 2018 at 02:58:16PM +0300, Sakari Ailus wrote:
> > On Wed, Apr 18, 2018 at 01:28:14PM +0200, jacopo mondi wrote:
> > > Hi Akinobu,
> > >
> > > On Mon, Apr 16, 2018 at 11:51:45AM +0900, Akinobu Mita wrote:
> > > > Create a source pad and set the media controller type to the sensor.
> > > >
> > > > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > >
> > > Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> > >
> > > Not strictly on this patch, but I'm a bit confused on the difference
> > > between CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API...
> > > Doesn't media controller support mandate implementing subdev APIs as
> > > well?
> >
> > The subdev uAPI depends on MC.
> 
> Again, sorry for not being clear. Can an mc-compliant device not
> implement sudev uAPIs ?

In principle, yes. Still, for a sensor driver supporting MC it only makes
sense if it also supports sub-device uAPI.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
