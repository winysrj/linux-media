Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52621 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3EYL0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:26:08 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so2892249bkc.20
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:26:06 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 0/5] arm/exynos compilation warning fixes
Date: Sat, 25 May 2013 13:25:50 +0200
Message-Id: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set fixes couple issues that cause warnings seen in the media 
daily build. Any testing/ack are welcome, as these patches are completely 
untested yet.

Sylwester Nawrocki (5):
  s5c73m3: Do not ignore errors from regulator_enable()
  s5p-tv: Don't ignore return value of regulator_enable() in
    sii9234_drv.c
  s5p-tv: Do not ignore regulator/clk API return values in sdo_drv.c
  s5p-tv: Don't ignore return value of regulator_bulk_enable() in
    hdmi_drv.c
  s5p-mfc: Remove unused s5p_mfc_get_decoded_status_v6() function

 drivers/media/i2c/s5c73m3/s5c73m3-core.c        |    9 ++++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 +-------
 drivers/media/platform/s5p-tv/hdmi_drv.c        |   16 ++++++++++++----
 drivers/media/platform/s5p-tv/sdo_drv.c         |   22 +++++++++++++++++++---
 drivers/media/platform/s5p-tv/sii9234_drv.c     |    4 +++-
 5 files changed, 41 insertions(+), 18 deletions(-)

-- 
1.7.4.1
