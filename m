Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:45397 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbdLAMbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 07:31:39 -0500
Received: by mail-pl0-f67.google.com with SMTP id f6so6220107pln.12
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 04:31:39 -0800 (PST)
From: Jaedon Shin <jaedon.shin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 0/3] Add support compat in dvb_frontend.c
Date: Fri,  1 Dec 2017 21:31:27 +0900
Message-Id: <20171201123130.23128-1-jaedon.shin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series supports compat ioctl for 32-bit user space applications
in 64-bit system.

Jaedon Shin (3):
  media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
  media: dvb_frontend: Add compat_ioctl callback
  media: dvb_frontend: Add commands implementation for compat ioct

 drivers/media/dvb-core/dvb_frontend.c | 159 +++++++++++++++++++++++++++++++++-
 fs/compat_ioctl.c                     |  17 ----
 2 files changed, 156 insertions(+), 20 deletions(-)

-- 
2.15.0
