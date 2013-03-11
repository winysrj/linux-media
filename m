Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1818 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3CKLqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/42] tw2804: modify ADC power control
Date: Mon, 11 Mar 2013 12:45:52 +0100
Message-Id: <cafe1256e6461173d9e6788e48c980660c026521.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Volokh Konstantin <volokh84@gmail.com>

Switch off all ADC (max 4) with first init, we control it
when starting/stopping streaming.

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tw2804.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index 4bb5ba6..441b766 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -53,6 +53,7 @@ static const u8 global_registers[] = {
 	0x3d, 0x80,
 	0x3e, 0x82,
 	0x3f, 0x82,
+	0x78, 0x0f,
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
-- 
1.7.10.4

