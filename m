Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.214]:46416 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751547AbdFHWL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 18:11:58 -0400
Received: from cm3.websitewelcome.com (unknown [108.167.139.23])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 6A7C22E48EE
        for <linux-media@vger.kernel.org>; Thu,  8 Jun 2017 16:51:38 -0500 (CDT)
Date: Thu, 08 Jun 2017 16:51:37 -0500
Message-ID: <20170608165137.Horde.bWBBH3ahbuGABOWprQvJwWG@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [media-af9013] question about return value in function
 af9013_wr_regs()
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1227035 I ran into the following piece  
of code at drivers/media/dvb-frontends/af9013.c:595:

595        /* program CFOE coefficients */
596        if (c->bandwidth_hz != state->bandwidth_hz) {
597                for (i = 0; i < ARRAY_SIZE(coeff_lut); i++) {
598                        if (coeff_lut[i].clock == state->config.clock &&
599                                coeff_lut[i].bandwidth_hz ==  
c->bandwidth_hz) {
600                                break;
601                        }
602                }
603
604                /* Return an error if can't find bandwidth or the  
right clock */
605                if (i == ARRAY_SIZE(coeff_lut))
606                        return -EINVAL;
608                ret = af9013_wr_regs(state, 0xae00, coeff_lut[i].val,
609                        sizeof(coeff_lut[i].val));
610        }
611
612        /* program frequency control */
613        if (c->bandwidth_hz != state->bandwidth_hz || state->first_tune) {
614                /* get used IF frequency */
615                if (fe->ops.tuner_ops.get_if_frequency)
616                        fe->ops.tuner_ops.get_if_frequency(fe,  
&if_frequency);
617                else
618                        if_frequency = state->config.if_frequency;
619
620                dev_dbg(&state->i2c->dev, "%s: if_frequency=%d\n",
621                                __func__, if_frequency);
622
623                sampling_freq = if_frequency;
624
625                while (sampling_freq > (state->config.clock / 2))
626                        sampling_freq -= state->config.clock;
627
628                if (sampling_freq < 0) {
629                        sampling_freq *= -1;
630                        spec_inv = state->config.spec_inv;
631                } else {
632                        spec_inv = !state->config.spec_inv;
633                }
634
635                freq_cw = af9013_div(state, sampling_freq,  
state->config.clock,
636                                23);
637
638                if (spec_inv)
639                        freq_cw = 0x800000 - freq_cw;
640
641                buf[0] = (freq_cw >>  0) & 0xff;
642                buf[1] = (freq_cw >>  8) & 0xff;
643                buf[2] = (freq_cw >> 16) & 0x7f;
644
645                freq_cw = 0x800000 - freq_cw;
646
647                buf[3] = (freq_cw >>  0) & 0xff;
648                buf[4] = (freq_cw >>  8) & 0xff;
649                buf[5] = (freq_cw >> 16) & 0x7f;
650
651                ret = af9013_wr_regs(state, 0xd140, buf, 3);
652                if (ret)
653                        goto err;
654
655                ret = af9013_wr_regs(state, 0x9be7, buf, 6);
656                if (ret)
657                        goto err;
658        }
659
660        /* clear TPS lock flag */
661        ret = af9013_wr_reg_bits(state, 0xd330, 3, 1, 1);
662        if (ret)
663                goto err;
664
665        /* clear MPEG2 lock flag */
666        ret = af9013_wr_reg_bits(state, 0xd507, 6, 1, 0);
667        if (ret)
668                goto err;
669
670        /* empty channel function */
671        ret = af9013_wr_reg_bits(state, 0x9bfe, 0, 1, 0);
672        if (ret)
673                goto err;
674
675        /* empty DVB-T channel function */
676        ret = af9013_wr_reg_bits(state, 0x9bc2, 0, 1, 0);
677        if (ret)
678                goto err;
679

The issue here is that the value stored in variable _ret_ at line 608,  
is not being evaluated as it happens at line 662, 667, 672 and 677.  
Then after looking into function af9013_wr_regs(), I noticed that this  
function always returns zero, no matter what, as you can see below:

121static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const  
u8 *val,
122        int len)
123{
124        int ret, i;
125        u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
126
127        if ((priv->config.ts_mode == AF9013_TS_USB) &&
128                ((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
129                mbox |= ((len - 1) << 2);
130                ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
131        } else {
132                for (i = 0; i < len; i++) {
133                        ret = af9013_wr_regs_i2c(priv, mbox, reg+i,  
val+i, 1);
134                        if (ret)
135                                goto err;
136                }
137        }
138
139err:
140        return 0;
141}

So I am wondering if such function is really intended to ignore the  
return value of af9013_wr_regs_i2c()?
If that is the case maybe it should be refactored as follows:

--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -118,26 +118,21 @@ static int af9013_rd_regs_i2c(struct  
af9013_state *priv, u8 mbox, u16 reg,
  }

  /* write multiple registers */
-static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
+static void af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
         int len)
  {
-       int ret, i;
+       int i;
         u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);

         if ((priv->config.ts_mode == AF9013_TS_USB) &&
                 ((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
                 mbox |= ((len - 1) << 2);
-               ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
+               af9013_wr_regs_i2c(priv, mbox, reg, val, len);
         } else {
                 for (i = 0; i < len; i++) {
-                       ret = af9013_wr_regs_i2c(priv, mbox, reg+i, val+i, 1);
-                       if (ret)
-                               goto err;
+                       af9013_wr_regs_i2c(priv, mbox, reg+i, val+i, 1);
                 }
         }
-
-err:
-       return 0;
  }

and of course, all of its callers also should be refactored  
accordinly.  Otherwise, the value contained in variable _ret_ should  
be properly returned.

I can do the refactoring but first it would be great to hear your  
opinions on this.

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva
