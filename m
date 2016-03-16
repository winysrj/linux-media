Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35043 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbcCPTQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 15:16:50 -0400
Received: by mail-lf0-f44.google.com with SMTP id l202so26683593lfl.2
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 12:16:49 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] pctv452e: correct parameters for TechnoTrend TT S2-3600
Date: Wed, 16 Mar 2016 21:16:41 +0200
Message-Id: <1458155801-14534-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2008-02-25 Andre Weidemann added support for TT S2-3600 and noted
that he still gets image distortions every now and then.

It seems to be common knowledge in many projects that changing
the USB parameters seems to help. OpenELEC has included this patch
for a few years, for example. Nobody bothered to report the issue
upstream though, it seems.

References:
https://github.com/OpenELEC/OpenELEC.tv/issues/1957
http://www.vdr-portal.de/board60-linux/board14-betriebssystem/board96-yavdr/p1033458-darstellungsproblem-bei-2-tt-3600-usb/#post1033458 (in German)

I'd suggest we include the patch below. Any objections?

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index ec397c4..c05de1b 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -995,11 +995,11 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_ISOC,
-				.count = 7,
+				.count = 4,
 				.endpoint = 0x02,
 				.u = {
 					.isoc = {
-						.framesperurb = 4,
+						.framesperurb = 64,
 						.framesize = 940,
 						.interval = 1
 					}
-- 
1.9.1

