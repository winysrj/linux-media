Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:62207 "HELO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754154AbZLMUTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 15:19:43 -0500
Message-ID: <4B254C59.5090507@freemail.hu>
Date: Sun, 13 Dec 2009 21:19:37 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@linuxtv.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] au8522: modify the attributes of local filter coefficients
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Make the local filter coefficients static and const. This will eliminate the
following sparse warnings (see "make C=1"):
 * au8522_decoder.c:71:31: warning: symbol 'filter_coef' was not declared. Should it be static?
 * au8522_decoder.c:113:31: warning: symbol 'lpfilter_coef' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e2f13778b5dc linux/drivers/media/dvb/frontends/au8522_decoder.c
--- a/linux/drivers/media/dvb/frontends/au8522_decoder.c	Sat Dec 12 17:25:43 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/au8522_decoder.c	Sun Dec 13 21:16:25 2009 +0100
@@ -68,7 +68,7 @@
    The values are as follows from left to right
    0="ATV RF" 1="ATV RF13" 2="CVBS" 3="S-Video" 4="PAL" 5=CVBS13" 6="SVideo13"
 */
-struct au8522_register_config filter_coef[] = {
+static const struct au8522_register_config filter_coef[] = {
 	{AU8522_FILTER_COEF_R410, {0x25, 0x00, 0x25, 0x25, 0x00, 0x00, 0x00} },
 	{AU8522_FILTER_COEF_R411, {0x20, 0x00, 0x20, 0x20, 0x00, 0x00, 0x00} },
 	{AU8522_FILTER_COEF_R412, {0x03, 0x00, 0x03, 0x03, 0x00, 0x00, 0x00} },
@@ -110,7 +110,7 @@
    0="SIF" 1="ATVRF/ATVRF13"
    Note: the "ATVRF/ATVRF13" mode has never been tested
 */
-struct au8522_register_config lpfilter_coef[] = {
+static const struct au8522_register_config lpfilter_coef[] = {
 	{0x060b, {0x21, 0x0b} },
 	{0x060c, {0xad, 0xad} },
 	{0x060d, {0x70, 0xf0} },
