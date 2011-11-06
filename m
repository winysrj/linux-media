Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1KFUcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:33 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:32 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 12/13] staging: as102: Define device name string pointers constant
Date: Sun,  6 Nov 2011 21:31:49 +0100
Message-Id: <1320611510-3326-13-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Supresses following checkpatch warning:

WARNING: static const char * array should probably be
static const char * const

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_usb_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 3ded7d6..97bceeb 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -47,7 +47,7 @@ static struct usb_device_id as102_usb_id_table[] = {
 
 /* Note that this table must always have the same number of entries as the
    as102_usb_id_table struct */
-static const char *as102_device_names[] = {
+static const char * const as102_device_names[] = {
 	AS102_REFERENCE_DESIGN,
 	AS102_PCTV_74E,
 	AS102_ELGATO_EYETV_DTT_NAME,
-- 
1.7.5.4

