Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1ALQ2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 11:28:54 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0CGSrNT019327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 11:28:53 -0500
Received: from pedra (vpn-234-205.phx2.redhat.com [10.3.234.205])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0CGSqZP001348
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 11:28:52 -0500
Date: Wed, 12 Jan 2011 16:28:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] dib0700: Fix IR keycode handling
Message-ID: <20110112162845.7242aeb9@pedra>
In-Reply-To: <7a79a5e60b5f2d617be9431956b0475787458a62.1294856827.git.mchehab@redhat.com>
References: <7a79a5e60b5f2d617be9431956b0475787458a62.1294856827.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixes Fedora 14 bug: https://bugzilla.redhat.com/show_bug.cgi?id=667157

There are a few bugs at the code that generates the scancode at dib0700:
	- RC keycode is wrong (it outputs a 24 bits keycode);
	- NEC extended outputs a keycode that have endiannes issues;
	- keycode tables for NEC extended remotes need to be updated.

The last issue need to be done as we get reports, as we don't have
the complete NEC-extended keycodes at the dibcom table.

This patch fixes the first two issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 8ca48f7..98ffb40 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -514,8 +514,8 @@ struct dib0700_rc_response {
 	union {
 		u16 system16;
 		struct {
-			u8 system;
 			u8 not_system;
+			u8 system;
 		};
 	};
 	u8 data;
@@ -575,7 +575,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
 			deb_data("NEC extended protocol\n");
 			/* NEC extended code - 24 bits */
-			keycode = poll_reply->system16 << 8 | poll_reply->data;
+			keycode = be16_to_cpu(poll_reply->system16) << 8 | poll_reply->data;
 		} else {
 			deb_data("NEC normal protocol\n");
 			/* normal NEC code - 16 bits */
@@ -587,7 +587,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		deb_data("RC5 protocol\n");
 		/* RC5 Protocol */
 		toggle = poll_reply->report_id;
-		keycode = poll_reply->system16 << 8 | poll_reply->data;
+		keycode = poll_reply->system << 8 | poll_reply->data;
 
 		break;
 	}
-- 
1.7.1

