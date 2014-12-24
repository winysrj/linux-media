Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:34939 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXLo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 06:44:57 -0500
Received: by mail-yh0-f50.google.com with SMTP id 29so4287931yhl.9
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 03:44:57 -0800 (PST)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH] solo6x10: s/uint8_t/u8/
Date: Wed, 24 Dec 2014 08:43:36 -0300
Message-Id: <1419421416-8133-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-tw28.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-tw28.c b/drivers/media/pci/solo6x10/solo6x10-tw28.c
index edd0781..0632d3f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-tw28.c
+++ b/drivers/media/pci/solo6x10/solo6x10-tw28.c
@@ -510,7 +510,7 @@ static int tw2815_setup(struct solo_dev *solo_dev, u8 dev_addr)
 #define FIRST_ACTIVE_LINE	0x0008
 #define LAST_ACTIVE_LINE	0x0102
 
-static void saa712x_write_regs(struct solo_dev *dev, const uint8_t *vals,
+static void saa712x_write_regs(struct solo_dev *dev, const u8 *vals,
 		int start, int n)
 {
 	for (; start < n; start++, vals++) {
@@ -532,7 +532,7 @@ static void saa712x_write_regs(struct solo_dev *dev, const uint8_t *vals,
 static void saa712x_setup(struct solo_dev *dev)
 {
 	const int reg_start = 0x26;
-	const uint8_t saa7128_regs_ntsc[] = {
+	const u8 saa7128_regs_ntsc[] = {
 	/* :0x26 */
 		0x0d, 0x00,
 	/* :0x28 */
-- 
2.2.0

