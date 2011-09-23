Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1IWSfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 14:35:20 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p8NIZKE8013933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 14:35:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] rc tables: include linux/module.h
Date: Fri, 23 Sep 2011 15:35:05 -0300
Message-Id: <1316802905-23970-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevents errors when merging with -next:

drivers/media/rc/keymaps/rc-snapstream-firefly.c:105:16: error: expected declaration specifiers or ‘...’ before string constant
drivers/media/rc/keymaps/rc-snapstream-firefly.c:106:15: error: expected declaration specifiers or ‘...’ before string constant

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/keymaps/rc-ati-x10.c            |    1 +
 drivers/media/rc/keymaps/rc-medion-x10.c         |    1 +
 drivers/media/rc/keymaps/rc-snapstream-firefly.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index f3397f8..e1b8b26 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -23,6 +23,7 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/module.h>
 #include <media/rc-map.h>
 
 static struct rc_map_table ati_x10[] = {
diff --git a/drivers/media/rc/keymaps/rc-medion-x10.c b/drivers/media/rc/keymaps/rc-medion-x10.c
index 5fc57468..09e2cc0 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10.c
@@ -21,6 +21,7 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/module.h>
 #include <media/rc-map.h>
 
 static struct rc_map_table medion_x10[] = {
diff --git a/drivers/media/rc/keymaps/rc-snapstream-firefly.c b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
index 5836aa2..ef14652 100644
--- a/drivers/media/rc/keymaps/rc-snapstream-firefly.c
+++ b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
@@ -18,6 +18,7 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/module.h>
 #include <media/rc-map.h>
 
 static struct rc_map_table snapstream_firefly[] = {
-- 
1.7.6.2

