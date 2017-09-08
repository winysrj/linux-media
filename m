Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47906 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933298AbdIHNXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:23:36 -0400
Date: Fri, 8 Sep 2017 16:23:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] as3645a: Use integer numbers for parsing LEDs
Message-ID: <20170908132333.rlhurlwrzq43ss2k@valkosipuli.retiisi.org.uk>
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
 <20170908124213.18904-4-sakari.ailus@linux.intel.com>
 <20170908131758.GQ18365@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908131758.GQ18365@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the review.

On Fri, Sep 08, 2017 at 03:17:58PM +0200, Pavel Machek wrote:
> On Fri 2017-09-08 15:42:13, Sakari Ailus wrote:
> > Use integer numbers for LEDs, 0 is the flash and 1 is the indicator.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Dunno. Old code is shorter, old device tree is shorter, ... IMO both
> versions are fine, because the LEDs are really different. Do we have
> documentation somewhere saying that reg= should be used for this? Are
> you doing this for consistency?

Well, actually for ACPI support. :-) It requires less driver changes this
way. See 17th and 18th patches in "[PATCH v9 00/23] Unified fwnode endpoint
parser, async sub-device notifier support, N9 flash DTS".

A number of chips have LED binding that is aligned, see e.g.
Documentation/devicetree/bindings/leds/leds-bcm6328.txt .

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
