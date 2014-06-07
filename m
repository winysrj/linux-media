Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58598 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaFGAag (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 20:30:36 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so1890320lbv.7
        for <linux-media@vger.kernel.org>; Fri, 06 Jun 2014 17:30:34 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Martin Bugge <marbugge@cisco.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l2-core: v4l2-dv-timings.c:  Cleaning up code that putting values to the same variable twice
Date: Sat,  7 Jun 2014 02:31:28 +0200
Message-Id: <1402101088-14731-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of putting the same variable twice,
was rather intended to set this value to two different variable.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 48b20df..eb3850c 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -599,10 +599,10 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 		aspect.denominator = 9;
 	} else if (ratio == 34) {
 		aspect.numerator = 4;
-		aspect.numerator = 3;
+		aspect.denominator = 3;
 	} else if (ratio == 68) {
 		aspect.numerator = 15;
-		aspect.numerator = 9;
+		aspect.denominator = 9;
 	} else {
 		aspect.numerator = hor_landscape + 99;
 		aspect.denominator = 100;
-- 
1.7.10.4

