Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:38715 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3DQPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 04/10] video: display: Add generic TFT display type
Date: Wed, 17 Apr 2013 16:17:16 +0100
Message-Id: <1366211842-21497-5-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TFT panels may be interfaced via a simple parallel interface
carrying RGB data, pixel clock and synchronisation signals.
>From the video generator point of view the width of the data
channels (number of bits per R/G/B components) may be an
important factor in setting up the display model.

Above information is based on the presentations by Dave Anders
available here: http://elinux.org/Elc-lcd

This patch adds the parallel TFT display type and basic parameters
structure. Maybe it should be split into a separate header, eg.
include/video/tft.h? Or maybe it's just the INTERFACE_DPI I'm
talking about?

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/video/display.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/video/display.h b/include/video/display.h
index 7fe8b2f..875e230 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -69,10 +69,19 @@ enum display_entity_stream_state {
=20
 enum display_entity_interface_type {
 =09DISPLAY_ENTITY_INTERFACE_DPI,
+=09DISPLAY_ENTITY_INTERFACE_TFT_PARALLEL,
+};
+
+struct tft_parallel_interface_params {
+=09int r_bits, g_bits, b_bits;
+=09int r_b_swapped;
 };
=20
 struct display_entity_interface_params {
 =09enum display_entity_interface_type type;
+=09union {
+=09=09struct tft_parallel_interface_params tft_parallel;
+=09} p;
 };
=20
 struct display_entity_control_ops {
--=20
1.7.10.4


