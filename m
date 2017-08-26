Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:50215 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdHZCJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 22:09:36 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: ddbridge can be now compiled for kernels older than 3.8
Date: Sat, 26 Aug 2017 04:09:29 +0200
Message-Id: <1503713370-32220-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

When you have already applied patch
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg117633.html
this patch will re-enable ddbridge for all older Kernels.
I have tested it with Kernel 2.6.36, 2.6.37, 3.4, 3.13 and 4.4.

Please note, that you need to apply the patch series
  "fix compile for kernel 3.3 and older"
    ->  build: Add compat code for PCI_DEVICE_SUB
        build: Fixed backports/v3.3_eprobe_defer.patch
to be able to compile ddbridge for Kernels <=3.3.

Jasmin Jessich (1):
  build: ddbridge can be now compiled for kernels older than 3.8

 v4l/versions.txt | 2 --
 1 file changed, 2 deletions(-)

-- 
2.7.4
