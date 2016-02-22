Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49800 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752199AbcBVUrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:47:08 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 0/4] MC v2 cleanups
Date: Mon, 22 Feb 2016 22:47:00 +0200
Message-Id: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I've made small updates to the MC v2 cleanup set. v1 is here:

<URL:http://www.spinics.net/lists/linux-media/msg97694.html>

These changes are, since v1:

- Don't align the G_TOPOLOGY array argument structs to a power of 2, but 8
  bytes

- Move media_get_uptr() macro to media-device.c instead of removing it

-- 
Kind regards,
Sakari

