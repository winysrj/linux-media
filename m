Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:49833 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbcGRVSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 17:18:45 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH v8 01/10] Input: atmel_mxt_ts - update MAINTAINERS email address
Date: Mon, 18 Jul 2016 22:10:29 +0100
Message-Id: <1468876238-24599-2-git-send-email-nick@shmanahar.org>
In-Reply-To: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm leaving ITDev, so change to my personal email. My understanding is
that someone at Atmel will take this on once their takeover by Microchip
has settled down.

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a15d945..9be2570 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2188,9 +2188,9 @@ S:	Maintained
 F:	drivers/net/wireless/atmel/atmel*
 
 ATMEL MAXTOUCH DRIVER
-M:	Nick Dyer <nick.dyer@itdev.co.uk>
-T:	git git://github.com/atmel-maxtouch/linux.git
-S:	Supported
+M:	Nick Dyer <nick@shmanahar.org>
+T:	git git://github.com/ndyer/linux.git
+S:	Maintained
 F:	Documentation/devicetree/bindings/input/atmel,maxtouch.txt
 F:	drivers/input/touchscreen/atmel_mxt_ts.c
 F:	include/linux/platform_data/atmel_mxt_ts.h
-- 
1.7.9.5

