Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62647 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaAOCqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 21:46:07 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so520723bkz.10
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 18:46:06 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 10:46:06 +0800
Message-ID: <CAPgLHd_rrBkeHtRakwsu5NnGXiSwsubAzw5xZtB9UspTnmAh6w@mail.gmail.com>
Subject: [PATCH -next] [media] radio-usb-si4713: fix sparse non static symbol warnings
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hverkuil@xs4all.nl, m.chehab@samsung.com, Dinesh.Ram@cern.ch
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/media/radio/si4713/radio-usb-si4713.c:226:31: warning:
 symbol 'start_seq' was not declared. Should it be static?
drivers/media/radio/si4713/radio-usb-si4713.c:291:29: warning:
 symbol 'command_table' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/radio/si4713/radio-usb-si4713.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index f1e640d..779855b 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -223,7 +223,7 @@ struct si4713_start_seq_table {
  * (0x03): Get serial number of the board (Response : CB000-00-00)
  * (0x06, 0x03, 0x03, 0x08, 0x01, 0x0f) : Get Component revision
  */
-struct si4713_start_seq_table start_seq[] = {
+static struct si4713_start_seq_table start_seq[] = {
 
 	{ 1, { 0x03 } },
 	{ 2, { 0x32, 0x7f } },
@@ -288,7 +288,7 @@ struct si4713_command_table {
  *	Byte 4 : Number of arguments + 1 (for the command byte)
  *	Byte 5 : Number of response bytes
  */
-struct si4713_command_table command_table[] = {
+static struct si4713_command_table command_table[] = {
 
 	{ SI4713_CMD_POWER_UP,		{ 0x00, SI4713_PWUP_NARGS + 1, SI4713_PWUP_NRESP} },
 	{ SI4713_CMD_GET_REV,		{ 0x03, 0x01, SI4713_GETREV_NRESP } },

