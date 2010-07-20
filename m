Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab0GTWXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 18:23:45 -0400
Message-Id: <201007202222.o6KMMiZi021244@imap1.linux-foundation.org>
Subject: [patch 2/2] drivers/video/omap2/displays: add missing mutex_unlock
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk, isely@pobox.com
From: akpm@linux-foundation.org
Date: Tue, 20 Jul 2010 15:22:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error paths.  The use of the mutex is
balanced elsewhere in the file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-By: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap2/displays/panel-acx565akm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/omap2/displays/panel-acx565akm.c~drivers-video-omap2-displays-add-missing-mutex_unlock drivers/video/omap2/displays/panel-acx565akm.c
--- a/drivers/video/omap2/displays/panel-acx565akm.c~drivers-video-omap2-displays-add-missing-mutex_unlock
+++ a/drivers/video/omap2/displays/panel-acx565akm.c
@@ -592,7 +592,7 @@ static int acx_panel_power_on(struct oma
 	r = omapdss_sdi_display_enable(dssdev);
 	if (r) {
 		pr_err("%s sdi enable failed\n", __func__);
-		return r;
+		goto fail_unlock;
 	}
 
 	/*FIXME tweak me */
@@ -633,6 +633,8 @@ static int acx_panel_power_on(struct oma
 	return acx565akm_bl_update_status(md->bl_dev);
 fail:
 	omapdss_sdi_display_disable(dssdev);
+fail_unlock:
+	mutex_unlock(&md->mutex);
 	return r;
 }
 
_
