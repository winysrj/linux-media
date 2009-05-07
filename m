Return-path: <linux-media-owner@vger.kernel.org>
Received: from sclnz.com ([203.167.202.17]:55758 "EHLO smtp.sclnz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZEGXfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 19:35:03 -0400
Received: from gecko (localhost.localdomain [127.0.0.1])
	by smtp.sclnz.com (8.13.8/8.13.8/Debian-3) with ESMTP id n480IU8a024218
	for <linux-media@vger.kernel.org>; Fri, 8 May 2009 12:18:30 +1200
Message-ID: <4A0370AD.2030505@sclnz.com>
Date: Fri, 08 May 2009 11:37:17 +1200
From: Rex J <biteme@sclnz.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: CX24123 no FE_HAS_LOCK/tuning failed.
References: <4A02C426.2030703@wowway.com> <1241701946.6790.38.camel@john-desktop>
In-Reply-To: <1241701946.6790.38.camel@john-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the reply John,

> he Hauppauge WinTV Nova-S-Plus has had problems with hi-band
> transponders since the 2.6.20 kernel or thereabouts.  The Optus D1
> transponders all seem to be hi-band.  See the thread at:
> http://bugzilla.kernel.org/show_bug.cgi?id=9476 where I outlined a
> fix which works OK for this card, but is not robust enough for
> general use.
>   

I've added this to the latest version of ...

root@mythbox:/usr/src/v4l-dvb# hg diff 
linux/drivers/media/dvb/frontends/isl6421.c
diff -r fe524e0a6412 linux/drivers/media/dvb/frontends/isl6421.c
--- a/linux/drivers/media/dvb/frontends/isl6421.c    Tue May 05 08:50:54 
2009 -0300
+++ b/linux/drivers/media/dvb/frontends/isl6421.c    Fri May 08 11:30:07 
2009 +1200
@@ -99,6 +99,33 @@
     fe->sec_priv = NULL;
 }
 
+static int isl6421_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t 
tone)
+{
+    struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
+    struct i2c_msg msg = {    .addr = isl6421->i2c_addr, .flags = 0,
+                .buf = &isl6421->config,
+                .len = sizeof(isl6421->config) };
+
+    switch (tone) {
+    case SEC_TONE_ON:
+        isl6421->config |= ISL6421_ENT1;
+        printk(KERN_INFO "%s(SEC_TONE_ON)", __func__);
+        break;
+    case SEC_TONE_OFF:
+        isl6421->config &= ~ISL6421_ENT1;
+        printk(KERN_INFO "%s(SEC_TONE_OFF)", __func__);
+        break;
+    default:
+        printk(KERN_ERR "%s: Invalid, tone=%d\n", __func__, tone);
+        return -EINVAL;
+    }
+
+    isl6421->config |= isl6421->override_or;
+    isl6421->config &= isl6421->override_and;
+
+    return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
+}
+
 struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct 
i2c_adapter *i2c, u8 i2c_addr,
            u8 override_set, u8 override_clear)
 {
@@ -130,12 +157,14 @@
 
     /* override frontend ops */
     fe->ops.set_voltage = isl6421_set_voltage;
+    fe->ops.set_tone = isl6421_set_tone;
     fe->ops.enable_high_lnb_voltage = isl6421_enable_high_lnb_voltage;
 
     return fe;
 }
 EXPORT_SYMBOL(isl6421_attach);
 
+
 MODULE_DESCRIPTION("Driver for lnb supply and control ic isl6421");
 MODULE_AUTHOR("Andrew de Quincey & Oliver Endriss");
 MODULE_LICENSE("GPL");


*Unfortunately it didn't seem to help*

root@mythbox:/usr/src/v4l-dvb# !scan
scan -vvv -a 0 ~tv/OptusD1
scanning /home/tv/OptusD1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12456000 H 22500000 3
initial transponder 12483000 H 22500000 3
 >>> tune to: 12456:h:0:22500
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
 >>> tuning status == 0x01
 >>> tuning status == 0x01
May  8 11:31:22 mythbox kernel: [ 3205.651828] cx88[0]/2-dvb: 
cx8802_dvb_advise_acquire
May  8 11:31:22 mythbox kernel: [ 3205.652323] CX24123: cx24123_initfe: 
init frontend
May  8 11:31:22 mythbox kernel: [ 3205.672802] 
isl6421_set_tone(SEC_TONE_OFF)<7>CX24123: cx24123_send_diseqc_msg:
May  8 11:31:22 mythbox kernel: [ 3205.836714] CX24123: 
cx24123_diseqc_send_burst:
May  8 11:31:22 mythbox kernel: [ 3205.952866] 
isl6421_set_tone(SEC_TONE_ON)<7>CX24123: cx24123_set_frontend:
May  8 11:31:22 mythbox kernel: [ 3206.004824] CX24123: 
cx24123_set_inversion: inversion auto
May  8 11:31:22 mythbox kernel: [ 3206.007124] CX24123: cx24123_set_fec: 
set FEC to 3/4
May  8 11:31:22 mythbox kernel: [ 3206.011208] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  8 11:31:22 mythbox kernel: [ 3206.011213] CX24123: 
cx24123_pll_tune: frequency=1856000
May  8 11:31:22 mythbox kernel: [ 3206.011215] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  8 11:31:22 mythbox kernel: [ 3206.017467] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  8 11:31:22 mythbox kernel: [ 3206.023693] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  8 11:31:22 mythbox kernel: [ 3206.030443] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f472b
May  8 11:31:22 mythbox kernel: [ 3206.038349] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049835
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12456:h:0:22500 (tuning failed)
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
May  8 11:31:24 mythbox kernel: [ 3208.017792] 
isl6421_set_tone(SEC_TONE_OFF)<7>CX24123: cx24123_send_diseqc_msg:
May  8 11:31:25 mythbox kernel: [ 3208.195719] CX24123: 
cx24123_diseqc_send_burst:
May  8 11:31:25 mythbox kernel: [ 3208.312913] 
isl6421_set_tone(SEC_TONE_ON)<7>CX24123: cx24123_set_frontend:
May  8 11:31:25 mythbox kernel: [ 3208.364885] CX24123: 
cx24123_set_inversion: inversion auto
May  8 11:31:25 mythbox kernel: [ 3208.367181] CX24123: cx24123_set_fec: 
set FEC to 3/4
May  8 11:31:25 mythbox kernel: [ 3208.371271] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  8 11:31:25 mythbox kernel: [ 3208.371276] CX24123: 
cx24123_pll_tune: frequency=1856000
May  8 11:31:25 mythbox kernel: [ 3208.371279] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  8 11:31:25 mythbox kernel: [ 3208.377524] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  8 11:31:25 mythbox kernel: [ 3208.383763] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  8 11:31:25 mythbox kernel: [ 3208.390010] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f472b
May  8 11:31:25 mythbox kernel: [ 3208.397886] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049835
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12483:h:0:22500
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
May  8 11:31:27 mythbox kernel: [ 3210.377686] 
isl6421_set_tone(SEC_TONE_OFF)<7>CX24123: cx24123_send_diseqc_msg:
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
May  8 11:31:27 mythbox kernel: [ 3210.556708] CX24123: 
cx24123_diseqc_send_burst:
May  8 11:31:27 mythbox kernel: [ 3210.672860] 
isl6421_set_tone(SEC_TONE_ON)<7>CX24123: cx24123_set_frontend:
May  8 11:31:27 mythbox kernel: [ 3210.724817] CX24123: 
cx24123_set_inversion: inversion auto
May  8 11:31:27 mythbox kernel: [ 3210.727113] CX24123: cx24123_set_fec: 
set FEC to 3/4
May  8 11:31:27 mythbox kernel: [ 3210.731205] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  8 11:31:27 mythbox kernel: [ 3210.731210] CX24123: 
cx24123_pll_tune: frequency=1883000
May  8 11:31:27 mythbox kernel: [ 3210.731212] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  8 11:31:27 mythbox kernel: [ 3210.737458] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  8 11:31:27 mythbox kernel: [ 3210.743689] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  8 11:31:27 mythbox kernel: [ 3210.749935] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  8 11:31:27 mythbox kernel: [ 3210.757813] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
 >>> tune to: 12483:h:0:22500 (tuning failed)
DiSEqC: switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:59: DiSEqC: e0 10 38 f3 00 00
 >>> tuning status == 0x01
 >>> tuning status == 0x01
May  8 11:31:29 mythbox kernel: [ 3212.737670] 
isl6421_set_tone(SEC_TONE_OFF)<7>CX24123: cx24123_send_diseqc_msg:
May  8 11:31:29 mythbox kernel: [ 3212.916717] CX24123: 
cx24123_diseqc_send_burst:
May  8 11:31:29 mythbox kernel: [ 3213.038352] 
isl6421_set_tone(SEC_TONE_ON)<7>CX24123: cx24123_set_frontend:
May  8 11:31:29 mythbox kernel: [ 3213.090064] CX24123: 
cx24123_set_inversion: inversion auto
May  8 11:31:29 mythbox kernel: [ 3213.092377] CX24123: cx24123_set_fec: 
set FEC to 3/4
May  8 11:31:29 mythbox kernel: [ 3213.096462] CX24123: 
cx24123_set_symbolrate: srate=22500000, ratio=0x0038f7b8, 
sample_rate=50555000 sample_gain=1
May  8 11:31:29 mythbox kernel: [ 3213.096467] CX24123: 
cx24123_pll_tune: frequency=1883000
May  8 11:31:29 mythbox kernel: [ 3213.096469] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00100e3f
May  8 11:31:29 mythbox kernel: [ 3213.103034] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x000a0180
May  8 11:31:29 mythbox kernel: [ 3213.109426] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x00000220
May  8 11:31:29 mythbox kernel: [ 3213.115652] CX24123: 
cx24123_pll_writereg: pll writereg called, data=0x001f4746
May  8 11:31:29 mythbox kernel: [ 3213.123521] CX24123: 
cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049862
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
 >>> tuning status == 0x01
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
root@mythbox:/usr/src/v4l-dvb# May  8 11:31:31 mythbox kernel: [ 
3215.102520] cx88[0]/2-dvb: cx8802_dvb_advise_release


*What have i missed?*

Can anyone suggest anything else?

Thanks, Rex
