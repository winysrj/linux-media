Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45400 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751761AbdHGWpj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 18:45:39 -0400
Date: Tue, 8 Aug 2017 01:45:32 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] v4l2-flash-led-class: Create separate sub-devices
 for indicators
Message-ID: <20170807222502.ctdehs5tyce2hkfj@kekkonen.localdomain>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-3-sakari.ailus@linux.intel.com>
 <20170719120246.GB23510@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719120246.GB23510@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 19, 2017 at 02:02:46PM +0200, Pavel Machek wrote:
> On Tue 2017-07-18 21:41:07, Sakari Ailus wrote:
> > The V4L2 flash interface allows controlling multiple LEDs through a single
> > sub-devices if, and only if, these LEDs are of different types. This
> > approach scales badly for flash controllers that drive multiple flash LEDs
> > or for LED specific associations. Essentially, the original assumption of a
> > LED driver chip that drives a single flash LED and an indicator LED is no
> > longer valid.
> > 
> > Address the matter by registering one sub-device per LED.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!

> Does anything need to be done with drivers/media/i2c/adp1653.c ?

No, it's stand-alone and does not use the V4L2 flash LED class
framework-let.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
