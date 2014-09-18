Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34608 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932707AbaIRV5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 17:57:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/3] vb2 and omap3isp driver fixes
Date: Fri, 19 Sep 2014 00:57:46 +0300
Message-Id: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Laurent and others,

This small set fixes a videobuf2 issue related to returning queued buffers
back to the driver. I found it after hopefully fixing a related issue (two
later patches) in the omap3isp driver.

The patchset has been tested up to streamon, but no buffers have been
successfully dequeued. That's exactly the remaining unresolved technical
problem from the N9 DT camera support patchset: I get no ISP interrupts at
all.

-- 
Kind regards,
Sakari

