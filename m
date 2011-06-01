Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47033 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab1FAH2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 03:28:54 -0400
From: "JAIN, AMBER" <amber@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Wed, 1 Jun 2011 12:57:11 +0530
Subject: RE: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
 not configured on OMAP
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB037A28AD31@dbde02.ent.ti.com>
References: <1306835503-24631-1-git-send-email-amber@ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037B65850E@dbde02.ent.ti.com>,<20110601070733.GC4991@valkosipuli.localdomain>
In-Reply-To: <20110601070733.GC4991@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As per Vaibhav's review comments, I have split the patch into 2 different (independent) patches:
- one for omap_vout
- and another for omap24xxcam.c (name changed to [PATCH] OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP )
If you have difficulty in finding it I can send it again.

Thanks,
Amber

________________________________________
From: Sakari Ailus [sakari.ailus@iki.fi]
Sent: Wednesday, June 01, 2011 12:37 PM
To: JAIN, AMBER
Cc: linux-media@vger.kernel.org; Hiremath, Vaibhav
Subject: Re: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP

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
