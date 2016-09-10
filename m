Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy004.phy.lolipop.jp ([157.7.104.45]:60545 "EHLO
        smtp-proxy004.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751471AbcIJE5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 00:57:48 -0400
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: clemens@ladisch.de, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: [RFC][PATCH 0/2] ALSA: control: export all of TLV related macros to user land
Date: Sat, 10 Sep 2016 13:50:14 +0900
Message-Id: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Currently, TLV related protocol is not shared to user land. This is not
good in a point of application interfaces, because application developers
can't realize the protocol just to see UAPI headers.

For this purpose, this patchset moves all of macros related to TLV to UAPI
header. As a result, a header just for kernel land is obsoleted. When adding
new items to the protocol, it's added to the UAPI header. This change affects
some drivers in media subsystem.

In my concern, this change can break applications. When these macros are
already defined in application side and they includes tlv UAPI header
directly, 'redefined' warning is generated at preprocess time. But the
compilation will be success itself. If these two macros have different
content, the result of preprocess is dominated to the order to define.
However, the most applications are assumed to use TLV feature via libraries
such as alsa-lib, thus I'm optimistic to this concern.

As another my concern, the name of these macros are quite simple, as
'TLV_XXX'. It might be help application developers to rename them with a
prefix, as 'SNDRV_CTL_TLV_XXX'. (But not yet. I'm a lazy guy.)

Takashi Sakamoto (2):
  ALSA: control: export layout of TLV payload to UAPI header
  ALSA: control: replace include statements for TLV

 Documentation/DocBook/writing-an-alsa-driver.tmpl |  2 +-
 Documentation/sound/alsa/Channel-Mapping-API.txt  |  2 +-
 drivers/media/pci/cx18/cx18-alsa-mixer.c          |  2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c          |  2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c          |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                |  2 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c          |  2 +-
 drivers/media/usb/em28xx/em28xx-audio.c           |  2 +-
 include/sound/tlv.h                               | 62 +----------------------
 include/uapi/sound/tlv.h                          | 60 ++++++++++++++++++++++
 sound/core/pcm_lib.c                              |  2 +-
 sound/core/vmaster.c                              |  2 +-
 sound/drivers/dummy.c                             |  2 +-
 sound/drivers/vx/vx_mixer.c                       |  2 +-
 sound/firewire/isight.c                           |  2 +-
 sound/hda/hdmi_chmap.c                            |  2 +-
 sound/i2c/other/ak4xxx-adda.c                     |  2 +-
 sound/i2c/other/pt2258.c                          |  2 +-
 sound/isa/ad1816a/ad1816a_lib.c                   |  2 +-
 sound/isa/cs423x/cs4236_lib.c                     |  2 +-
 sound/isa/opl3sa2.c                               |  2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                |  2 +-
 sound/isa/wss/wss_lib.c                           |  2 +-
 sound/pci/ac97/ac97_codec.c                       |  2 +-
 sound/pci/ak4531_codec.c                          |  2 +-
 sound/pci/asihpi/asihpi.c                         |  2 +-
 sound/pci/au88x0/au88x0.h                         |  2 +-
 sound/pci/ca0106/ca0106_mixer.c                   |  2 +-
 sound/pci/cs4281.c                                |  2 +-
 sound/pci/ctxfi/ctmixer.c                         |  2 +-
 sound/pci/echoaudio/darla20.c                     |  2 +-
 sound/pci/echoaudio/darla24.c                     |  2 +-
 sound/pci/echoaudio/echo3g.c                      |  2 +-
 sound/pci/echoaudio/gina20.c                      |  2 +-
 sound/pci/echoaudio/gina24.c                      |  2 +-
 sound/pci/echoaudio/indigo.c                      |  2 +-
 sound/pci/echoaudio/indigodj.c                    |  2 +-
 sound/pci/echoaudio/indigodjx.c                   |  2 +-
 sound/pci/echoaudio/indigoio.c                    |  2 +-
 sound/pci/echoaudio/indigoiox.c                   |  2 +-
 sound/pci/echoaudio/layla20.c                     |  2 +-
 sound/pci/echoaudio/layla24.c                     |  2 +-
 sound/pci/echoaudio/mia.c                         |  2 +-
 sound/pci/echoaudio/mona.c                        |  2 +-
 sound/pci/emu10k1/emufx.c                         |  2 +-
 sound/pci/emu10k1/emumixer.c                      |  2 +-
 sound/pci/emu10k1/p16v.c                          |  2 +-
 sound/pci/es1938.c                                |  2 +-
 sound/pci/fm801.c                                 |  2 +-
 sound/pci/hda/hda_codec.c                         |  2 +-
 sound/pci/hda/hda_generic.c                       |  2 +-
 sound/pci/hda/patch_cirrus.c                      |  2 +-
 sound/pci/hda/patch_hdmi.c                        |  2 +-
 sound/pci/ice1712/aureon.c                        |  2 +-
 sound/pci/ice1712/ice1712.c                       |  2 +-
 sound/pci/ice1712/juli.c                          |  2 +-
 sound/pci/ice1712/maya44.c                        |  2 +-
 sound/pci/ice1712/phase.c                         |  2 +-
 sound/pci/ice1712/pontis.c                        |  2 +-
 sound/pci/ice1712/prodigy192.c                    |  2 +-
 sound/pci/ice1712/prodigy_hifi.c                  |  2 +-
 sound/pci/ice1712/quartet.c                       |  2 +-
 sound/pci/ice1712/se.c                            |  2 +-
 sound/pci/ice1712/wm8766.c                        |  2 +-
 sound/pci/ice1712/wm8776.c                        |  2 +-
 sound/pci/ice1712/wtm.c                           |  2 +-
 sound/pci/lola/lola_mixer.c                       |  2 +-
 sound/pci/mixart/mixart_mixer.c                   |  2 +-
 sound/pci/oxygen/oxygen.c                         |  2 +-
 sound/pci/oxygen/oxygen_mixer.c                   |  2 +-
 sound/pci/oxygen/xonar_cs43xx.c                   |  2 +-
 sound/pci/oxygen/xonar_dg.c                       |  2 +-
 sound/pci/oxygen/xonar_dg_mixer.c                 |  2 +-
 sound/pci/oxygen/xonar_hdmi.c                     |  2 +-
 sound/pci/oxygen/xonar_pcm179x.c                  |  2 +-
 sound/pci/oxygen/xonar_wm87x6.c                   |  2 +-
 sound/pci/pcxhr/pcxhr_mix22.c                     |  2 +-
 sound/pci/pcxhr/pcxhr_mixer.c                     |  2 +-
 sound/pci/trident/trident_main.c                  |  2 +-
 sound/pci/via82xx.c                               |  2 +-
 sound/pci/vx222/vx222.c                           |  2 +-
 sound/pci/vx222/vx222_ops.c                       |  2 +-
 sound/pci/ymfpci/ymfpci_main.c                    |  2 +-
 sound/pcmcia/vx/vxp_mixer.c                       |  2 +-
 sound/pcmcia/vx/vxpocket.c                        |  2 +-
 sound/soc/atmel/atmel-classd.c                    |  2 +-
 sound/soc/atmel/atmel-pdmic.c                     |  2 +-
 sound/soc/codecs/88pm860x-codec.c                 |  2 +-
 sound/soc/codecs/ab8500-codec.c                   |  2 +-
 sound/soc/codecs/ad1836.c                         |  2 +-
 sound/soc/codecs/ad193x.c                         |  2 +-
 sound/soc/codecs/adau1373.c                       |  2 +-
 sound/soc/codecs/adau1761.c                       |  2 +-
 sound/soc/codecs/adau1781.c                       |  2 +-
 sound/soc/codecs/adau17x1.c                       |  2 +-
 sound/soc/codecs/adau1977.c                       |  2 +-
 sound/soc/codecs/adav80x.c                        |  2 +-
 sound/soc/codecs/ak4613.c                         |  2 +-
 sound/soc/codecs/ak4641.c                         |  2 +-
 sound/soc/codecs/ak4642.c                         |  2 +-
 sound/soc/codecs/ak4671.c                         |  2 +-
 sound/soc/codecs/alc5623.c                        |  2 +-
 sound/soc/codecs/alc5632.c                        |  2 +-
 sound/soc/codecs/arizona.c                        |  2 +-
 sound/soc/codecs/cs35l32.c                        |  2 +-
 sound/soc/codecs/cs35l33.c                        |  2 +-
 sound/soc/codecs/cs4265.c                         |  2 +-
 sound/soc/codecs/cs4271.c                         |  2 +-
 sound/soc/codecs/cs42l51.c                        |  2 +-
 sound/soc/codecs/cs42l52.c                        |  2 +-
 sound/soc/codecs/cs42l56.c                        |  2 +-
 sound/soc/codecs/cs42l73.c                        |  2 +-
 sound/soc/codecs/cs42xx8.c                        |  2 +-
 sound/soc/codecs/cs4349.c                         |  2 +-
 sound/soc/codecs/cs47l24.c                        |  2 +-
 sound/soc/codecs/cs53l30.c                        |  2 +-
 sound/soc/codecs/da7210.c                         |  2 +-
 sound/soc/codecs/da7213.c                         |  2 +-
 sound/soc/codecs/da7218.c                         |  2 +-
 sound/soc/codecs/da7219.c                         |  2 +-
 sound/soc/codecs/da732x.c                         |  2 +-
 sound/soc/codecs/da9055.c                         |  2 +-
 sound/soc/codecs/es8328.c                         |  2 +-
 sound/soc/codecs/ics43432.c                       |  2 +-
 sound/soc/codecs/inno_rk3036.c                    |  2 +-
 sound/soc/codecs/isabelle.c                       |  2 +-
 sound/soc/codecs/jz4740.c                         |  2 +-
 sound/soc/codecs/lm4857.c                         |  2 +-
 sound/soc/codecs/lm49453.c                        |  2 +-
 sound/soc/codecs/max9768.c                        |  2 +-
 sound/soc/codecs/max98088.c                       |  2 +-
 sound/soc/codecs/max98090.c                       |  2 +-
 sound/soc/codecs/max98095.c                       |  2 +-
 sound/soc/codecs/max98371.c                       |  2 +-
 sound/soc/codecs/max9850.c                        |  2 +-
 sound/soc/codecs/max9860.c                        |  2 +-
 sound/soc/codecs/max9867.c                        |  2 +-
 sound/soc/codecs/max9877.c                        |  2 +-
 sound/soc/codecs/max98925.c                       |  2 +-
 sound/soc/codecs/max98926.c                       |  2 +-
 sound/soc/codecs/ml26124.c                        |  2 +-
 sound/soc/codecs/nau8825.c                        |  2 +-
 sound/soc/codecs/pcm1681.c                        |  2 +-
 sound/soc/codecs/pcm179x.c                        |  2 +-
 sound/soc/codecs/pcm3168a.c                       |  2 +-
 sound/soc/codecs/pcm512x.c                        |  2 +-
 sound/soc/codecs/rt286.c                          |  2 +-
 sound/soc/codecs/rt298.c                          |  2 +-
 sound/soc/codecs/rt5514-spi.c                     |  2 +-
 sound/soc/codecs/rt5514.c                         |  2 +-
 sound/soc/codecs/rt5616.c                         |  2 +-
 sound/soc/codecs/rt5631.c                         |  2 +-
 sound/soc/codecs/rt5640.c                         |  2 +-
 sound/soc/codecs/rt5645.c                         |  2 +-
 sound/soc/codecs/rt5651.c                         |  2 +-
 sound/soc/codecs/rt5659.c                         |  2 +-
 sound/soc/codecs/rt5670.c                         |  2 +-
 sound/soc/codecs/rt5677.c                         |  2 +-
 sound/soc/codecs/sgtl5000.c                       |  2 +-
 sound/soc/codecs/sirf-audio-codec.c               |  2 +-
 sound/soc/codecs/sn95031.c                        |  2 +-
 sound/soc/codecs/ssm2518.c                        |  2 +-
 sound/soc/codecs/ssm2602.c                        |  2 +-
 sound/soc/codecs/ssm4567.c                        |  2 +-
 sound/soc/codecs/sta32x.c                         |  2 +-
 sound/soc/codecs/sta350.c                         |  2 +-
 sound/soc/codecs/sta529.c                         |  2 +-
 sound/soc/codecs/stac9766.c                       |  2 +-
 sound/soc/codecs/tas2552.c                        |  2 +-
 sound/soc/codecs/tas5086.c                        |  2 +-
 sound/soc/codecs/tas571x.c                        |  2 +-
 sound/soc/codecs/tas5720.c                        |  2 +-
 sound/soc/codecs/tfa9879.c                        |  2 +-
 sound/soc/codecs/tlv320aic23.c                    |  2 +-
 sound/soc/codecs/tlv320aic31xx.c                  |  2 +-
 sound/soc/codecs/tlv320aic32x4.c                  |  2 +-
 sound/soc/codecs/tlv320aic3x.c                    |  2 +-
 sound/soc/codecs/tlv320dac33.c                    |  2 +-
 sound/soc/codecs/tpa6130a2.c                      |  2 +-
 sound/soc/codecs/twl4030.c                        |  2 +-
 sound/soc/codecs/twl6040.c                        |  2 +-
 sound/soc/codecs/uda1380.c                        |  2 +-
 sound/soc/codecs/wm2000.c                         |  2 +-
 sound/soc/codecs/wm2200.c                         |  2 +-
 sound/soc/codecs/wm5100.c                         |  2 +-
 sound/soc/codecs/wm5102.c                         |  2 +-
 sound/soc/codecs/wm5110.c                         |  2 +-
 sound/soc/codecs/wm8350.c                         |  2 +-
 sound/soc/codecs/wm8400.c                         |  2 +-
 sound/soc/codecs/wm8523.c                         |  2 +-
 sound/soc/codecs/wm8580.c                         |  2 +-
 sound/soc/codecs/wm8711.c                         |  2 +-
 sound/soc/codecs/wm8728.c                         |  2 +-
 sound/soc/codecs/wm8731.c                         |  2 +-
 sound/soc/codecs/wm8737.c                         |  2 +-
 sound/soc/codecs/wm8741.c                         |  2 +-
 sound/soc/codecs/wm8753.c                         |  2 +-
 sound/soc/codecs/wm8770.c                         |  2 +-
 sound/soc/codecs/wm8776.c                         |  2 +-
 sound/soc/codecs/wm8804.c                         |  2 +-
 sound/soc/codecs/wm8900.c                         |  2 +-
 sound/soc/codecs/wm8903.c                         |  2 +-
 sound/soc/codecs/wm8904.c                         |  2 +-
 sound/soc/codecs/wm8940.c                         |  2 +-
 sound/soc/codecs/wm8955.c                         |  2 +-
 sound/soc/codecs/wm8958-dsp2.c                    |  2 +-
 sound/soc/codecs/wm8960.c                         |  2 +-
 sound/soc/codecs/wm8961.c                         |  2 +-
 sound/soc/codecs/wm8962.c                         |  2 +-
 sound/soc/codecs/wm8974.c                         |  2 +-
 sound/soc/codecs/wm8978.c                         |  2 +-
 sound/soc/codecs/wm8983.c                         |  2 +-
 sound/soc/codecs/wm8985.c                         |  2 +-
 sound/soc/codecs/wm8988.c                         |  2 +-
 sound/soc/codecs/wm8990.c                         |  2 +-
 sound/soc/codecs/wm8991.c                         |  2 +-
 sound/soc/codecs/wm8993.c                         |  2 +-
 sound/soc/codecs/wm8994.c                         |  2 +-
 sound/soc/codecs/wm8995.c                         |  2 +-
 sound/soc/codecs/wm8996.c                         |  2 +-
 sound/soc/codecs/wm8997.c                         |  2 +-
 sound/soc/codecs/wm8998.c                         |  2 +-
 sound/soc/codecs/wm9081.c                         |  2 +-
 sound/soc/codecs/wm9090.c                         |  2 +-
 sound/soc/codecs/wm9712.c                         |  2 +-
 sound/soc/codecs/wm9713.c                         |  2 +-
 sound/soc/codecs/wm_adsp.c                        |  2 +-
 sound/soc/codecs/wm_hubs.c                        |  2 +-
 sound/soc/fsl/mx27vis-aic32x4.c                   |  2 +-
 sound/soc/intel/atom/sst-atom-controls.c          |  2 +-
 sound/soc/intel/atom/sst-atom-controls.h          |  2 +-
 sound/soc/intel/haswell/sst-haswell-pcm.c         |  2 +-
 sound/soc/soc-topology.c                          |  2 +-
 sound/soc/sunxi/sun4i-codec.c                     |  2 +-
 sound/usb/6fire/control.c                         |  2 +-
 sound/usb/mixer.c                                 |  2 +-
 sound/usb/mixer_quirks.c                          |  2 +-
 sound/usb/mixer_scarlett.c                        |  2 +-
 sound/usb/stream.c                                |  2 +-
 239 files changed, 298 insertions(+), 298 deletions(-)

-- 
2.7.4

