Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50969 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756152AbcJVWwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 18:52:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/5] spca506: rewrite a commented line to avoid wrong parsing
Date: Sat, 22 Oct 2016 20:52:00 -0200
Message-Id: <a08b9879d92879520c28be9d3bd563e974356678.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keeping Documentation/media/v4l-drivers/gspca-cardlist.rst in
sync with the gspca script requires a parser. Simplify the
commented line, to make the parser work better.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/spca506.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/spca506.c b/drivers/media/usb/gspca/spca506.c
index bcd2c04c770e..ee84863d27d4 100644
--- a/drivers/media/usb/gspca/spca506.c
+++ b/drivers/media/usb/gspca/spca506.c
@@ -581,8 +581,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x06e1, 0xa190)},
-/*fixme: may be IntelPCCameraPro BRIDGE_SPCA505
-	{USB_DEVICE(0x0733, 0x0430)}, */
+/*	{USB_DEVICE(0x0733, 0x0430)}, FIXME: may be IntelPCCameraPro BRIDGE_SPCA505 */
 	{USB_DEVICE(0x0734, 0x043b)},
 	{USB_DEVICE(0x99fa, 0x8988)},
 	{}
-- 
2.7.4


