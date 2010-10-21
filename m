Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47854 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0JUTYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 15:24:38 -0400
Date: Thu, 21 Oct 2010 21:24:24 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/3] V4L/DVB: s5p-fimc: dubious one-bit signed bitfields
Message-ID: <20101021192424.GL5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

These are signed so instead of being 1 and 0 as intended they are -1 and
0.  It doesn't cause a bug in the current code but Sparse warns about it:

drivers/media/video/s5p-fimc/fimc-core.h:226:28:
	error: dubious one-bit signed bitfield

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index e3a7c6a..7665a3f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -222,10 +223,10 @@ struct fimc_effect {
  * @real_height:	source pixel (height - offset)
  */
 struct fimc_scaler {
-	int	scaleup_h:1;
-	int	scaleup_v:1;
-	int	copy_mode:1;
-	int	enabled:1;
+	unsigned int	scaleup_h:1;
+	unsigned int	caleup_v:1;
+	unsigned int	copy_mode:1;
+	unsigned int	enabled:1;
 	u32	hfactor;
 	u32	vfactor;
 	u32	pre_hratio;
