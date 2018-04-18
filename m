Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:5627 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752712AbeDRNRI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 09:17:08 -0400
Date: Wed, 18 Apr 2018 16:17:02 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 10/10] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180418131702.rgxtqct6htzt3rnq@paasikivi.fi.intel.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com>
 <20180418125536.GB3999@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418125536.GB3999@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 02:55:36PM +0200, jacopo mondi wrote:
> Hi Akinobu,
> 
> On Mon, Apr 16, 2018 at 11:51:51AM +0900, Akinobu Mita wrote:
> > The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> > and the s_frame_interval() in subdev video ops could be called when the
> > device is under power saving mode.  These callbacks for ov772x driver
> > cause updating H/W registers that will fail under power saving mode.
> >
> 
> I might be wrong, but if the sensor is powered off, you should not
> receive any subdev_pad_ops function call if sensor is powered off.

This happens (now that the driver supports sub-device uAPI) if the user
opens a sub-device node but the main driver has not powered the sensor on.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
