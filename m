Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40329 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1FAHHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 03:07:38 -0400
Date: Wed, 1 Jun 2011 10:07:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "JAIN, AMBER" <amber@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
 not configured on OMAP
Message-ID: <20110601070733.GC4991@valkosipuli.localdomain>
References: <1306835503-24631-1-git-send-email-amber@ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037B65850E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB037B65850E@dbde02.ent.ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 31, 2011 at 03:58:46PM +0530, JAIN, AMBER wrote:
> I have tested it on OMAP4430 blaze and OMAP3430 SDP platforms.
> 
> I do not have the hardware to test omap24xxcam change. Can someone please
> help me on this?

I have the hardware, but this driver is not testable right now as it is in
the mainline since the board code for the camera is missing from N8[01]0
(besides cbus driver AFAIR). However the change seems practically mandatory
to me --- I can ack it if you send a patch against omap24xxcam.c, as your
new patch no longer contains the change for omap24xxcam.c.

Thanks.

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
