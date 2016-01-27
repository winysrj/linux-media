Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55748 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932433AbcA0NvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:51:08 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8EC7C60098
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 15:51:03 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] Unify MC graph power management code
Date: Wed, 27 Jan 2016 15:50:53 +0200
Message-Id: <1453902658-29783-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set unifies the MC graph power management code for the omap3isp and
omap4iss drivers. The implementation may also be useful for other drivers
managing the power state for drivers which provide MC, V4L2 sub-device and
V4L2 interfaces.

The original implementation has been in the mainline kernel for quite a
while. During that time, changes that introduced bugs in the code have
been made and the fixes written after those bugs were found, ended up
being applied a lot later to the omap4iss implementation.

In the future this should be moved to make use of runtime PM, which
should be easier when we only have a single implementation.

-- 
Kind regards,
Sakari

