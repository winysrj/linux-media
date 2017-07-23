Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:38965 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755241AbdGWMMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 08:12:15 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 0/3] fix compile for kernel 3.13
Date: Sun, 23 Jul 2017 14:12:01 +0200
Message-Id: <1500811924-4559-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

This series fixed compilation errors for older kernels.
I have tested it with Kernel 3.13 and Daniel with Kernel 4.12.

I disabled VIDEO_OV5670 for all kernels older than 3.17, but I am not 100% 
sure if the required change to compile it was really implemented in that
version (checked only the revision history).

This series requires "Add compat code for skb_put_data" from Matthias
Schwarzott to be applied first (see 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg116145.html )

Daniel Scheller (1):
  build: fix up build w/kernels <=4.12 by reverting 4.13 patches

Jasmin Jessich (2):
  build: Add compat code for pm_runtime_get_if_in_use
  build: Disable VIDEO_OV5670 for Kernels older that 3.17

 backports/backports.txt                            |  3 +
 .../v4.12_revert_solo6x10_copykerneluser.patch     | 71 ++++++++++++++++++++++
 v4l/compat.h                                       | 15 +++++
 v4l/scripts/make_config_compat.pl                  |  1 +
 v4l/versions.txt                                   |  1 +
 5 files changed, 91 insertions(+)
 create mode 100644 backports/v4.12_revert_solo6x10_copykerneluser.patch

-- 
2.7.4
