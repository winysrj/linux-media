Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38366 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754294Ab0CWO6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:58:13 -0400
Date: Tue, 23 Mar 2010 15:58:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 2/2] sh_mobile_ceu_camera.c: update documentation to reflect
 the new cropping
In-Reply-To: <Pine.LNX.4.64.1003231529490.5340@axis700.grange>
Message-ID: <Pine.LNX.4.64.1003231556560.7689@axis700.grange>
References: <Pine.LNX.4.64.1003231529490.5340@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
This patch and the one, actually implementing this change, do not depend  
on each other, but are logically related, so, this one can be considered  
a follow-up.

 Documentation/video4linux/sh_mobile_ceu_camera.txt |   80 ++++++++------------
 1 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/Documentation/video4linux/sh_mobile_ceu_camera.txt b/Documentation/video4linux/sh_mobile_ceu_camera.txt
index 2ae1634..cb47e72 100644
--- a/Documentation/video4linux/sh_mobile_ceu_camera.txt
+++ b/Documentation/video4linux/sh_mobile_ceu_camera.txt
@@ -17,18 +17,18 @@ Generic scaling / cropping scheme
 -2-- -\
 |      --\
 |         --\
-+-5-- -\     -- -3--
-|       ---\
-|           --- -4-- -\
-|                      -\
-|                        - -6--
++-5-- .      -- -3-- -\
+|      `...            -\
+|          `... -4-- .   - -7..
+|                     `.
+|                       `. .6--
 |
-|                        - -6'-
-|                      -/
-|           --- -4'- -/
-|       ---/
-+-5'- -/
-|            -- -3'-
+|                        . .6'-
+|                      .´
+|           ... -4'- .´
+|       ...´             - -7'.
++-5'- .´               -/
+|            -- -3'- -/
 |         --/
 |      --/
 -2'- -/
@@ -36,7 +36,11 @@ Generic scaling / cropping scheme
 |
 -1'-
 
-Produced by user requests:
+In the above chart minuses and slashes represent "real" data amounts, points and
+accents represent "useful" data, basically, CEU scaled amd cropped output,
+mapped back onto the client's source plane.
+
+Such a configuration can be produced by user requests:
 
 S_CROP(left / top = (5) - (1), width / height = (5') - (5))
 S_FMT(width / height = (6') - (6))
@@ -106,52 +110,30 @@ window:
 S_CROP
 ------
 
-If old scale applied to new crop is invalid produce nearest new scale possible
-
-1. Calculate current combined scales.
-
-	scale_comb = (((4') - (4)) / ((6') - (6))) * (((2') - (2)) / ((3') - (3)))
-
-2. Apply iterative sensor S_CROP for new input window.
-
-3. If old combined scales applied to new crop produce an impossible user window,
-adjust scales to produce nearest possible window.
-
-	width_u_out = ((5') - (5)) / scale_comb
+The API at http://v4l2spec.bytesex.org/spec/x1904.htm says:
 
-	if (width_u_out > max)
-		scale_comb = ((5') - (5)) / max;
-	else if (width_u_out < min)
-		scale_comb = ((5') - (5)) / min;
+"...specification does not define an origin or units. However by convention
+drivers should horizontally count unscaled samples relative to 0H."
 
-4. Issue G_CROP to retrieve actual input window.
+We choose to follow the advise and interpret cropping units as client input
+pixels.
 
-5. Using actual input window and calculated combined scales calculate sensor
-target output window.
-
-	width_s_out = ((3') - (3)) = ((2') - (2)) / scale_comb
-
-6. Apply iterative S_FMT for new sensor target output window.
-
-7. Issue G_FMT to retrieve the actual sensor output window.
-
-8. Calculate sensor scales.
-
-	scale_s = ((3') - (3)) / ((2') - (2))
+Cropping is performed in the following 6 steps:
 
-9. Calculate sensor output subwindow to be cropped on CEU by applying sensor
-scales to the requested window.
+1. Request exactly user rectangle from the sensor.
 
-	width_ceu = ((5') - (5)) / scale_s
+2. If smaller - iterate until a larger one is obtained. Result: sensor cropped
+   to 2 : 2', target crop 5 : 5', current output format 6' - 6.
 
-10. Use CEU cropping for above calculated window.
+3. In the previous step the sensor has tried to preserve its output frame as
+   good as possible, but it could have changed. Retrieve it again.
 
-11. Calculate CEU scales from sensor scales from results of (10) and user window
-from (3)
+4. Sensor scaled to 3 : 3'. Sensor's scale is (2' - 2) / (3' - 3). Calculate
+   intermediate window: 4' - 4 = (5' - 5) * (3' - 3) / (2' - 2)
 
-	scale_ceu = calc_scale(((5') - (5)), &width_u_out)
+5. Calculate and apply host scale = (6' - 6) / (4' - 4)
 
-12. Apply CEU scales.
+6. Calculate and apply host crop: 6 - 7 = (5 - 2) * (6' - 6) / (5' - 5)
 
 --
 Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
1.6.2.4

