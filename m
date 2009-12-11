Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58460 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbZLKWfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 17:35:41 -0500
Message-ID: <4B22C93C.1050205@freemail.hu>
Date: Fri, 11 Dec 2009 23:35:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Olivier Grenie <Olivier.Grenie@dibcom.fr>,
	Patrick Boettcher <pboettcher@dibcom.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] dib8000: make some constant static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Eliminate the following sparse warnings (see "make C=1"):
 * dib8000.c:125:15: warning: symbol 'coeff_2k_sb_1seg_dqpsk' was not declared. Should it be static?
 * dib8000.c:130:15: warning: symbol 'coeff_2k_sb_1seg' was not declared. Should it be static?
 * dib8000.c:134:15: warning: symbol 'coeff_2k_sb_3seg_0dqpsk_1dqpsk' was not declared. Should it be static?
 * dib8000.c:139:15: warning: symbol 'coeff_2k_sb_3seg_0dqpsk' was not declared. Should it be static?
 * dib8000.c:144:15: warning: symbol 'coeff_2k_sb_3seg_1dqpsk' was not declared. Should it be static?
 * dib8000.c:149:15: warning: symbol 'coeff_2k_sb_3seg' was not declared. Should it be static?
 * dib8000.c:154:15: warning: symbol 'coeff_4k_sb_1seg_dqpsk' was not declared. Should it be static?
 * dib8000.c:159:15: warning: symbol 'coeff_4k_sb_1seg' was not declared. Should it be static?
 * dib8000.c:164:15: warning: symbol 'coeff_4k_sb_3seg_0dqpsk_1dqpsk' was not declared. Should it be static?
 * dib8000.c:169:15: warning: symbol 'coeff_4k_sb_3seg_0dqpsk' was not declared. Should it be static?
 * dib8000.c:174:15: warning: symbol 'coeff_4k_sb_3seg_1dqpsk' was not declared. Should it be static?
 * dib8000.c:179:15: warning: symbol 'coeff_4k_sb_3seg' was not declared. Should it be static?
 * dib8000.c:184:15: warning: symbol 'coeff_8k_sb_1seg_dqpsk' was not declared. Should it be static?
 * dib8000.c:189:15: warning: symbol 'coeff_8k_sb_1seg' was not declared. Should it be static?
 * dib8000.c:194:15: warning: symbol 'coeff_8k_sb_3seg_0dqpsk_1dqpsk' was not declared. Should it be static?
 * dib8000.c:199:15: warning: symbol 'coeff_8k_sb_3seg_0dqpsk' was not declared. Should it be static?
 * dib8000.c:204:15: warning: symbol 'coeff_8k_sb_3seg_1dqpsk' was not declared. Should it be static?
 * dib8000.c:209:15: warning: symbol 'coeff_8k_sb_3seg' was not declared. Should it be static?
 * dib8000.c:214:15: warning: symbol 'ana_fe_coeff_3seg' was not declared. Should it be static?
 * dib8000.c:218:15: warning: symbol 'ana_fe_coeff_1seg' was not declared. Should it be static?
 * dib8000.c:222:15: warning: symbol 'ana_fe_coeff_13seg' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r f5662ce08663 linux/drivers/media/dvb/frontends/dib8000.c
--- a/linux/drivers/media/dvb/frontends/dib8000.c	Fri Dec 11 09:53:41 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/dib8000.c	Fri Dec 11 23:33:26 2009 +0100
@@ -122,104 +122,104 @@
 	return dib8000_i2c_write16(&state->i2c, reg, val);
 }

-const int16_t coeff_2k_sb_1seg_dqpsk[8] = {
+static const int16_t coeff_2k_sb_1seg_dqpsk[8] = {
 	(769 << 5) | 0x0a, (745 << 5) | 0x03, (595 << 5) | 0x0d, (769 << 5) | 0x0a, (920 << 5) | 0x09, (784 << 5) | 0x02, (519 << 5) | 0x0c,
 	    (920 << 5) | 0x09
 };

-const int16_t coeff_2k_sb_1seg[8] = {
+static const int16_t coeff_2k_sb_1seg[8] = {
 	(692 << 5) | 0x0b, (683 << 5) | 0x01, (519 << 5) | 0x09, (692 << 5) | 0x0b, 0 | 0x1f, 0 | 0x1f, 0 | 0x1f, 0 | 0x1f
 };

-const int16_t coeff_2k_sb_3seg_0dqpsk_1dqpsk[8] = {
+static const int16_t coeff_2k_sb_3seg_0dqpsk_1dqpsk[8] = {
 	(832 << 5) | 0x10, (912 << 5) | 0x05, (900 << 5) | 0x12, (832 << 5) | 0x10, (-931 << 5) | 0x0f, (912 << 5) | 0x04, (807 << 5) | 0x11,
 	    (-931 << 5) | 0x0f
 };

-const int16_t coeff_2k_sb_3seg_0dqpsk[8] = {
+static const int16_t coeff_2k_sb_3seg_0dqpsk[8] = {
 	(622 << 5) | 0x0c, (941 << 5) | 0x04, (796 << 5) | 0x10, (622 << 5) | 0x0c, (982 << 5) | 0x0c, (519 << 5) | 0x02, (572 << 5) | 0x0e,
 	    (982 << 5) | 0x0c
 };

-const int16_t coeff_2k_sb_3seg_1dqpsk[8] = {
+static const int16_t coeff_2k_sb_3seg_1dqpsk[8] = {
 	(699 << 5) | 0x14, (607 << 5) | 0x04, (944 << 5) | 0x13, (699 << 5) | 0x14, (-720 << 5) | 0x0d, (640 << 5) | 0x03, (866 << 5) | 0x12,
 	    (-720 << 5) | 0x0d
 };

-const int16_t coeff_2k_sb_3seg[8] = {
+static const int16_t coeff_2k_sb_3seg[8] = {
 	(664 << 5) | 0x0c, (925 << 5) | 0x03, (937 << 5) | 0x10, (664 << 5) | 0x0c, (-610 << 5) | 0x0a, (697 << 5) | 0x01, (836 << 5) | 0x0e,
 	    (-610 << 5) | 0x0a
 };

-const int16_t coeff_4k_sb_1seg_dqpsk[8] = {
+static const int16_t coeff_4k_sb_1seg_dqpsk[8] = {
 	(-955 << 5) | 0x0e, (687 << 5) | 0x04, (818 << 5) | 0x10, (-955 << 5) | 0x0e, (-922 << 5) | 0x0d, (750 << 5) | 0x03, (665 << 5) | 0x0f,
 	    (-922 << 5) | 0x0d
 };

-const int16_t coeff_4k_sb_1seg[8] = {
+static const int16_t coeff_4k_sb_1seg[8] = {
 	(638 << 5) | 0x0d, (683 << 5) | 0x02, (638 << 5) | 0x0d, (638 << 5) | 0x0d, (-655 << 5) | 0x0a, (517 << 5) | 0x00, (698 << 5) | 0x0d,
 	    (-655 << 5) | 0x0a
 };

-const int16_t coeff_4k_sb_3seg_0dqpsk_1dqpsk[8] = {
+static const int16_t coeff_4k_sb_3seg_0dqpsk_1dqpsk[8] = {
 	(-707 << 5) | 0x14, (910 << 5) | 0x06, (889 << 5) | 0x16, (-707 << 5) | 0x14, (-958 << 5) | 0x13, (993 << 5) | 0x05, (523 << 5) | 0x14,
 	    (-958 << 5) | 0x13
 };

-const int16_t coeff_4k_sb_3seg_0dqpsk[8] = {
+static const int16_t coeff_4k_sb_3seg_0dqpsk[8] = {
 	(-723 << 5) | 0x13, (910 << 5) | 0x05, (777 << 5) | 0x14, (-723 << 5) | 0x13, (-568 << 5) | 0x0f, (547 << 5) | 0x03, (696 << 5) | 0x12,
 	    (-568 << 5) | 0x0f
 };

-const int16_t coeff_4k_sb_3seg_1dqpsk[8] = {
+static const int16_t coeff_4k_sb_3seg_1dqpsk[8] = {
 	(-940 << 5) | 0x15, (607 << 5) | 0x05, (915 << 5) | 0x16, (-940 << 5) | 0x15, (-848 << 5) | 0x13, (683 << 5) | 0x04, (543 << 5) | 0x14,
 	    (-848 << 5) | 0x13
 };

-const int16_t coeff_4k_sb_3seg[8] = {
+static const int16_t coeff_4k_sb_3seg[8] = {
 	(612 << 5) | 0x12, (910 << 5) | 0x04, (864 << 5) | 0x14, (612 << 5) | 0x12, (-869 << 5) | 0x13, (683 << 5) | 0x02, (869 << 5) | 0x12,
 	    (-869 << 5) | 0x13
 };

-const int16_t coeff_8k_sb_1seg_dqpsk[8] = {
+static const int16_t coeff_8k_sb_1seg_dqpsk[8] = {
 	(-835 << 5) | 0x12, (684 << 5) | 0x05, (735 << 5) | 0x14, (-835 << 5) | 0x12, (-598 << 5) | 0x10, (781 << 5) | 0x04, (739 << 5) | 0x13,
 	    (-598 << 5) | 0x10
 };

-const int16_t coeff_8k_sb_1seg[8] = {
+static const int16_t coeff_8k_sb_1seg[8] = {
 	(673 << 5) | 0x0f, (683 << 5) | 0x03, (808 << 5) | 0x12, (673 << 5) | 0x0f, (585 << 5) | 0x0f, (512 << 5) | 0x01, (780 << 5) | 0x0f,
 	    (585 << 5) | 0x0f
 };

-const int16_t coeff_8k_sb_3seg_0dqpsk_1dqpsk[8] = {
+static const int16_t coeff_8k_sb_3seg_0dqpsk_1dqpsk[8] = {
 	(863 << 5) | 0x17, (930 << 5) | 0x07, (878 << 5) | 0x19, (863 << 5) | 0x17, (0 << 5) | 0x14, (521 << 5) | 0x05, (980 << 5) | 0x18,
 	    (0 << 5) | 0x14
 };

-const int16_t coeff_8k_sb_3seg_0dqpsk[8] = {
+static const int16_t coeff_8k_sb_3seg_0dqpsk[8] = {
 	(-924 << 5) | 0x17, (910 << 5) | 0x06, (774 << 5) | 0x17, (-924 << 5) | 0x17, (-877 << 5) | 0x15, (565 << 5) | 0x04, (553 << 5) | 0x15,
 	    (-877 << 5) | 0x15
 };

-const int16_t coeff_8k_sb_3seg_1dqpsk[8] = {
+static const int16_t coeff_8k_sb_3seg_1dqpsk[8] = {
 	(-921 << 5) | 0x19, (607 << 5) | 0x06, (881 << 5) | 0x19, (-921 << 5) | 0x19, (-921 << 5) | 0x14, (713 << 5) | 0x05, (1018 << 5) | 0x18,
 	    (-921 << 5) | 0x14
 };

-const int16_t coeff_8k_sb_3seg[8] = {
+static const int16_t coeff_8k_sb_3seg[8] = {
 	(514 << 5) | 0x14, (910 << 5) | 0x05, (861 << 5) | 0x17, (514 << 5) | 0x14, (690 << 5) | 0x14, (683 << 5) | 0x03, (662 << 5) | 0x15,
 	    (690 << 5) | 0x14
 };

-const int16_t ana_fe_coeff_3seg[24] = {
+static const int16_t ana_fe_coeff_3seg[24] = {
 	81, 80, 78, 74, 68, 61, 54, 45, 37, 28, 19, 11, 4, 1022, 1017, 1013, 1010, 1008, 1008, 1008, 1008, 1010, 1014, 1017
 };

-const int16_t ana_fe_coeff_1seg[24] = {
+static const int16_t ana_fe_coeff_1seg[24] = {
 	249, 226, 164, 82, 5, 981, 970, 988, 1018, 20, 31, 26, 8, 1012, 1000, 1018, 1012, 8, 15, 14, 9, 3, 1017, 1003
 };

-const int16_t ana_fe_coeff_13seg[24] = {
+static const int16_t ana_fe_coeff_13seg[24] = {
 	396, 305, 105, -51, -77, -12, 41, 31, -11, -30, -11, 14, 15, -2, -13, -7, 5, 8, 1, -6, -7, -3, 0, 1
 };

