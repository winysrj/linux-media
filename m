Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36492 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754264AbdGXUxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 16:53:44 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 0/3] fix compile for kernel 3.13
Date: Mon, 24 Jul 2017 22:53:34 +0200
Message-Id: <1500929617-13623-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Changes since V1:
- CEC_PIN and VIDEO_OV5670 disabled for all kernels older 4.10.

This series fixed compilation errors for older kernels.
I have tested it with Kernel 3.13 and Daniel with Kernel 4.12 and
someone else with Kernel 4.4.

CEC_PIN and VIDEO_OV5670 is now disabled for all kernels older 4.10.

This series requires "Add compat code for skb_put_data" from Matthias
Schwarzott to be applied first (see 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg116145.html )

Daniel Scheller (2):
  build: CEC_PIN and the VIDEO_OV5670 driver both require kernel 4.10 to compile
  build: fix up build w/kernels <=4.12 by reverting 4.13 patches

Jasmin Jessich (1):
  build: Add compat code for pm_runtime_get_if_in_use

 backports/backports.txt                            |  3 +
 .../v4.12_revert_solo6x10_copykerneluser.patch     | 71 ++++++++++++++++++++++
 v4l/compat.h                                       | 15 +++++
 v4l/scripts/make_config_compat.pl                  |  1 +
 v4l/versions.txt                                   |  6 ++
 5 files changed, 96 insertions(+)
 create mode 100644 backports/v4.12_revert_solo6x10_copykerneluser.patch

-- 
2.7.4
