Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbbI3AKg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 20:10:36 -0400
From: Laura Abbott <labbott@fedoraproject.org>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laura Abbott <labbott@fedoraproject.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH 2/2] si2157: Bounds check firmware
Date: Tue, 29 Sep 2015 17:10:10 -0700
Message-Id: <1443571810-5627-2-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <1443571810-5627-1-git-send-email-labbott@fedoraproject.org>
References: <1443571810-5627-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When reading the firmware and sending commands, the length
must be bounds checked to avoid overrunning the size of the command
buffer and smashing the stack if the firmware is not in the
expected format. Add the proper check.

Cc: stable@kernel.org
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 drivers/media/tuners/si2157.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 5073821..ce157ed 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -166,6 +166,10 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
 		len = fw->data[fw->size - remaining];
+		if (len > SI2157_ARGLEN) {
+			dev_err(&client->dev, "Bad firmware length\n");
+			goto err_release_firmware;
+		}
 		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 		cmd.wlen = len;
 		cmd.rlen = 1;
-- 
2.4.3

