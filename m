Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:29772 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZFJGUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 02:20:44 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1184938fga.17
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 23:20:44 -0700 (PDT)
Message-ID: <4A2F50E0.8030404@gmail.com>
Date: Wed, 10 Jun 2009 08:21:20 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
CC: linux-media@vger.kernel.org
Subject: [PATCH] zl10353 and qt1010: fix stack corruption bug
References: <4A28CEAD.9000000@gmail.com> <4A293B89.30502@iki.fi> <c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com> <4A2EFA23.6020602@iki.fi>
In-Reply-To: <4A2EFA23.6020602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes stack corruption bug present in dump_regs function of zl10353 
and qt1010 drivers:
the buffer buf is one byte smaller than required - there is 4 chars
for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
and 1 byte for zero ending the string required, i.e. 53 bytes, but
only 52 were provided.
The one byte missing in stack based buffer buf can cause stack corruption 
possibly leading to kernel oops, as discovered originally with af9015 driver.

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>

---

Antti Palosaari wrote:
 > On 06/10/2009 01:39 AM, Jan Nikitenko wrote:
 >> Solved with "[PATCH] af9015: fix stack corruption bug".
 >
 > This error leads to the zl10353.c and there it was copied to qt1010.c
 > and af9015.c.
 >
Antti, thanks for pointing out that the same problem was also in zl10353.c and 
qt1010.c. Include your Sign-off-by, please.

Best regards,
Jan

  linux/drivers/media/common/tuners/qt1010.c  |    2 +-
  linux/drivers/media/dvb/frontends/zl10353.c |    2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff -r cff06234b725 linux/drivers/media/common/tuners/qt1010.c
--- a/linux/drivers/media/common/tuners/qt1010.c	Sun May 31 23:07:01 2009 +0300
+++ b/linux/drivers/media/common/tuners/qt1010.c	Wed Jun 10 07:37:51 2009 +0200
@@ -65,7 +65,7 @@
  /* dump all registers */
  static void qt1010_dump_regs(struct qt1010_priv *priv)
  {
-	char buf[52], buf2[4];
+	char buf[4+3*16+1], buf2[4];
  	u8 reg, val;

  	for (reg = 0; ; reg++) {
diff -r cff06234b725 linux/drivers/media/dvb/frontends/zl10353.c
--- a/linux/drivers/media/dvb/frontends/zl10353.c	Sun May 31 23:07:01 2009 +0300
+++ b/linux/drivers/media/dvb/frontends/zl10353.c	Wed Jun 10 07:37:51 2009 +0200
@@ -102,7 +102,7 @@
  static void zl10353_dump_regs(struct dvb_frontend *fe)
  {
  	struct zl10353_state *state = fe->demodulator_priv;
-	char buf[52], buf2[4];
+	char buf[4+3*16+1], buf2[4];
  	int ret;
  	u8 reg;


