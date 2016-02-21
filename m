Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55516 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751064AbcBUVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:36:20 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: [RFC 0/4] MC v2 cleanups
Date: Sun, 21 Feb 2016 23:36:11 +0200
Message-Id: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a few RFC patches to clean up the recent MC v2 API additions.

Let me know what you think.

At least the compat IOCTL handling requires some work still in general (MC
v2 or not).

-- 
Kind regards,
Sakari

