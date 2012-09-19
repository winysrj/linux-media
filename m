Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41047 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2ISNB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 09:01:59 -0400
Received: by lbbgj3 with SMTP id gj3so856413lbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 06:01:57 -0700 (PDT)
Message-ID: <5059C242.3010902@gmail.com>
Date: Wed, 19 Sep 2012 15:01:54 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com>
In-Reply-To: <505844A0.30001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-18 11:53, Mauro Carvalho Chehab wrote:
> Em 16-09-2012 05:48, Anders Thomson escreveu:
> >  It doesn't make any difference though :-( I still have the layer of noise...
>
> That's weird. Hmm... perhaps priv->cfg.config is being initialized
> latter. Maybe you can then do, instead:
> 	
>                   return -EREMOTEIO;
>           }
>
> +        priv->cfg.switch_addr = priv->i2c_props.addr;
>           if ((data == 0x83) || (data == 0x84)) {
>                   priv->ver |= TDA18271;
>                   tda829x_tda18271_config.config = priv->cfg.config;
>
>
No dice:
  $ git diff | cat
diff --git a/drivers/media/common/tuners/tda8290.c 
b/drivers/media/common/tuners/tda8290.c
index 8c48521..16d7ff7 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -627,6 +627,9 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
                 return -EREMOTEIO;
         }

+       tuner_info("ANDERS: old priv->cfg.switch_addr %x\n", 
priv->cfg.switch_addr);
+       priv->cfg.switch_addr = priv->i2c_props.addr;
+       tuner_info("ANDERS: new priv->cfg.switch_addr %x\n", 
priv->cfg.switch_addr);
         if ((data == 0x83) || (data == 0x84)) {
                 priv->ver |= TDA18271;
                 tda829x_tda18271_config.config = priv->cfg.config;
@@ -640,7 +643,6 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)

                 dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
                            priv->i2c_props.adap, &priv->cfg);
-               priv->cfg.switch_addr = priv->i2c_props.addr;
         }
         if (fe->ops.tuner_ops.init)
                 fe->ops.tuner_ops.init(fe);
anders@tv /usr/src/linux $ dmesg | grep ANDERS
[    5.667022] tda829x 4-004b: ANDERS: old priv->cfg.switch_addr 0
[    5.667025] tda829x 4-004b: ANDERS: new priv->cfg.switch_addr 4b

Whereas to work, I need:
anders@tv /usr/src/linux $ grep ANDERS /3.3.8-d.patched
[    6.565254] tda829x 5-004b: ANDERS: setting switch_addr. was 0x00, 
new 0x4b
[    6.565265] tda829x 5-004b: ANDERS: new 0x61

The right data should come from some i2d property I gather...
Is there any i2c CONFIG I need to have enabled to have this working 
automagically?

here's what I have:
$ zgrep I2C /proc/config.gz
# CONFIG_BMP085_I2C is not set
CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
# I2C Hardware Bus support
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_SCMI=m
# I2C system bus drivers (mostly embedded / system-on-chip)
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set
# External I2C/SMBus adapter drivers
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
# Other I2C/SMBus bus drivers
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_VIDEO_IR_I2C=m
# CONFIG_I2C_SI4713 is not set
# I2C encoder or helper chips
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_FB_RADEON_I2C=y
# I2C RTC drivers

