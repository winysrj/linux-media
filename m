Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4907 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3LQNTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:19:31 -0500
Message-ID: <52B04EE8.7040707@xs4all.nl>
Date: Tue, 17 Dec 2013 14:17:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 24/22] adv7842: set LLC DLL phase from platform_data
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl> <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The correct LLC DLL phase depends on the board layout, so this
should be part of the platform_data.

Verified-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 6 +-----
 include/media/adv7842.h     | 6 ++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 82c57d7..2eb4058 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1591,9 +1591,6 @@ static void select_input(struct v4l2_subdev *sd,
 		afe_write(sd, 0x00, 0x00); /* power up ADC */
 		afe_write(sd, 0xc8, 0x00); /* phase control */
 
-		io_write(sd, 0x19, 0x83); /* LLC DLL phase */
-		io_write(sd, 0x33, 0x40); /* LLC DLL enable */
-
 		io_write(sd, 0xdd, 0x90); /* Manual 2x output clock */
 		/* script says register 0xde, which don't exist in manual */
 
@@ -2603,8 +2600,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	io_write_and_or(sd, 0x20, 0xcf, 0x00);
 
 	/* LLC */
-	/* Set phase to 16. TODO: get this from platform_data */
-	io_write(sd, 0x19, 0x90);
+	io_write(sd, 0x19, 0x80 | pdata->llc_dll_phase);
 	io_write(sd, 0x33, 0x40);
 
 	/* interrupts */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 8b336ab..c67051a 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -192,6 +192,12 @@ struct adv7842_platform_data {
 		unsigned sync:2;
 	} drive_strength;
 
+	/*
+	 * IO register 0x19: Adjustment to the LLC DLL phase in
+	 * increments of 1/32 of a clock period.
+	 */
+	unsigned llc_dll_phase:5;
+
 	/* External RAM for 3-D comb or frame synchronizer */
 	unsigned sd_ram_size; /* ram size in MB */
 	unsigned sd_ram_ddr:1; /* ddr or sdr sdram */
-- 
1.8.4.rc3


