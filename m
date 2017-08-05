Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36385 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdHEBvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Aug 2017 21:51:38 -0400
Date: Fri, 4 Aug 2017 21:51:38 -0400
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] imon: constify attribute_group structures
Message-ID: <20170805015137.GA5228@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Functions working with attribute_groups provided by <linux/sysfs.h>
work with const attribute_group. These attribute_group structures do not
change at runtime so mark them as const.

File size before:
 text      data     bss     dec     hex filename
 36981    16776     960   54717    d5bd drivers/media/rc/imon.o

File size after:
 text      data     bss     dec     hex filename
 37173    16584     960   54717    d5bd drivers/media/rc/imon.o

This change was made with the help of Coccinelle.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/rc/imon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index bd76534..717ba78 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -911,7 +911,7 @@ static struct attribute *imon_display_sysfs_entries[] = {
 	NULL
 };
 
-static struct attribute_group imon_display_attr_group = {
+static const struct attribute_group imon_display_attr_group = {
 	.attrs = imon_display_sysfs_entries
 };
 
@@ -920,7 +920,7 @@ static struct attribute *imon_rf_sysfs_entries[] = {
 	NULL
 };
 
-static struct attribute_group imon_rf_attr_group = {
+static const struct attribute_group imon_rf_attr_group = {
 	.attrs = imon_rf_sysfs_entries
 };
 
-- 
2.7.4
