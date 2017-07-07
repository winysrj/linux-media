Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35585 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdGGIYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 04:24:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sean@mess.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc: constify attribute_group structures.
Date: Fri,  7 Jul 2017 13:53:54 +0530
Message-Id: <1e1e463f79d831a77eb1d57c6f677979bb01d9d7.1499415668.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work with const
attribute_group. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  11605	    880	     20	  12505	   30d9	drivers/media/rc/rc-main.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  11797	    720	     20	  12537	   30f9	drivers/media/rc/rc-main.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/rc/rc-main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6ec7335..61d3e1c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1550,7 +1550,7 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 	NULL,
 };
 
-static struct attribute_group rc_dev_protocol_attr_grp = {
+static const struct attribute_group rc_dev_protocol_attr_grp = {
 	.attrs	= rc_dev_protocol_attrs,
 };
 
@@ -1560,7 +1560,7 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 	NULL,
 };
 
-static struct attribute_group rc_dev_filter_attr_grp = {
+static const struct attribute_group rc_dev_filter_attr_grp = {
 	.attrs	= rc_dev_filter_attrs,
 };
 
@@ -1571,7 +1571,7 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 	NULL,
 };
 
-static struct attribute_group rc_dev_wakeup_filter_attr_grp = {
+static const struct attribute_group rc_dev_wakeup_filter_attr_grp = {
 	.attrs	= rc_dev_wakeup_filter_attrs,
 };
 
-- 
1.9.1
