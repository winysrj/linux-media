Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.147]:27230 "HELO
	nm17-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754720Ab1GOCPY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 22:15:24 -0400
Message-ID: <1310695719.58713.YahooMailClassic@web121818.mail.ne1.yahoo.com>
Date: Thu, 14 Jul 2011 19:08:39 -0700 (PDT)
From: Luiz Ramos <luizzramos@yahoo.com.br>
Subject: [PATCH] Fix wrong register mask in gspca/sonixj.c
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

That's the first time I submit a patch to the Linux kernel. I hope I could do it right; please forgive me in case of mistakes.

The context: when migrating from Slackware 13.1 to 13.37 (kernel 2.6.33.x to 2.6.37.6), there was some sort of regression with the external webcam installed at the notebook (0x45:6128, SN9C325+OM6802). In the version 2.6.37.6, the images got *very* dark, making the webcam almost unusable, unless if used with direct sunlight.

Tracing back what happened, I concluded that a patch issued in 17/Dec ("[media] gspca - sonixj: Better handling of the bridge...") caused some sort of odd effects - including this - to this specific model. Enabling debug in both versions, the values output to reg17 and reg01 seemed to be different from one to other, and probably not all of them were made purposedly.

Although the work is not finished, for me it's quite certain that the masking of the reg17 variable at line 2389 of gspca_sonixj.c (now I'm referring to the latest version of the file at Linus' tree, as of 14/Jul) is not what the developer intended to do. It seems to be necessary to negate the mask MCK_SIZE_MASK when doing the "and" operation, resetting bits 0 to 4 and not the other; if not, the "or" sentence which follows becomes nonsensical.

So, the patch is simply adding a tilde to the sentence. One character only. :-)

If you could, please review this patch and give me some advice in case of mistakes.

As said above, this patch by itself is not sufficient to restore proper working of the webcam (now talking about version 2.6.37.6). I am aware that some patches which follow seem to fix things broken in that version. But trying to simply backport the latest version to that kernel version doesn't make the webcam work again. I'll try to go on making more tests and playing with reg17, in special, with the latest kernel.

Thanks,

Luiz Carlos Ramos
São Paulo - Brazil

Signed-off-by: Luiz Carlos Ramos <lramos.prof <at> yahoo.com.br>


--- a/drivers/media/video/gspca/sonixj.c        2011-07-14 13:14:41.000000000 -0300
+++ b/drivers/media/video/gspca/sonixj.c        2011-07-14 13:22:26.000000000 -0300
@@ -2386,7 +2386,7 @@ static int sd_start(struct gspca_dev *gs
                reg_w1(gspca_dev, 0x01, 0x22);
                msleep(100);
                reg01 = SCL_SEL_OD | S_PDN_INV;
-               reg17 &= MCK_SIZE_MASK;
+               reg17 &= ~MCK_SIZE_MASK; /* that is, reset bits 4..0 */
                reg17 |= 0x04;          /* clock / 4 */
                break;
        }

