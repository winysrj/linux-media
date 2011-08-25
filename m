Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1942 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1HYOIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/12] af9005-fe: fix compiler warning
Date: Thu, 25 Aug 2011 16:08:30 +0200
Message-Id: <5b9ba0c87620f66dd68ce821ad411c828ea9ff1a.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/dvb/dvb-usb/af9005-fe.c: In function 'af9005_write_word_agc':
v4l-dvb-git/drivers/media/dvb/dvb-usb/af9005-fe.c:66:5: warning: variable 'temp' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/dvb-usb/af9005-fe.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index 6ad9474..3263e97 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -63,11 +63,9 @@ static int af9005_write_word_agc(struct dvb_usb_device *d, u16 reghi,
 				 u16 reglo, u8 pos, u8 len, u16 value)
 {
 	int ret;
-	u8 temp;
 
 	if ((ret = af9005_write_ofdm_register(d, reglo, (u8) (value & 0xff))))
 		return ret;
-	temp = (u8) ((value & 0x0300) >> 8);
 	return af9005_write_register_bits(d, reghi, pos, len,
 					  (u8) ((value & 0x300) >> 8));
 }
-- 
1.7.5.4

