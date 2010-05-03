Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22181 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab0ECPma (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:42:30 -0400
Message-ID: <4BDEEEDF.7050905@maxwell.research.nokia.com>
Date: Mon, 03 May 2010 18:42:23 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/1] V4L: Event: debugging fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Laurent Pinchart found that on uni-processor kernels without spinlock
debugging spin_is_locked() is always zero, which causes a bad WARN_ON()
message to be shown. The following patch removes the WARN_ON() and
replaces it with assert_spin_locked() which works correctly.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
