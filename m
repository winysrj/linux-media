Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47621 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932962AbeAOJ61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:27 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/5] =?UTF-8?q?auxdisplay:=20charlcd:=20add=20escape=20seq?= =?UTF-8?q?uence=20for=20brightness=20on=20NEC=20=C2=B5PD16314?=
Date: Mon, 15 Jan 2018 09:58:22 +0000
Message-Id: <259fa00659be126f371ecfa4d75a7830107c3eea.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The NEC µPD16314 can alter the the brightness of the LCD. Make it possible
to set this via escape sequence Y0 - Y3. B and R were already taken, so
I picked Y for luminance.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/auxdisplay/charlcd.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index a16c72779722..7a671ad959d1 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -39,6 +39,8 @@
 #define LCD_FLAG_F		0x0020	/* Large font mode */
 #define LCD_FLAG_N		0x0040	/* 2-rows mode */
 #define LCD_FLAG_L		0x0080	/* Backlight enabled */
+#define LCD_BRIGHTNESS_MASK	0x0300	/* Brightness */
+#define LCD_BRIGHTNESS_SHIFT	8
 
 /* LCD commands */
 #define LCD_CMD_DISPLAY_CLEAR	0x01	/* Clear entire display */
@@ -490,6 +492,17 @@ static inline int handle_lcd_special_code(struct charlcd *lcd)
 		charlcd_gotoxy(lcd);
 		processed = 1;
 		break;
+	case 'Y':	/* brightness (luma) */
+		switch (esc[1]) {
+		case '0':	/* 25% */
+		case '1':	/* 50% */
+		case '2':	/* 75% */
+		case '3':	/* 100% */
+			priv->flags = (priv->flags & ~(LCD_BRIGHTNESS_MASK)) |
+				(('3' - esc[1]) << LCD_BRIGHTNESS_SHIFT);
+			processed =  1;
+			break;
+		}
 	}
 
 	/* TODO: This indent party here got ugly, clean it! */
@@ -507,12 +520,15 @@ static inline int handle_lcd_special_code(struct charlcd *lcd)
 			((priv->flags & LCD_FLAG_C) ? LCD_CMD_CURSOR_ON : 0) |
 			((priv->flags & LCD_FLAG_B) ? LCD_CMD_BLINK_ON : 0));
 	/* check whether one of F,N flags was changed */
-	else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N))
+	else if ((oldflags ^ priv->flags) & (LCD_FLAG_F | LCD_FLAG_N |
+					     LCD_BRIGHTNESS_MASK))
 		lcd->ops->write_cmd(lcd,
 			LCD_CMD_FUNCTION_SET |
 			((lcd->ifwidth == 8) ? LCD_CMD_DATA_LEN_8BITS : 0) |
 			((priv->flags & LCD_FLAG_F) ? LCD_CMD_FONT_5X10_DOTS : 0) |
-			((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES : 0));
+			((priv->flags & LCD_FLAG_N) ? LCD_CMD_TWO_LINES : 0) |
+			((priv->flags & LCD_BRIGHTNESS_MASK) >>
+							LCD_BRIGHTNESS_SHIFT));
 	/* check whether L flag was changed */
 	else if ((oldflags ^ priv->flags) & LCD_FLAG_L)
 		charlcd_backlight(lcd, !!(priv->flags & LCD_FLAG_L));
-- 
2.14.3
