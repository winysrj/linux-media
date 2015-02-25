Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51523 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753041AbbBYMdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 07:33:43 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 22B346009F
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 14:33:38 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/3] Add unlocked v4l2_grab_ctrl(), use it in smiapp driver
Date: Wed, 25 Feb 2015 14:33:24 +0200
Message-Id: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset adds an unlocked variant of v4l2_grab_ctrl() which then is
used by the smiapp driver.


-- 
Regards,
Sakari
