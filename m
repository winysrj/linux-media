Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:37923 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbeLCLsk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 06:48:40 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [media] marvell-ccic: trivial fix to the datasheet URL
Date: Mon,  3 Dec 2018 12:47:42 +0100
Message-Id: <20181203114742.637165-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/=
media/platform/marvell-ccic/cafe-driver.c
index 2986cb4b88d0..8d00d9d8adff 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -4,7 +4,7 @@
  * sensor.
  *
  * The data sheet for this device can be found at:
- *    http://www.marvell.com/products/pc_connectivity/88alp01/
+ *    http://wiki.laptop.org/images/5/5c/88ALP01_Datasheet_July_2007.pdf
  *
  * Copyright 2006-11 One Laptop Per Child Association, Inc.
  * Copyright 2006-11 Jonathan Corbet <corbet@lwn.net>
--=20
2.19.1
