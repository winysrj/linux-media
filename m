Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55129 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2CDWTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 17:19:46 -0500
Message-ID: <4F53EA7D.4090402@gmail.com>
Date: Sun, 04 Mar 2012 23:19:41 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Next <linux-next@vger.kernel.org>
Subject: Re: rtl2830: __udivdi3 undefined
References: <CAMuHMdVmiqY9uh574_uTK76+28bvhEL0BPnzjDF-bf-0mgj4gg@mail.gmail.com>
In-Reply-To: <CAMuHMdVmiqY9uh574_uTK76+28bvhEL0BPnzjDF-bf-0mgj4gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 29/02/2012 22:30, Geert Uytterhoeven ha scritto:
> http://kisskb.ellerman.id.au/kisskb/buildresult/5759200/ ERROR:
> "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
> 
> I didn't look too deeply into it, but I think it's caused by the
> "num /= priv->cfg.xtal" in rtl2830_init() (with num being u64).
> 
> Can't it use do_div() instead?
> 
> Gr{oetje,eeting}s,
> 
> Geert
> 
> -- Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
> geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a
> hacker. But when I'm talking to journalists I just say "programmer"
> or something like that. -- Linus Torvalds -- To unsubscribe from this
> list: send the line "unsubscribe linux-media" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 

Probably the best solution is to use div_u64.
The following patch fixed the warning on my 32 bit system.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/frontends/rtl2830.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/rtl2830.c
b/drivers/media/dvb/frontends/rtl2830.c
index f971d94..45196c5 100644
--- a/drivers/media/dvb/frontends/rtl2830.c
+++ b/drivers/media/dvb/frontends/rtl2830.c
@@ -244,7 +244,7 @@ static int rtl2830_init(struct dvb_frontend *fe)

 	num = priv->cfg.if_dvbt % priv->cfg.xtal;
 	num *= 0x400000;
-	num /= priv->cfg.xtal;
+	num = div_u64(num, priv->cfg.xtal);
 	num = -num;
 	if_ctl = num & 0x3fffff;
 	dbg("%s: if_ctl=%08x", __func__, if_ctl);
-- 
1.7.0.4
