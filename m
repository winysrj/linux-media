Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52610 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab2BYBqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 20:46:25 -0500
Date: Sat, 25 Feb 2012 03:46:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 28/33] omap3isp: Move setting constaints above
 media_entity_pipeline_start
Message-ID: <20120225014622.GE12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-28-git-send-email-sakari.ailus@iki.fi>
 <1529298.XktDfWDNzA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529298.XktDfWDNzA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Feb 22, 2012 at 12:12:58PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Monday 20 February 2012 03:57:07 Sakari Ailus wrote:
> 
> Could you please briefly explain why this is needed ?

Sure. The clock rates are now acquired during pipeline validation which is
now part of media_entity_pipeline_start(). For that reason we set
constraints earlier on.

I'll add this to the description.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
