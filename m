Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33244 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdGGIPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 04:15:35 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] imon: constify attribute_group structures.
Date: Fri,  7 Jul 2017 13:45:12 +0530
Message-Id: <6832741975a38cd1fe35e2bd36fc510f74ffde54.1499415018.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work with const
attribute_group. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  18551	   2256	     77	  20884	   5194	drivers/media/rc/imon.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  18679	   2160	     77	  20916	   51b4	drivers/media/rc/imon.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/rc/imon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3489010..e9cbfccd 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -911,7 +911,7 @@ static DEVICE_ATTR(associate_remote, S_IWUSR | S_IRUGO, show_associate_remote,
 	NULL
 };
 
-static struct attribute_group imon_display_attr_group = {
+static const struct attribute_group imon_display_attr_group = {
 	.attrs = imon_display_sysfs_entries
 };
 
@@ -920,7 +920,7 @@ static DEVICE_ATTR(associate_remote, S_IWUSR | S_IRUGO, show_associate_remote,
 	NULL
 };
 
-static struct attribute_group imon_rf_attr_group = {
+static const struct attribute_group imon_rf_attr_group = {
 	.attrs = imon_rf_sysfs_entries
 };
 
-- 
1.9.1
