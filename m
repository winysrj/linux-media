Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750821AbdIIWNJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 18:13:09 -0400
Date: Sun, 10 Sep 2017 01:13:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 24/24] arm: dts: omap3: N9/N950: Add flash references
 to the camera
Message-ID: <20170909221305.lahowwnzlqr3d7vp@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-20-sakari.ailus@linux.intel.com>
 <20170909183240.GA15397@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170909183240.GA15397@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sat, Sep 09, 2017 at 08:32:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Add flash and indicator LED phandles to the sensor node.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I'm adding similar support to et8ek8 and wonder.. why don't you also
> add support for autofocus? Driver not yet available?

I don't think the VCM driver ever got merged. I'd make the changes at the
same time with that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
