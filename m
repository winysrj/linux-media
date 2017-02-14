Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38286 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750716AbdBNHHI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:07:08 -0500
Date: Tue, 14 Feb 2017 09:06:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Benoit Parrot <bparrot@ti.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
Message-ID: <20170214070658.GJ16975@valkosipuli.retiisi.org.uk>
References: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
 <1486992496-21078-6-git-send-email-sakari.ailus@linux.intel.com>
 <20170213165746.GB1103@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170213165746.GB1103@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benoit,

On Mon, Feb 13, 2017 at 10:57:47AM -0600, Benoit Parrot wrote:
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Mon [2017-Feb-13 15:28:13 +0200]:
...
> > @@ -421,6 +423,7 @@ config VIDEO_TI_VPE
> >  	select VIDEO_TI_VPDMA
> >  	select VIDEO_TI_SC
> >  	select VIDEO_TI_CSC
> > +	select V4L2_FWNODE
> 
> Sakari,
> 
> TI_VPE does not use async registration, but as you already saw TI_CAL does.
> So adding "select V4L2_FWNODE" should be moved to the VIDEO_TI_CAL section.
> Once that's fixed you can add my acked-by for both the TI_CAL and AM437x_VPFE.

Thanks for the review and for spotting this! I think I just used the name
of the directory, and assumed that the matching Kconfig option is the right
one. There don't seem to be other cases such as that one.

diff:

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index cced276..2f7792c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -129,6 +129,7 @@ config VIDEO_TI_CAL
 	depends on SOC_DRA7XX || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	default n
 	---help---
 	  Support for the TI CAL (Camera Adaptation Layer) block
@@ -423,7 +424,6 @@ config VIDEO_TI_VPE
 	select VIDEO_TI_VPDMA
 	select VIDEO_TI_SC
 	select VIDEO_TI_CSC
-	select V4L2_FWNODE
 	default n
 	---help---
 	  Support for the TI VPE(Video Processing Engine) block

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
