Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51309 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaFNLgN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 07:36:13 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so3690641wgh.18
        for <linux-media@vger.kernel.org>; Sat, 14 Jun 2014 04:36:12 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Martin Bugge <marbugge@cisco.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: v4l2-core: v4l2-dv-timings.c:  Cleaning up code wrong value used in aspect ratio.
Date: Sat, 14 Jun 2014 13:37:09 +0200
Message-Id: <1402745829-12895-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1402745829-12895-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402745829-12895-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wrong value used in same cases for the aspect ratio.

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

