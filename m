Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44597 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730539AbeGQWHm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:07:42 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: rc: nec keymaps should specify the nec variant they use
Date: Tue, 17 Jul 2018 22:33:05 +0100
Message-Id: <20180717213306.22799-2-sean@mess.org>
In-Reply-To: <20180717213306.22799-1-sean@mess.org>
References: <20180717213306.22799-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rc_proto field should list the exact variant used by the remote. This
does not change the decoder used, but helps with using keymaps for
transmit purposes.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/rc-behold.c              | 2 +-
 drivers/media/rc/keymaps/rc-delock-61959.c        | 2 +-
 drivers/media/rc/keymaps/rc-imon-rsc.c            | 2 +-
 drivers/media/rc/keymaps/rc-it913x-v1.c           | 2 +-
 drivers/media/rc/keymaps/rc-it913x-v2.c           | 2 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c     | 2 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c      | 2 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c      | 2 +-
 drivers/media/rc/keymaps/rc-reddo.c               | 2 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c       | 2 +-
 drivers/media/rc/keymaps/rc-tivo.c                | 2 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 9b1b57e3c875..e1b2c8e26883 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -115,7 +115,7 @@ static struct rc_map_list behold_map = {
 	.map = {
 		.scan     = behold,
 		.size     = ARRAY_SIZE(behold),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_BEHOLD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-delock-61959.c b/drivers/media/rc/keymaps/rc-delock-61959.c
index 62de69d78d92..da21d6d6d79f 100644
--- a/drivers/media/rc/keymaps/rc-delock-61959.c
+++ b/drivers/media/rc/keymaps/rc-delock-61959.c
@@ -60,7 +60,7 @@ static struct rc_map_list delock_61959_map = {
 	.map = {
 		.scan     = delock_61959,
 		.size     = ARRAY_SIZE(delock_61959),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_DELOCK_61959,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-imon-rsc.c b/drivers/media/rc/keymaps/rc-imon-rsc.c
index 83e4564aaa22..6f7ee4859682 100644
--- a/drivers/media/rc/keymaps/rc-imon-rsc.c
+++ b/drivers/media/rc/keymaps/rc-imon-rsc.c
@@ -59,7 +59,7 @@ static struct rc_map_list imon_rsc_map = {
 	.map = {
 		.scan     = imon_rsc,
 		.size     = ARRAY_SIZE(imon_rsc),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_IMON_RSC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-it913x-v1.c b/drivers/media/rc/keymaps/rc-it913x-v1.c
index 908d14848ae8..f1b5c52953ad 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v1.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v1.c
@@ -73,7 +73,7 @@ static struct rc_map_list it913x_v1_map = {
 	.map = {
 		.scan     = it913x_v1_rc,
 		.size     = ARRAY_SIZE(it913x_v1_rc),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_IT913X_V1,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-it913x-v2.c b/drivers/media/rc/keymaps/rc-it913x-v2.c
index 05ab7fa4f90b..be5dfb4fae46 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v2.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v2.c
@@ -72,7 +72,7 @@ static struct rc_map_list it913x_v2_map = {
 	.map = {
 		.scan     = it913x_v2_rc,
 		.size     = ARRAY_SIZE(it913x_v2_rc),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_IT913X_V2,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index 8fec0c1dcb12..d50e741c73b7 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -64,7 +64,7 @@ static struct rc_map_list msi_digivox_iii_map = {
 	.map = {
 		.scan     = msi_digivox_iii,
 		.size     = ARRAY_SIZE(msi_digivox_iii),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_MSI_DIGIVOX_III,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index 4ed85f61d0ee..c0550e09f255 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -51,7 +51,7 @@ static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan     = pixelview_002t,
 		.size     = ARRAY_SIZE(pixelview_002t),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_PIXELVIEW_002T,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 6ded64b732a5..864c8ea5d8e3 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -57,7 +57,7 @@ static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan     = pixelview_mk12,
 		.size     = ARRAY_SIZE(pixelview_mk12),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_PIXELVIEW_MK12,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-reddo.c b/drivers/media/rc/keymaps/rc-reddo.c
index 3b37acc7b144..b73223e8c238 100644
--- a/drivers/media/rc/keymaps/rc-reddo.c
+++ b/drivers/media/rc/keymaps/rc-reddo.c
@@ -64,7 +64,7 @@ static struct rc_map_list reddo_map = {
 	.map = {
 		.scan     = reddo,
 		.size     = ARRAY_SIZE(reddo),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_REDDO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 628272c58d65..58a209811d12 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -58,7 +58,7 @@ static struct rc_map_list terratec_slim_map = {
 	.map = {
 		.scan     = terratec_slim,
 		.size     = ARRAY_SIZE(terratec_slim),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_TERRATEC_SLIM,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 1962e33c8f4e..20268f8b18fd 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -77,7 +77,7 @@ static struct rc_map_list tivo_map = {
 	.map = {
 		.scan     = tivo,
 		.size     = ARRAY_SIZE(tivo),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NEC32,
 		.name     = RC_MAP_TIVO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index bc73bee309d8..c34e8f5a88b6 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -64,7 +64,7 @@ static struct rc_map_list total_media_in_hand_map = {
 	.map = {
 		.scan     = total_media_in_hand,
 		.size     = ARRAY_SIZE(total_media_in_hand),
-		.rc_proto = RC_PROTO_NEC,
+		.rc_proto = RC_PROTO_NECX,
 		.name     = RC_MAP_TOTAL_MEDIA_IN_HAND,
 	}
 };
-- 
2.17.1
