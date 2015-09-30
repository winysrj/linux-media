Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbI3AKf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 20:10:35 -0400
From: Laura Abbott <labbott@fedoraproject.org>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laura Abbott <labbott@fedoraproject.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stuart Auchterlonie <sauchter@redhat.com>, stable@kernel.org
Subject: [PATCH 1/2] si2168: Bounds check firmware
Date: Tue, 29 Sep 2015 17:10:09 -0700
Message-Id: <1443571810-5627-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


When reading the firmware and sending commands, the length must
be bounds checked to avoid overrunning the size of the command
buffer and smashing the stack if the firmware is not in the expected
format:

si2168 11-0064: found a 'Silicon Labs Si2168-B40'
si2168 11-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 11-0064: firmware download failed -95
Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffa085708f

Add the proper check.

Cc: stable@kernel.org
Reported-by: Stuart Auchterlonie <sauchter@redhat.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 drivers/media/dvb-frontends/si2168.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 81788c5..821a8f4 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -502,6 +502,10 @@ static int si2168_init(struct dvb_frontend *fe)
 		/* firmware is in the new format */
 		for (remaining = fw->size; remaining > 0; remaining -= 17) {
 			len = fw->data[fw->size - remaining];
+			if (len > SI2168_ARGLEN) {
+				ret = -EINVAL;
+				break;
+			}
 			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
-- 
2.4.3

