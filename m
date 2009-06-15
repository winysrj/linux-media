Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZFOTBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:03 -0400
Message-ID: <4A369A6F.9010705@iki.fi>
Date: Mon, 15 Jun 2009 22:01:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Nikitenko <jan.nikitenko@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] zl10353 and qt1010: fix stack corruption bug
References: <4A28CEAD.9000000@gmail.com> <4A293B89.30502@iki.fi> <c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com> <4A2EFA23.6020602@iki.fi> <4A2F50E0.8030404@gmail.com>
In-Reply-To: <4A2F50E0.8030404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hei Jan,

On 06/10/2009 09:21 AM, Jan Nikitenko wrote:
> This patch fixes stack corruption bug present in dump_regs function of
> zl10353 and qt1010 drivers:
> the buffer buf is one byte smaller than required - there is 4 chars
> for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
> and 1 byte for zero ending the string required, i.e. 53 bytes, but
> only 52 were provided.
> The one byte missing in stack based buffer buf can cause stack
> corruption possibly leading to kernel oops, as discovered originally
> with af9015 driver.
>
> Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
>
> ---
>
> Antti Palosaari wrote:
>  > On 06/10/2009 01:39 AM, Jan Nikitenko wrote:
>  >> Solved with "[PATCH] af9015: fix stack corruption bug".
>  >
>  > This error leads to the zl10353.c and there it was copied to qt1010.c
>  > and af9015.c.
>  >
> Antti, thanks for pointing out that the same problem was also in
> zl10353.c and qt1010.c. Include your Sign-off-by, please.

I tried to test that patch (from patchwork) to ensure it is OK before 
ack, but I found it does not apply for reason or other. It looks correct 
for my eyes. Please check what's wrong and apply new patch.

[crope@localhost v4l-dvb]$ patch -p1 < 
af9015-fix-stack-corruption-bug.patch
patching file linux/drivers/media/dvb/dvb-usb/af9015.c
[crope@localhost v4l-dvb]$ patch -p1 < 
zl10353-and-qt1010-fix-stack-corruption-bug.patch
patching file linux/drivers/media/common/tuners/qt1010.c
Hunk #1 FAILED at 65.
1 out of 1 hunk FAILED -- saving rejects to file 
linux/drivers/media/common/tuners/qt1010.c.rej
patching file linux/drivers/media/dvb/frontends/zl10353.c
Hunk #1 FAILED at 102.
1 out of 1 hunk FAILED -- saving rejects to file 
linux/drivers/media/dvb/frontends/zl10353.c.rej
[crope@localhost v4l-dvb]$ hg diff
diff -r 148b4c93a728 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Mon Jun 15 14:15:33 2009 
-0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Mon Jun 15 21:55:55 2009 
+0300
@@ -541,7 +541,7 @@
  /* dump eeprom */
  static int af9015_eeprom_dump(struct dvb_usb_device *d)
  {
-	char buf[52], buf2[4];
+	char buf[4+3*16+1], buf2[4];
  	u8 reg, val;

  	for (reg = 0; ; reg++) {
[crope@localhost v4l-dvb]$ hg head
changeset:   11978:148b4c93a728
tag:         tip
parent:      11975:144d8d0cebc5
parent:      11977:8b416ba3ac89
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Mon Jun 15 14:15:33 2009 -0300
summary:     merge: http://www.linuxtv.org/hg/~dougsland/em28xx

regards
Antti
-- 
http://palosaari.fi/
