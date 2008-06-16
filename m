Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bain@devslashzero.com>) id 1K83yc-0002YV-3K
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 03:57:46 +0200
Received: by hu-out-0506.google.com with SMTP id 23so6716729huc.11
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 18:57:37 -0700 (PDT)
Message-ID: <4855C884.9030202@devslashzero.com>
Date: Mon, 16 Jun 2008 07:27:24 +0530
From: Abhijit Bhopatkar <bain@devslashzero.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] DVB-USB UMT-010 driver oops on install
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Initialize stream count using MAX_NO_URBS_FOR_DATA_STREAM.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Abhijit Bhopatkar <bain@devslashzero.com>
---
 drivers/media/dvb/dvb-usb/umt-010.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/umt-010.c
b/drivers/media/dvb/dvb-usb/umt-010.c
index 9e7653b..118aab1 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -107,7 +107,7 @@ static struct dvb_usb_device_properties
umt_properties = {
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_BULK,
-				.count = 20,
+				.count = MAX_NO_URBS_FOR_DATA_STREAM,
 				.endpoint = 0x06,
 				.u = {
 					.bulk = {
-- 1.5.5.29.g7134

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
