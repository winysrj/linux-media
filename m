Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44269 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2JAQ5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 12:57:07 -0400
Received: by lbon3 with SMTP id n3so4249179lbo.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 09:57:06 -0700 (PDT)
Message-ID: <5069CB5A.6060007@gmail.com>
Date: Mon, 01 Oct 2012 18:56:58 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com> <505A1C16.40507@gmail.com> <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com> <505C7E64.4040507@redhat.com> <8ed8c988-fa8c-41fc-9f33-cccdceb1b232@email.android.com> <505EF455.9080604@redhat.com> <505F4CBC.1000201@gmail.com> <505F5760.2030602@gmail.com> <505F79CC.9080005@gmail.com>
In-Reply-To: <505F79CC.9080005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-23 23:06, Anders Thomson wrote:
> Awfully sorry about this. After having had the familty sit in and check
> the differences,
> I must say that the patch does not fix the issue. This time around I
> have x11grabs with
> ffmpeg to show if you want.
>
> I'll be away from the card until the end of the coming week. Then, I'll
> bring out the multimeter...
>
>
So, I got the multimeter working over the weekend and pretty much no 
results there. :-(
I tested vanilla 3.5.3, w/ my patch, w/ your "tuner" patch. All three 
gave a (DC) reading of 0 to 30 mV (yes milli-). Given that the wiki page 
you referred to spoke of a few volts, I guess this is just noise. Coming 
to think of it, shouldn't any signal amplification done work on HF, so 
I'd have to measure the AC on the carrier freq or something? This 
multimeter is useless in the MHz range...

While at it, I created these 20 sec snippets:
http://pickup.famthomson.se/output-vanilla.avi
vanilla 3.5.3

http://pickup.famthomson.se/output-test3.avi
This patch:
  # cat /TV_TEST3.diff
diff --git a/drivers/media/video/saa7134/saa7134-cards.c 
b/drivers/media/video/saa7134/saa7134-cards.c
index bc08f1d..98b482e 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -3291,7 +3291,7 @@ struct saa7134_board saa7134_boards[] = {
                 .radio_type     = UNSET,
                 .tuner_addr     = ADDR_UNSET,
                 .radio_addr     = ADDR_UNSET,
-               .tuner_config   = 1,
+               .tuner_config   = 0,
                 .mpeg           = SAA7134_MPEG_DVB,
                 .gpiomask       = 0x000200000,
                 .inputs         = {{

http://pickup.famthomson.se/output-card.avi
This patch:
  # cat /TV_CARD.diff
diff --git a/drivers/media/common/tuners/tda8290.c 
b/drivers/media/common/tuners/tda8290.c
index 064d14c..498cc7b 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)

                 dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
                            priv->i2c_props.adap, &priv->cfg);
+               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 
0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
                 priv->cfg.switch_addr = priv->i2c_props.addr;
+               priv->cfg.switch_addr = 0xc2 / 2;
+               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch_addr);
+
         }
         if (fe->ops.tuner_ops.init)
                 fe->ops.tuner_ops.init(fe);


Would looking again at the specifics on the 2.6.25->26 transition be of 
any help? I expect some pain to go to such old kernel, but if I can add 
some printks somewhere, maybe that could help?

Cheers,
-Anders

