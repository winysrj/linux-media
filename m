Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58279 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3FIUOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 16:14:55 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so1726348bkc.2
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 13:14:54 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	s.nawrocki@samsung.com
Subject: [REVIEW PATCH v3 0/2] Media link_notify behaviour change and exynos4-is updates
Date: Sun,  9 Jun 2013 22:14:36 +0200
Message-Id: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This is an updated version of the patch set [1], I've dropped patches 
01/11...09/11, which I've already queued for 3.11. This series sits on 
top of my for-next branch [2].

This iteration attempts to address issues pointed out by Sakari, 
thanks! The changes since v2 were:

 - link_notify callback 'flags' argument's type changed to u32,
 - in the omap3isp driver link->flags checked instead of the passed 
   flags argument of the link_notify handler to see if the pipeline 
   should be powered off,
 - in the exynos4-is driver link->flags checked instead of the flags 
   argument of the fimc_md_link_notify() handler to see if the pipelines 
   should be powered on.

Thanks,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg64258.html
[2] http://git.linuxtv.org/snawrocki/samsung.git/for-next

Sylwester Nawrocki (2):
  media: Change media device link_notify behaviour
  exynos4-is: Extend link_notify handler to support fimc-is/lite
    pipelines

 drivers/media/media-entity.c                  |   18 +---
 drivers/media/platform/exynos4-is/media-dev.c |  101 ++++++++++++++++++++-----
 drivers/media/platform/omap3isp/isp.c         |   41 ++++++----
 include/media/media-device.h                  |    9 ++-
 4 files changed, 118 insertions(+), 51 deletions(-)

-- 
1.7.4.1

