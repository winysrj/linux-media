Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:47648 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1COIx2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:28 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
	Florian Mickler <florian@mickler.org>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/16] [media] lmedm04: correct indentation
Date: Tue, 15 Mar 2011 09:43:43 +0100
Message-Id: <1300178655-24832-11-git-send-email-florian@mickler.org>
In-Reply-To: <1300178655-24832-1-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
 <1300178655-24832-1-git-send-email-florian@mickler.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This should not change anything except whitespace.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 9eea418..0a3e88f 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -626,15 +626,15 @@ static int lme2510_download_firmware(struct usb_device *dev,
 				data[0] = i | 0x80;
 				dlen = (u8)(end - j)-1;
 			}
-		data[1] = dlen;
-		memcpy(&data[2], fw_data, dlen+1);
-		wlen = (u8) dlen + 4;
-		data[wlen-1] = check_sum(fw_data, dlen+1);
-		deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
+			data[1] = dlen;
+			memcpy(&data[2], fw_data, dlen+1);
+			wlen = (u8) dlen + 4;
+			data[wlen-1] = check_sum(fw_data, dlen+1);
+			deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
 				data[dlen+2], data[dlen+3]);
-		ret |= lme2510_bulk_write(dev, data,  wlen, 1);
-		ret |= lme2510_bulk_read(dev, data, len_in , 1);
-		ret |= (data[0] == 0x88) ? 0 : -1;
+			ret |= lme2510_bulk_write(dev, data,  wlen, 1);
+			ret |= lme2510_bulk_read(dev, data, len_in , 1);
+			ret |= (data[0] == 0x88) ? 0 : -1;
 		}
 	}
 
-- 
1.7.4.rc3

