Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:49970 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdHZBxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 21:53:05 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 0/2] fix compile for kernel 3.3 and older
Date: Sat, 26 Aug 2017 03:52:55 +0200
Message-Id: <1503712377-31405-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

This series fixed compilation errors for older kernels.
I have tested it with Kernel 2.6.36, 2.6.37, 3.4, 3.13 and 4.4.
Please note, that you need this patch
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg117633.html
applied to be able to compile ddbridge for Kernels <3.14

Jasmin Jessich (2):
  build: Add compat code for PCI_DEVICE_SUB
  build: Fixed backports/v3.3_eprobe_defer.patch

 backports/v3.3_eprobe_defer.patch | 9 ++++-----
 v4l/compat.h                      | 6 ++++++
 v4l/scripts/make_config_compat.pl | 1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.7.4
