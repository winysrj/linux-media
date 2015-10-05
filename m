Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbJEWdd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 18:33:33 -0400
From: Laura Abbott <labbott@fedoraproject.org>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>
Cc: Laura Abbott <labbott@fedoraproject.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCHv2] si2157: Bounds check firmware
Date: Mon,  5 Oct 2015 15:33:29 -0700
Message-Id: <1444084409-20259-1-git-send-email-labbott@fedoraproject.org>
In-Reply-To: <5612F98D.4020000@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


When reading the firmware and sending commands, the length
must be bounds checked to avoid overrunning the size of the command
buffer and smashing the stack if the firmware is not in the
expected format. Add the proper check.

Cc: stable@kernel.org
Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
v2: Set the return code properly
---
 drivers/media/tuners/si2157.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 5073821..0e1ca2b 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -166,6 +166,11 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
 		len = fw->data[fw->size - remaining];
+		if (len > SI2157_ARGLEN) {
+			dev_err(&client->dev, "Bad firmware length\n");
+			ret = -EINVAL;
+			goto err_release_firmware;
+		}
 		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 		cmd.wlen = len;
 		cmd.rlen = 1;
-- 
2.4.3

