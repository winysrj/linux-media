Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:28339
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbbCKREg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 13:04:36 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 7/15] media: pci: cx23885: don't export static symbol
Date: Wed, 11 Mar 2015 17:56:29 +0100
Message-Id: <1426092997-30605-8-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
type T;
identifier f;
@@

static T f (...) { ... }

@@
identifier r.f;
declarer name EXPORT_SYMBOL;
@@

-EXPORT_SYMBOL(f);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/cx23885/altera-ci.c |    3 ---
 1 file changed, 3 deletions(-)

diff -u -p a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -483,7 +483,6 @@ static void altera_hw_filt_release(void
 	}
 
 }
-EXPORT_SYMBOL(altera_hw_filt_release);
 
 void altera_ci_release(void *dev, int ci_nr)
 {
@@ -598,7 +597,6 @@ static int altera_pid_feed_control(void
 
 	return 0;
 }
-EXPORT_SYMBOL(altera_pid_feed_control);
 
 static int altera_ci_start_feed(struct dvb_demux_feed *feed, int num)
 {
@@ -699,7 +697,6 @@ err:
 
 	return ret;
 }
-EXPORT_SYMBOL(altera_hw_filt_init);
 
 int altera_ci_init(struct altera_ci_config *config, int ci_nr)
 {

