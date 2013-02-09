Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1395 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3BIKBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 22/26] cx231xx: disable 417 support from the Conexant video grabber
Date: Sat,  9 Feb 2013 11:00:52 +0100
Message-Id: <c4275fe7f490f1aa9a35e8fab2bad70508130ad1.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The 417 support doesn't work. Until someone can dig into this driver to
figure out why it isn't working the 417 support is disabled.

Sometimes you can actually stream a bit, but very soon the whole machine
crashes, so something is seriously wrong.

For the record, this was not introduced by my recent changes to this driver,
it was broken before that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index d6acb1e..7094451 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -263,7 +263,10 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_PAL,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.has_417 = 1,
+		/* Actually, it has a 417, but it isn't working correctly.
+		 * So set to 0 for now until someone can manage to get this
+		 * to work reliably. */
+		.has_417 = 0,
 
 		.input = {{
 				.type = CX231XX_VMUX_COMPOSITE1,
-- 
1.7.10.4

