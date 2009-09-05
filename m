Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593AbZIEAVU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:20 -0400
Message-Id: <20090905001455.863242923@mini.kroah.org>
Date: Fri, 04 Sep 2009 17:14:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Jim Paris <jim@jtan.com>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [patch 55/71] gspca - ov534: Fix ov772x
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=gspca-ov534-fix-ov772x.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

The scan of the image packets of the sensor ov772x was broken when
the sensor ov965x was added.

[ Based on upstream c874f3aa, modified slightly for v2.6.30.5 ]

Signed-off-by: Jim Paris <jim@jtan.com>
Acked-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/ov534.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -832,9 +832,11 @@ static void sd_pkt_scan(struct gspca_dev
 	__u32 this_pts;
 	u16 this_fid;
 	int remaining_len = len;
+	int payload_len;
 
+	payload_len = (sd->sensor == SENSOR_OV772X) ? 2048 : 2040;
 	do {
-		len = min(remaining_len, 2040);		/*fixme: was 2048*/
+		len = min(remaining_len, payload_len);
 
 		/* Payloads are prefixed with a UVC-style header.  We
 		   consider a frame to start when the FID toggles, or the PTS


