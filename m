Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56414 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab2IORpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 13:45:00 -0400
Received: by lagy9 with SMTP id y9so3395486lag.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 10:44:59 -0700 (PDT)
Message-ID: <5054BE98.8020708@gmail.com>
Date: Sat, 15 Sep 2012 19:44:56 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com>
In-Reply-To: <5054BD53.7060109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-15 19:39, Anders Thomson wrote:
> On 2012-09-15 18:34, Mauro Carvalho Chehab wrote:
> >  >   $ cat /TV_CARD.diff
> >  >   diff --git a/drivers/media/common/tuners/tda8290.c
> >  >   b/drivers/media/common/tuners/tda8290.c
> >  >   index 064d14c..498cc7b 100644
> >  >   --- a/drivers/media/common/tuners/tda8290.c
> >  >   +++ b/drivers/media/common/tuners/tda8290.c
> >  >   @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >  >
> >  >                    dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> >  >                               priv->i2c_props.adap,&priv->cfg);
> >  >   +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new
> >  >   0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> >  >                    priv->cfg.switch_addr = priv->i2c_props.addr;
> >  >   +               priv->cfg.switch_addr = 0xc2 / 2;
> >
> >  No, this is wrong. The I2C address is passed by the bridge driver or by
> >  the tuner_core attachment, being stored at priv->i2c_props.addr.
> >
> >  What's the driver and card you're using?
> >
>
...and here's the modules I'm using
Module                  Size  Used by
hid_sunplus             1321  0
usbhid                 29765  0
uinput                  6426  2
saa7134_alsa            9359  0
tda1004x               12639  1
saa7134_dvb            22092  0
videobuf_dvb            4106  1 saa7134_dvb
dvb_core               78773  1 videobuf_dvb
ir_kbd_i2c              4473  0
tda827x                 8291  2
tda8290                11906  1
tuner                  13649  1
uvcvideo               54515  0
videobuf2_core         15467  1 uvcvideo
snd_hda_codec_realtek    46581  1
saa7134               149350  2 saa7134_alsa,saa7134_dvb
videobuf_dma_sg         6504  3 saa7134_alsa,saa7134_dvb,saa7134
videobuf_core          12866  3 videobuf_dvb,saa7134,videobuf_dma_sg
snd_hda_intel          20144  1
snd_hda_codec          59409  2 snd_hda_codec_realtek,snd_hda_intel
v4l2_common             4558  2 tuner,saa7134
videodev               68383  4 tuner,uvcvideo,saa7134,v4l2_common
snd_usb_audio          81087  0
lirc_dev                9954  0
ir_mce_kbd_decoder      2838  0
parport_pc             27310  0
rc_imon_mce             1349  0
v4l2_compat_ioctl32     6796  1 videodev
ir_rc6_decoder          1946  0
videobuf2_vmalloc       1812  1 uvcvideo
snd_usbmidi_lib        15516  1 snd_usb_audio
tveeprom               12721  1 saa7134
snd_hwdep               5006  2 snd_hda_codec,snd_usb_audio
asus_atk0110            7054  0
parport                24807  1 parport_pc
i2c_piix4               7680  0
videobuf2_memops        1638  1 videobuf2_vmalloc
ir_rc5_decoder          1433  0
imon                   18432  1
rc_core                10749  8 
ir_kbd_i2c,saa7134,ir_mce_kbd_decoder,rc_imon_mce,ir_rc6_decoder,ir_rc5_decoder,imon
pcspkr                  1659  0
atiixp                  2404  0
rtc_cmos                7570  0
sg                     20980  0
snd_rawmidi            14984  1 snd_usbmidi_lib


