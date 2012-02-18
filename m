Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57990 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2BRLAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 06:00:02 -0500
Date: Sat, 18 Feb 2012 12:01:07 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: [PATCH] libv4lconvert: Add new rotated_90 webcam 06f8:301b
Message-ID: <20120218120107.3b7de330@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The webcam Hercules Link is handled by the driver gspca pac7302.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 lib/libv4lconvert/control/libv4lcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 1788811..d10c958 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -191,6 +191,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
 	{ 0x06f8, 0x3009, 0,    NULL, NULL,
 		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
+	{ 0x06f8, 0x301b, 0,    NULL, NULL,
+		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
 	{ 0x145f, 0x013c, 0,    NULL, NULL,
 		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
 	/* Pac7311 based devices */
-- 
1.7.9

