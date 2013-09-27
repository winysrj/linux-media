Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38088 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3I0SvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 14:51:01 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so2905114pbc.21
        for <linux-media@vger.kernel.org>; Fri, 27 Sep 2013 11:51:01 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	t.katayama@jp.fujitsu.com, vikas.sajjan@linaro.org,
	linaro-kernel@lists.linaro.org, tom.cooksey@arm.com,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH/CDF RFC v3 0/3] Migrate CDFv3 into pl111 drm/kms driver
Date: Sat, 28 Sep 2013 02:50:43 +0800
Message-Id: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This series patches base on Tom's "Initial drm/kms driver for pl111"[1]
with linaro release 13.07 and migrate the CDFv3 for evaluation.
please notes that I set VGA as default output and tested on RTSM only.

[1] http://lwn.net/Articles/561344/

Cheers,

Show Liu

Show Liu (3):
  Add display entities and pipe link for pl111
  Add display entity and set VGA output(site MB) as default
  add pipe link for display entity

 arch/arm/boot/dts/rtsm_ve-motherboard.dtsi     |   46 +++
 arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts |    4 +
 drivers/gpu/drm/pl111/pl111_drm.h              |   23 +-
 drivers/gpu/drm/pl111/pl111_drm_device.c       |  374 ++++++++++++++++++++++--
 drivers/video/vexpress-dvi.c                   |   94 +++++-
 5 files changed, 503 insertions(+), 38 deletions(-)

-- 
1.7.9.5

