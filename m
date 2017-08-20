Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35136 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753100AbdHTOgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 10:36:51 -0400
Received: by mail-wr0-f196.google.com with SMTP id p8so10870235wrf.2
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 07:36:51 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at, mchehab@kernel.org
Subject: [PATCH 1/3] [media_build] fix pr_fmt patch wrt the ddbridge code bump
Date: Sun, 20 Aug 2017 16:36:46 +0200
Message-Id: <20170820143648.27669-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170820143648.27669-1-d.scheller.oss@gmail.com>
References: <20170820143648.27669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 backports/pr_fmt.patch | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/backports/pr_fmt.patch b/backports/pr_fmt.patch
index 7bfe547..09ca713 100644
--- a/backports/pr_fmt.patch
+++ b/backports/pr_fmt.patch
@@ -607,10 +607,10 @@ index 6777926f20f2..74358ade87f2 100644
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
  
  #include <linux/pci.h>
-diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
+diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
 index 32f4d3746c8e..660898d16268 100644
---- a/drivers/media/pci/ddbridge/ddbridge-core.c
-+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
+--- a/drivers/media/pci/ddbridge/ddbridge-main.c
++++ b/drivers/media/pci/ddbridge/ddbridge-main.c
 @@ -17,6 +17,7 @@
   * http://www.gnu.org/copyleft/gpl.html
   */
-- 
2.13.0
