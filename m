Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34610 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbaKEIR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:17:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/8] bttv: fix sparse warning
Date: Wed,  5 Nov 2014 09:17:45 +0100
Message-Id: <1415175472-24203-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

bttv-cards.c:3874:55: warning: incorrect type in initializer (different base types)

Also clean up the code a little by adding spaces.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index d8ec583..4105560 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3870,10 +3870,10 @@ static void osprey_eeprom(struct bttv *btv, const u8 ee[256])
 	} else {
 		unsigned short type;
 
-		for (i = 4*16; i < 8*16; i += 16) {
-			u16 checksum = ip_compute_csum(ee + i, 16);
+		for (i = 4 * 16; i < 8 * 16; i += 16) {
+			u16 checksum = (__force u16)ip_compute_csum(ee + i, 16);
 
-			if ((checksum&0xff) + (checksum>>8) == 0xff)
+			if ((checksum & 0xff) + (checksum >> 8) == 0xff)
 				break;
 		}
 		if (i >= 8*16)
-- 
2.1.1

