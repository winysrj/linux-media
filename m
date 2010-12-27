Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:59047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab0L0Q0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:26:33 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGQXas027574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:26:33 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpF028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:26:30 -0500
Date: Mon, 27 Dec 2010 14:22:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/8] [media] gspca: Fix a warning for using len before
 filling it
Message-ID: <20101227142245.6db00c9a@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The check for status errors is now before the check for len. That's
ok. However, the error printk's for the status error prints the URB
length. This generates this error:

drivers/media/video/gspca/gspca.c: In function ‘fill_frame’:
drivers/media/video/gspca/gspca.c:305:9: warning: ‘len’ may be used uninitialized in this function

The fix is as simple as moving the len init to happen before the checks.

Cc: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 92b5dfb..80b31eb 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -318,6 +318,7 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 	}
 	pkt_scan = gspca_dev->sd_desc->pkt_scan;
 	for (i = 0; i < urb->number_of_packets; i++) {
+		len = urb->iso_frame_desc[i].actual_length;
 
 		/* check the packet status and length */
 		st = urb->iso_frame_desc[i].status;
@@ -327,7 +328,6 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
 		}
-		len = urb->iso_frame_desc[i].actual_length;
 		if (len == 0) {
 			if (gspca_dev->empty_packet == 0)
 				gspca_dev->empty_packet = 1;
-- 
1.7.3.4


