Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51482 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751007AbeECPfW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 11:35:22 -0400
Date: Thu, 3 May 2018 18:35:19 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH 1/2] dt-bindings: media: Add "upside-down" property to
 tell sensor orientation
Message-ID: <20180503153519.w7utyz3inxr4u2gw@paasikivi.fi.intel.com>
References: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
 <20180502213115.24000-2-sakari.ailus@linux.intel.com>
 <20180503152659.x3zh3d747kdr3ymf@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503152659.x3zh3d747kdr3ymf@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Thu, May 03, 2018 at 05:26:59PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Thu, May 03, 2018 at 12:31:14AM +0300, Sakari Ailus wrote:
> > Camera sensors are occasionally mounted upside down. In order to use such
> > a sensor without having to turn every image upside down separately, most
> > camera sensors support reversing the readout order by setting both
> > horizontal and vertical flipping.
> > 
> > This patch adds a boolean property to tell a sensor is mounted upside
> > down.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I think the DT binding should use a rotation property instead,
> similar to the panel bindings:
> 
> Documentation/devicetree/bindings/display/panel/panel.txt

Good point. I was trying to find something relevant relating to e.g.
orientation but this one escaped me.

So... I'll abandon this patch, and use the "rotation" property instead.
I'll send v2 of the smiapp patch. I think I'll actually split that into
two, DT and driver changes.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
