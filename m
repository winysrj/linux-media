Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33966 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbdKEX2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 18:28:52 -0500
Date: Thu, 2 Nov 2017 20:44:27 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 1/1] media: i2c: as3645a: Remove driver
Message-ID: <20171102184427.ggyycfpl7pvjzw3v@kekkonen.localdomain>
References: <20170908135140.7733-1-sakari.ailus@linux.intel.com>
 <22877093.EMcDjJJEP6@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22877093.EMcDjJJEP6@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 07:44:24PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 8 September 2017 16:51:40 EET Sakari Ailus wrote:
> > Remove the V4L2 AS3645A sub-device driver in favour of the LED flash class
> > driver for the same hardware, drivers/leds/leds-as3645a.c. The latter uses
> > the V4L2 flash LED class framework to provide V4L2 sub-device interface.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Merci! :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
