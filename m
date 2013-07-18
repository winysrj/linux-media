Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55567 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3GRAaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 20:30:07 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so5724804iea.3
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 17:30:06 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Jul 2013 18:30:06 -0600
Message-ID: <CAA9z4LbZQ6k9cA5WziczvbSAqOjDnTt12hf+JKLKf3B2u2cERA@mail.gmail.com>
Subject: [PATCH] au8522_dig: fix snr lookup table
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes an if() statement that was preventing the last
element in the table from ever being utilized, preventing the snr from
ever displaying 27db. Also some of the gaps in the lookup table were
filled in.

Signed-off-by: Chris Lee <updatelee@gmail.com>
---
--- media_build/linux/drivers/media/dvb-frontends/au8522_dig.c
2012-08-13 21:45:22.000000000 -0600
+++ media_build.UDL/linux/drivers/media/dvb-frontends/au8522_dig.c
2013-07-17 18:04:46.424207604 -0600
@@ -43,33 +43,61 @@
 /* VSB SNR lookup table */
 static struct mse2snr_tab vsb_mse2snr_tab[] = {
  {   0, 270 },
+ {   1, 260 },
  {   2, 250 },
  {   3, 240 },
+ {   4, 235 },
  {   5, 230 },
+ {   6, 225 },
  {   7, 220 },
+ {   8, 215 },
  {   9, 210 },
+ {  10, 206 },
+ {  11, 203 },
  {  12, 200 },
  {  13, 195 },
+ {  14, 192 },
  {  15, 190 },
+ {  16, 187 },
  {  17, 185 },
+ {  18, 182 },
  {  19, 180 },
+ {  20, 177 },
  {  21, 175 },
+ {  22, 173 },
+ {  23, 172 },
  {  24, 170 },
+ {  25, 168 },
+ {  26, 166 },
  {  27, 165 },
+ {  28, 163 },
+ {  29, 162 },
+ {  30, 161 },
  {  31, 160 },
  {  32, 158 },
  {  33, 156 },
+ {  34, 155 },
+ {  35, 153 },
  {  36, 152 },
  {  37, 150 },
+ {  38, 149 },
  {  39, 148 },
  {  40, 146 },
  {  41, 144 },
+ {  42, 143 },
  {  43, 142 },
  {  44, 140 },
+ {  45, 139 },
+ {  46, 137 },
+ {  47, 136 },
  {  48, 135 },
+ {  49, 132 },
  {  50, 130 },
- {  43, 142 },
+ {  51, 128 },
+ {  52, 126 },
  {  53, 125 },
+ {  54, 123 },
+ {  55, 122 },
  {  56, 120 },
  { 256, 115 },
 };
@@ -230,7 +258,7 @@
  dprintk("%s()\n", __func__);

  for (i = 0; i < sz; i++) {
- if (mse < tab[i].val) {
+ if (mse <= tab[i].val) {
  *snr = tab[i].data;
  ret = 0;
  break;
