Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53716 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755968AbaFLQJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:09:53 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E624A60093
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:09:50 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] v4l: ctrls: Unlocked variants of (some) functions for driver's internal use
Date: Thu, 12 Jun 2014 19:09:38 +0300
Message-Id: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset adds unlocked variants of control framework functions to
set controls and modify their range. As in many cases the driver internal
data structures are protected using the same lock the control handler uses,
thus either forcing to poke the control framework data structures directly
or releasing the lock which leads to serialisation issues.

Also use the new unlocked variants in the smiapp driver.

-- 
Kind regards,
Sakari

