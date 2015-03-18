Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49895 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753807AbbCRXvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 19:51:14 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, t-kristo@ti.com,
	linux-media@vger.kernel.org
Subject: [PATCH v2 0/3] OMAP 3 ISP (and N9/N950 primary camera support) dts changes
Date: Thu, 19 Mar 2015 01:50:21 +0200
Message-Id: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Since v1, I've rebased the set on Tero Kristo's PRCM / SCM cleanup patchset
here:

<URL:http://www.spinics.net/lists/linux-omap/msg116949.html>

v1 can be found here:

<URL:http://www.spinics.net/lists/linux-omap/msg116753.html>

Changes since v1:

- Fixed phy reference (number to name) in the example,

- Dropped the first patch. This is already done by Tero's patch "ARM: dts:
  omap3: merge control module features under scrm node".

-- 
Kind regards,
Sakari

