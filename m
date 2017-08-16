Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34543 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdHPFaZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 01:30:25 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] radio: constify pnp_device_id
Date: Wed, 16 Aug 2017 11:00:10 +0530
Message-Id: <14915fbdafae1820527dc9f0030af3f7e0fbec64.1502860820.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pnp_device_id are not supposed to change at runtime. All functions
working with pnp_device_id provided by <linux/pnp.h> work with
const pnp_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/radio/radio-cadet.c    | 2 +-
 drivers/media/radio/radio-gemtek.c   | 2 +-
 drivers/media/radio/radio-sf16fmr2.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index cbaf850..6888b7d 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -528,7 +528,7 @@ static const struct v4l2_ctrl_ops cadet_ctrl_ops = {
 
 #ifdef CONFIG_PNP
 
-static struct pnp_device_id cadet_pnp_devices[] = {
+static const struct pnp_device_id cadet_pnp_devices[] = {
 	/* ADS Cadet AM/FM Radio Card */
 	{.id = "MSM0c24", .driver_data = 0},
 	{.id = ""}
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index ca051ccb..ddc12b1 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -281,7 +281,7 @@ static const struct radio_isa_ops gemtek_ops = {
 static const int gemtek_ioports[] = { 0x20c, 0x30c, 0x24c, 0x34c, 0x248, 0x28c };
 
 #ifdef CONFIG_PNP
-static struct pnp_device_id gemtek_pnp_devices[] = {
+static const struct pnp_device_id gemtek_pnp_devices[] = {
 	/* AOpen FX-3D/Pro Radio */
 	{.id = "ADS7183", .driver_data = 0},
 	{.id = ""}
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index dc81d42..de79d55 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -197,7 +197,7 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
 	return 0;
 }
 
-static struct pnp_device_id fmr2_pnp_ids[] = {
+static const struct pnp_device_id fmr2_pnp_ids[] = {
 	{ .id = "MFRad13" }, /* tuner subdevice of SF16-FMD2 */
 	{ .id = "" }
 };
-- 
2.7.4
