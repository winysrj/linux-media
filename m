Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:52518 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0BFIoA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Feb 2010 03:44:00 -0500
Date: Sat, 6 Feb 2010 09:43:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 7/11] drivers/media: Correct NULL test
Message-ID: <Pine.LNX.4.64.1002060943420.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

In each case, the NULL test has been performed already.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/frontends/stv0900_core.c |    5 -----
 drivers/media/video/cpia.c                 |    3 ---
 2 files changed, 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 74791d5..9052a9b 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1410,11 +1410,6 @@ static enum fe_stv0900_error stv0900_init_internal(struct dvb_frontend *fe,
 		return error;
 	}
 
-	if (state->internal == NULL) {
-		error = STV0900_INVALID_HANDLE;
-		return error;
-	}
-
 	intp = state->internal;
 
 	intp->demod_mode = p_init->demod_mode;
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index 551ddf2..933ae4c 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -3737,9 +3737,6 @@ static int cpia_mmap(struct file *file, struct vm_area_struct *vma)
 	if (size > FRAME_NUM*CPIA_MAX_FRAME_SIZE)
 		return -EINVAL;
 
-	if (!cam || !cam->ops)
-		return -ENODEV;
-
 	/* make this _really_ smp-safe */
 	if (mutex_lock_interruptible(&cam->busy_lock))
 		return -EINTR;
