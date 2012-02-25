Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40699 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:13 -0500
Date: Sat, 25 Feb 2012 03:52:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 31/33] omap3isp: Remove isp_validate_pipeline and
 other old stuff
Message-ID: <20120225015209.GG12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-31-git-send-email-sakari.ailus@iki.fi>
 <5497917.JsAkhUn8fq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5497917.JsAkhUn8fq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Feb 22, 2012 at 12:26:30PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Monday 20 February 2012 03:57:10 Sakari Ailus wrote:
> > Remove isp_set_pixel_clock().
> > 
> > Remove set_pixel_clock() callback from platform callbacks since the same
> > information is now passed to the ISP driver by other means.
> >
> > Remove struct ispccdc_vp since the only field in this structure, pixelclk,
> > is no longer used.
> > 
> > Remove isp_video_is_shiftable() --- this will live on as ccdc_is_shiftable
> > in ispccdc.c.
> 
> Could you please move those changes to the patches where you add them to the 
> other modules ?

Ack. I'll fix this for the next version.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
