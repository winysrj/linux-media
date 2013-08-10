Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44029 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753292Ab3HJRnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 13:43:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: andriy.shevchenko@intel.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/4] smiapp: Small cleanup; clock framework fixes and clock tree comments
Date: Sat, 10 Aug 2013 20:49:44 +0300
Message-Id: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset contains Andy's cleanup patch (with clamp_t replaced with
clamp) and a few clock tree interface related fixes and a few comments to
PLL calculation.

-- 
Cheers,
Sakari

