Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy004.phy.lolipop.jp ([157.7.104.45]:60539 "EHLO
        smtp-proxy004.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751066AbcIJE5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 00:57:48 -0400
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: clemens@ladisch.de, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: [RFC][PATCH 2/2] ALSA: control: replace include statements for UAPI TLV header
Date: Sat, 10 Sep 2016 13:50:16 +0900
Message-Id: <1473483016-10529-3-git-send-email-o-takashi@sakamocchi.jp>
In-Reply-To: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
References: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A former commit moves all of macros related TLV to UAPI header and
obsoletes a header for TLV just for kernel land. The aim is to share TLV
packet protocol to user land.

This commit changes codes to include it tree-widely. Although the obsoleted
header still remains for out-of-tree drivers, the drivers should be changed
as soon as possible, because the header might be removed in future release.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 Documentation/DocBook/writing-an-alsa-driver.tmpl | 2 +-
 Documentation/sound/alsa/Channel-Mapping-API.txt  | 2 +-
 drivers/media/pci/cx18/cx18-alsa-mixer.c          | 2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c          | 2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c          | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c                | 2 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c          | 2 +-
 drivers/media/usb/em28xx/em28xx-audio.c           | 2 +-
 sound/core/pcm_lib.c                              | 2 +-
 sound/core/vmaster.c                              | 2 +-
 sound/drivers/dummy.c                             | 2 +-
 sound/drivers/vx/vx_mixer.c                       | 2 +-
 sound/firewire/isight.c                           | 2 +-
 sound/hda/hdmi_chmap.c                            | 2 +-
 sound/i2c/other/ak4xxx-adda.c                     | 2 +-
 sound/i2c/other/pt2258.c                          | 2 +-
 sound/isa/ad1816a/ad1816a_lib.c                   | 2 +-
 sound/isa/cs423x/cs4236_lib.c                     | 2 +-
 sound/isa/opl3sa2.c                               | 2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                | 2 +-
 sound/isa/wss/wss_lib.c                           | 2 +-
 sound/pci/ac97/ac97_codec.c                       | 2 +-
 sound/pci/ak4531_codec.c                          | 2 +-
 sound/pci/asihpi/asihpi.c                         | 2 +-
 sound/pci/au88x0/au88x0.h                         | 2 +-
 sound/pci/ca0106/ca0106_mixer.c                   | 2 +-
 sound/pci/cs4281.c                                | 2 +-
 sound/pci/ctxfi/ctmixer.c                         | 2 +-
 sound/pci/echoaudio/darla20.c                     | 2 +-
 sound/pci/echoaudio/darla24.c                     | 2 +-
 sound/pci/echoaudio/echo3g.c                      | 2 +-
 sound/pci/echoaudio/gina20.c                      | 2 +-
 sound/pci/echoaudio/gina24.c                      | 2 +-
 sound/pci/echoaudio/indigo.c                      | 2 +-
 sound/pci/echoaudio/indigodj.c                    | 2 +-
 sound/pci/echoaudio/indigodjx.c                   | 2 +-
 sound/pci/echoaudio/indigoio.c                    | 2 +-
 sound/pci/echoaudio/indigoiox.c                   | 2 +-
 sound/pci/echoaudio/layla20.c                     | 2 +-
 sound/pci/echoaudio/layla24.c                     | 2 +-
 sound/pci/echoaudio/mia.c                         | 2 +-
 sound/pci/echoaudio/mona.c                        | 2 +-
 sound/pci/emu10k1/emufx.c                         | 2 +-
 sound/pci/emu10k1/emumixer.c                      | 2 +-
 sound/pci/emu10k1/p16v.c                          | 2 +-
 sound/pci/es1938.c                                | 2 +-
 sound/pci/fm801.c                                 | 2 +-
 sound/pci/hda/hda_codec.c                         | 2 +-
 sound/pci/hda/hda_generic.c                       | 2 +-
 sound/pci/hda/patch_cirrus.c                      | 2 +-
 sound/pci/hda/patch_hdmi.c                        | 2 +-
 sound/pci/ice1712/aureon.c                        | 2 +-
 sound/pci/ice1712/ice1712.c                       | 2 +-
 sound/pci/ice1712/juli.c                          | 2 +-
 sound/pci/ice1712/maya44.c                        | 2 +-
 sound/pci/ice1712/phase.c                         | 2 +-
 sound/pci/ice1712/pontis.c                        | 2 +-
 sound/pci/ice1712/prodigy192.c                    | 2 +-
 sound/pci/ice1712/prodigy_hifi.c                  | 2 +-
 sound/pci/ice1712/quartet.c                       | 2 +-
 sound/pci/ice1712/se.c                            | 2 +-
 sound/pci/ice1712/wm8766.c                        | 2 +-
 sound/pci/ice1712/wm8776.c                        | 2 +-
 sound/pci/ice1712/wtm.c                           | 2 +-
 sound/pci/lola/lola_mixer.c                       | 2 +-
 sound/pci/mixart/mixart_mixer.c                   | 2 +-
 sound/pci/oxygen/oxygen.c                         | 2 +-
 sound/pci/oxygen/oxygen_mixer.c                   | 2 +-
 sound/pci/oxygen/xonar_cs43xx.c                   | 2 +-
 sound/pci/oxygen/xonar_dg.c                       | 2 +-
 sound/pci/oxygen/xonar_dg_mixer.c                 | 2 +-
 sound/pci/oxygen/xonar_hdmi.c                     | 2 +-
 sound/pci/oxygen/xonar_pcm179x.c                  | 2 +-
 sound/pci/oxygen/xonar_wm87x6.c                   | 2 +-
 sound/pci/pcxhr/pcxhr_mix22.c                     | 2 +-
 sound/pci/pcxhr/pcxhr_mixer.c                     | 2 +-
 sound/pci/trident/trident_main.c                  | 2 +-
 sound/pci/via82xx.c                               | 2 +-
 sound/pci/vx222/vx222.c                           | 2 +-
 sound/pci/vx222/vx222_ops.c                       | 2 +-
 sound/pci/ymfpci/ymfpci_main.c                    | 2 +-
 sound/pcmcia/vx/vxp_mixer.c                       | 2 +-
 sound/pcmcia/vx/vxpocket.c                        | 2 +-
 sound/soc/atmel/atmel-classd.c                    | 2 +-
 sound/soc/atmel/atmel-pdmic.c                     | 2 +-
 sound/soc/codecs/88pm860x-codec.c                 | 2 +-
 sound/soc/codecs/ab8500-codec.c                   | 2 +-
 sound/soc/codecs/ad1836.c                         | 2 +-
 sound/soc/codecs/ad193x.c                         | 2 +-
 sound/soc/codecs/adau1373.c                       | 2 +-
 sound/soc/codecs/adau1761.c                       | 2 +-
 sound/soc/codecs/adau1781.c                       | 2 +-
 sound/soc/codecs/adau17x1.c                       | 2 +-
 sound/soc/codecs/adau1977.c                       | 2 +-
 sound/soc/codecs/adav80x.c                        | 2 +-
 sound/soc/codecs/ak4613.c                         | 2 +-
 sound/soc/codecs/ak4641.c                         | 2 +-
 sound/soc/codecs/ak4642.c                         | 2 +-
 sound/soc/codecs/ak4671.c                         | 2 +-
 sound/soc/codecs/alc5623.c                        | 2 +-
 sound/soc/codecs/alc5632.c                        | 2 +-
 sound/soc/codecs/arizona.c                        | 2 +-
 sound/soc/codecs/cs35l32.c                        | 2 +-
 sound/soc/codecs/cs35l33.c                        | 2 +-
 sound/soc/codecs/cs4265.c                         | 2 +-
 sound/soc/codecs/cs4271.c                         | 2 +-
 sound/soc/codecs/cs42l51.c                        | 2 +-
 sound/soc/codecs/cs42l52.c                        | 2 +-
 sound/soc/codecs/cs42l56.c                        | 2 +-
 sound/soc/codecs/cs42l73.c                        | 2 +-
 sound/soc/codecs/cs42xx8.c                        | 2 +-
 sound/soc/codecs/cs4349.c                         | 2 +-
 sound/soc/codecs/cs47l24.c                        | 2 +-
 sound/soc/codecs/cs53l30.c                        | 2 +-
 sound/soc/codecs/da7210.c                         | 2 +-
 sound/soc/codecs/da7213.c                         | 2 +-
 sound/soc/codecs/da7218.c                         | 2 +-
 sound/soc/codecs/da7219.c                         | 2 +-
 sound/soc/codecs/da732x.c                         | 2 +-
 sound/soc/codecs/da9055.c                         | 2 +-
 sound/soc/codecs/es8328.c                         | 2 +-
 sound/soc/codecs/ics43432.c                       | 2 +-
 sound/soc/codecs/inno_rk3036.c                    | 2 +-
 sound/soc/codecs/isabelle.c                       | 2 +-
 sound/soc/codecs/jz4740.c                         | 2 +-
 sound/soc/codecs/lm4857.c                         | 2 +-
 sound/soc/codecs/lm49453.c                        | 2 +-
 sound/soc/codecs/max9768.c                        | 2 +-
 sound/soc/codecs/max98088.c                       | 2 +-
 sound/soc/codecs/max98090.c                       | 2 +-
 sound/soc/codecs/max98095.c                       | 2 +-
 sound/soc/codecs/max98371.c                       | 2 +-
 sound/soc/codecs/max9850.c                        | 2 +-
 sound/soc/codecs/max9860.c                        | 2 +-
 sound/soc/codecs/max9867.c                        | 2 +-
 sound/soc/codecs/max9877.c                        | 2 +-
 sound/soc/codecs/max98925.c                       | 2 +-
 sound/soc/codecs/max98926.c                       | 2 +-
 sound/soc/codecs/ml26124.c                        | 2 +-
 sound/soc/codecs/nau8825.c                        | 2 +-
 sound/soc/codecs/pcm1681.c                        | 2 +-
 sound/soc/codecs/pcm179x.c                        | 2 +-
 sound/soc/codecs/pcm3168a.c                       | 2 +-
 sound/soc/codecs/pcm512x.c                        | 2 +-
 sound/soc/codecs/rt286.c                          | 2 +-
 sound/soc/codecs/rt298.c                          | 2 +-
 sound/soc/codecs/rt5514-spi.c                     | 2 +-
 sound/soc/codecs/rt5514.c                         | 2 +-
 sound/soc/codecs/rt5616.c                         | 2 +-
 sound/soc/codecs/rt5631.c                         | 2 +-
 sound/soc/codecs/rt5640.c                         | 2 +-
 sound/soc/codecs/rt5645.c                         | 2 +-
 sound/soc/codecs/rt5651.c                         | 2 +-
 sound/soc/codecs/rt5659.c                         | 2 +-
 sound/soc/codecs/rt5670.c                         | 2 +-
 sound/soc/codecs/rt5677.c                         | 2 +-
 sound/soc/codecs/sgtl5000.c                       | 2 +-
 sound/soc/codecs/sirf-audio-codec.c               | 2 +-
 sound/soc/codecs/sn95031.c                        | 2 +-
 sound/soc/codecs/ssm2518.c                        | 2 +-
 sound/soc/codecs/ssm2602.c                        | 2 +-
 sound/soc/codecs/ssm4567.c                        | 2 +-
 sound/soc/codecs/sta32x.c                         | 2 +-
 sound/soc/codecs/sta350.c                         | 2 +-
 sound/soc/codecs/sta529.c                         | 2 +-
 sound/soc/codecs/stac9766.c                       | 2 +-
 sound/soc/codecs/tas2552.c                        | 2 +-
 sound/soc/codecs/tas5086.c                        | 2 +-
 sound/soc/codecs/tas571x.c                        | 2 +-
 sound/soc/codecs/tas5720.c                        | 2 +-
 sound/soc/codecs/tfa9879.c                        | 2 +-
 sound/soc/codecs/tlv320aic23.c                    | 2 +-
 sound/soc/codecs/tlv320aic31xx.c                  | 2 +-
 sound/soc/codecs/tlv320aic32x4.c                  | 2 +-
 sound/soc/codecs/tlv320aic3x.c                    | 2 +-
 sound/soc/codecs/tlv320dac33.c                    | 2 +-
 sound/soc/codecs/tpa6130a2.c                      | 2 +-
 sound/soc/codecs/twl4030.c                        | 2 +-
 sound/soc/codecs/twl6040.c                        | 2 +-
 sound/soc/codecs/uda1380.c                        | 2 +-
 sound/soc/codecs/wm2000.c                         | 2 +-
 sound/soc/codecs/wm2200.c                         | 2 +-
 sound/soc/codecs/wm5100.c                         | 2 +-
 sound/soc/codecs/wm5102.c                         | 2 +-
 sound/soc/codecs/wm5110.c                         | 2 +-
 sound/soc/codecs/wm8350.c                         | 2 +-
 sound/soc/codecs/wm8400.c                         | 2 +-
 sound/soc/codecs/wm8523.c                         | 2 +-
 sound/soc/codecs/wm8580.c                         | 2 +-
 sound/soc/codecs/wm8711.c                         | 2 +-
 sound/soc/codecs/wm8728.c                         | 2 +-
 sound/soc/codecs/wm8731.c                         | 2 +-
 sound/soc/codecs/wm8737.c                         | 2 +-
 sound/soc/codecs/wm8741.c                         | 2 +-
 sound/soc/codecs/wm8753.c                         | 2 +-
 sound/soc/codecs/wm8770.c                         | 2 +-
 sound/soc/codecs/wm8776.c                         | 2 +-
 sound/soc/codecs/wm8804.c                         | 2 +-
 sound/soc/codecs/wm8900.c                         | 2 +-
 sound/soc/codecs/wm8903.c                         | 2 +-
 sound/soc/codecs/wm8904.c                         | 2 +-
 sound/soc/codecs/wm8940.c                         | 2 +-
 sound/soc/codecs/wm8955.c                         | 2 +-
 sound/soc/codecs/wm8958-dsp2.c                    | 2 +-
 sound/soc/codecs/wm8960.c                         | 2 +-
 sound/soc/codecs/wm8961.c                         | 2 +-
 sound/soc/codecs/wm8962.c                         | 2 +-
 sound/soc/codecs/wm8974.c                         | 2 +-
 sound/soc/codecs/wm8978.c                         | 2 +-
 sound/soc/codecs/wm8983.c                         | 2 +-
 sound/soc/codecs/wm8985.c                         | 2 +-
 sound/soc/codecs/wm8988.c                         | 2 +-
 sound/soc/codecs/wm8990.c                         | 2 +-
 sound/soc/codecs/wm8991.c                         | 2 +-
 sound/soc/codecs/wm8993.c                         | 2 +-
 sound/soc/codecs/wm8994.c                         | 2 +-
 sound/soc/codecs/wm8995.c                         | 2 +-
 sound/soc/codecs/wm8996.c                         | 2 +-
 sound/soc/codecs/wm8997.c                         | 2 +-
 sound/soc/codecs/wm8998.c                         | 2 +-
 sound/soc/codecs/wm9081.c                         | 2 +-
 sound/soc/codecs/wm9090.c                         | 2 +-
 sound/soc/codecs/wm9712.c                         | 2 +-
 sound/soc/codecs/wm9713.c                         | 2 +-
 sound/soc/codecs/wm_adsp.c                        | 2 +-
 sound/soc/codecs/wm_hubs.c                        | 2 +-
 sound/soc/fsl/mx27vis-aic32x4.c                   | 2 +-
 sound/soc/intel/atom/sst-atom-controls.c          | 2 +-
 sound/soc/intel/atom/sst-atom-controls.h          | 2 +-
 sound/soc/intel/haswell/sst-haswell-pcm.c         | 2 +-
 sound/soc/soc-topology.c                          | 2 +-
 sound/soc/sunxi/sun4i-codec.c                     | 2 +-
 sound/usb/6fire/control.c                         | 2 +-
 sound/usb/mixer.c                                 | 2 +-
 sound/usb/mixer_quirks.c                          | 2 +-
 sound/usb/mixer_scarlett.c                        | 2 +-
 sound/usb/stream.c                                | 2 +-
 237 files changed, 237 insertions(+), 237 deletions(-)

diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index a27ab9f5..a13c59c 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -3864,7 +3864,7 @@ struct _snd_pcm_runtime {
       <para>
       To provide information about the dB values of a mixer control, use
       on of the <constant>DECLARE_TLV_xxx</constant> macros from
-      <filename>&lt;sound/tlv.h&gt;</filename> to define a variable
+      <filename>&lt;uapi/sound/tlv.h&gt;</filename> to define a variable
       containing this information, set the<structfield>tlv.p
       </structfield> field to point to this variable, and include the
       <constant>SNDRV_CTL_ELEM_ACCESS_TLV_READ</constant> flag in the
diff --git a/Documentation/sound/alsa/Channel-Mapping-API.txt b/Documentation/sound/alsa/Channel-Mapping-API.txt
index 3c43d1a..b7bccb6 100644
--- a/Documentation/sound/alsa/Channel-Mapping-API.txt
+++ b/Documentation/sound/alsa/Channel-Mapping-API.txt
@@ -69,7 +69,7 @@ have {FL/FR/RL/RR} channel map, _PAIRED type would allow you to swap
 only {RL/RR/FL/FR} while _VAR type would allow even swapping FL and
 RR.
 
-These new TLV types are defined in sound/tlv.h.
+These new TLV types are defined in uapi/sound/tlv.h.
 
 The available channel position values are defined in sound/asound.h,
 here is a cut:
diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
index 2842752..9a22069 100644
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
@@ -30,7 +30,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "cx18-alsa.h"
 #include "cx18-driver.h"
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index ae7c2e8..07e03b0 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -33,7 +33,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index df189b1..fcdc0ff 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -37,7 +37,7 @@
 #include <sound/pcm_params.h>
 #include <sound/control.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "cx25821.h"
 #include "cx25821-reg.h"
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index f3f13eb..f17b93e 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -39,7 +39,7 @@
 #include <sound/pcm_params.h>
 #include <sound/control.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <media/i2c/wm8775.h>
 
 #include "cx88.h"
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
index 79b24bd..81f8ccb 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
@@ -30,7 +30,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ivtv-alsa.h"
 #include "ivtv-driver.h"
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 49a5f95..6820162 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -41,7 +41,7 @@
 #include <sound/info.h>
 #include <sound/initval.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ac97_codec.h>
 #include <media/v4l2-common.h>
 #include "em28xx.h"
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index bb12615..93e92c2 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -26,7 +26,7 @@
 #include <linux/export.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/info.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index 6c58e6f..65d40ee 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -13,7 +13,7 @@
 #include <linux/export.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /*
  * a subset of information returned via ctl info callback
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 172dacd..c40440e 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -30,7 +30,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/rawmidi.h>
 #include <sound/info.h>
diff --git a/sound/drivers/vx/vx_mixer.c b/sound/drivers/vx/vx_mixer.c
index be9477e..110149f 100644
--- a/sound/drivers/vx/vx_mixer.c
+++ b/sound/drivers/vx/vx_mixer.c
@@ -22,7 +22,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/vx_core.h>
 #include "vx_cmd.h"
 
diff --git a/sound/firewire/isight.c b/sound/firewire/isight.c
index 48d6dca..96ae475 100644
--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -18,7 +18,7 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "lib.h"
 #include "iso-resources.h"
 #include "packets-buffer.h"
diff --git a/sound/hda/hdmi_chmap.c b/sound/hda/hdmi_chmap.c
index 81acc20..274d764 100644
--- a/sound/hda/hdmi_chmap.c
+++ b/sound/hda/hdmi_chmap.c
@@ -4,7 +4,7 @@
 
 #include <linux/module.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/hda_chmap.h>
 
 /*
diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index bf377dc..5e5f069 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ak4xxx-adda.h>
 #include <sound/info.h>
 
diff --git a/sound/i2c/other/pt2258.c b/sound/i2c/other/pt2258.c
index 9fa390b..e333639 100644
--- a/sound/i2c/other/pt2258.c
+++ b/sound/i2c/other/pt2258.c
@@ -21,7 +21,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/i2c.h>
 #include <sound/pt2258.h>
 #include <linux/module.h>
diff --git a/sound/isa/ad1816a/ad1816a_lib.c b/sound/isa/ad1816a/ad1816a_lib.c
index 5c815f5..f2e5c52 100644
--- a/sound/isa/ad1816a/ad1816a_lib.c
+++ b/sound/isa/ad1816a/ad1816a_lib.c
@@ -24,7 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ad1816a.h>
 
 #include <asm/dma.h>
diff --git a/sound/isa/cs423x/cs4236_lib.c b/sound/isa/cs423x/cs4236_lib.c
index 2b7cc59..b4ed121 100644
--- a/sound/isa/cs423x/cs4236_lib.c
+++ b/sound/isa/cs423x/cs4236_lib.c
@@ -88,7 +88,7 @@
 #include <sound/wss.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /*
  *
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index ae13363..8e4ddb0 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -32,7 +32,7 @@
 #include <sound/mpu401.h>
 #include <sound/opl3.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Yamaha OPL3SA2+");
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index 0a52660..04e91b0 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -32,7 +32,7 @@
 #include <linux/io.h>
 #include <asm/dma.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wss.h>
 #include <sound/mpu401.h>
 #include <sound/opl3.h>
diff --git a/sound/isa/wss/wss_lib.c b/sound/isa/wss/wss_lib.c
index 913b731..6d4513e 100644
--- a/sound/isa/wss/wss_lib.c
+++ b/sound/isa/wss/wss_lib.c
@@ -35,7 +35,7 @@
 #include <sound/core.h>
 #include <sound/wss.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <asm/dma.h>
 #include <asm/irq.h>
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 82259ca..6d794b9 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -30,7 +30,7 @@
 #include <linux/mutex.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ac97_codec.h>
 #include <sound/asoundef.h>
 #include <sound/initval.h>
diff --git a/sound/pci/ak4531_codec.c b/sound/pci/ak4531_codec.c
index 2fb1fbb..f57fc41 100644
--- a/sound/pci/ak4531_codec.c
+++ b/sound/pci/ak4531_codec.c
@@ -27,7 +27,7 @@
 
 #include <sound/core.h>
 #include <sound/ak4531_codec.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /*
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 976a3d2..c68b999 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -41,7 +41,7 @@
 #include <sound/pcm_params.h>
 #include <sound/info.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/hwdep.h>
 
 MODULE_LICENSE("GPL");
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index bcc648b..ffae50e 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -25,7 +25,7 @@
 #include <sound/mpu401.h>
 #include <sound/hwdep.h>
 #include <sound/ac97_codec.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #ifndef CHIP_AU8820
 #include "au88x0_eq.h"
diff --git a/sound/pci/ca0106/ca0106_mixer.c b/sound/pci/ca0106/ca0106_mixer.c
index 025805c..103ef74 100644
--- a/sound/pci/ca0106/ca0106_mixer.c
+++ b/sound/pci/ca0106/ca0106_mixer.c
@@ -69,7 +69,7 @@
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/io.h>
 
 #include "ca0106.h"
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 615d8a9..86590c60 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -32,7 +32,7 @@
 #include <sound/pcm.h>
 #include <sound/rawmidi.h>
 #include <sound/ac97_codec.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/opl3.h>
 #include <sound/initval.h>
 
diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 4f4a2a5..b2b2ad3 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -23,7 +23,7 @@
 #include <sound/control.h>
 #include <sound/asoundef.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 enum CT_SUM_CTL {
 	SUM_IN_F,
diff --git a/sound/pci/echoaudio/darla20.c b/sound/pci/echoaudio/darla20.c
index c95da63..e5b99b3 100644
--- a/sound/pci/echoaudio/darla20.c
+++ b/sound/pci/echoaudio/darla20.c
@@ -47,7 +47,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/darla24.c b/sound/pci/echoaudio/darla24.c
index 3013b4d..179d4f4 100644
--- a/sound/pci/echoaudio/darla24.c
+++ b/sound/pci/echoaudio/darla24.c
@@ -51,7 +51,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/echo3g.c b/sound/pci/echoaudio/echo3g.c
index 1f34a07..2083948 100644
--- a/sound/pci/echoaudio/echo3g.c
+++ b/sound/pci/echoaudio/echo3g.c
@@ -58,7 +58,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/gina20.c b/sound/pci/echoaudio/gina20.c
index 67bd0c9..0b04a1f 100644
--- a/sound/pci/echoaudio/gina20.c
+++ b/sound/pci/echoaudio/gina20.c
@@ -51,7 +51,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/gina24.c b/sound/pci/echoaudio/gina24.c
index b1bcaca..18b5f3d 100644
--- a/sound/pci/echoaudio/gina24.c
+++ b/sound/pci/echoaudio/gina24.c
@@ -57,7 +57,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/indigo.c b/sound/pci/echoaudio/indigo.c
index 175af9b..f299e0d5 100644
--- a/sound/pci/echoaudio/indigo.c
+++ b/sound/pci/echoaudio/indigo.c
@@ -49,7 +49,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/indigodj.c b/sound/pci/echoaudio/indigodj.c
index 8c60314..d394ee2 100644
--- a/sound/pci/echoaudio/indigodj.c
+++ b/sound/pci/echoaudio/indigodj.c
@@ -49,7 +49,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/indigodjx.c b/sound/pci/echoaudio/indigodjx.c
index 201688e..b3245d4 100644
--- a/sound/pci/echoaudio/indigodjx.c
+++ b/sound/pci/echoaudio/indigodjx.c
@@ -49,7 +49,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/indigoio.c b/sound/pci/echoaudio/indigoio.c
index f7618ed..0b069f4 100644
--- a/sound/pci/echoaudio/indigoio.c
+++ b/sound/pci/echoaudio/indigoio.c
@@ -50,7 +50,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/indigoiox.c b/sound/pci/echoaudio/indigoiox.c
index e145b68..d9ab343 100644
--- a/sound/pci/echoaudio/indigoiox.c
+++ b/sound/pci/echoaudio/indigoiox.c
@@ -50,7 +50,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/layla20.c b/sound/pci/echoaudio/layla20.c
index fc8468d..2724aba 100644
--- a/sound/pci/echoaudio/layla20.c
+++ b/sound/pci/echoaudio/layla20.c
@@ -56,7 +56,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/layla24.c b/sound/pci/echoaudio/layla24.c
index 6e40237..64a78f4 100644
--- a/sound/pci/echoaudio/layla24.c
+++ b/sound/pci/echoaudio/layla24.c
@@ -58,7 +58,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/mia.c b/sound/pci/echoaudio/mia.c
index 62b5240..9ecc89d 100644
--- a/sound/pci/echoaudio/mia.c
+++ b/sound/pci/echoaudio/mia.c
@@ -57,7 +57,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/echoaudio/mona.c b/sound/pci/echoaudio/mona.c
index 34d4994..46f4551 100644
--- a/sound/pci/echoaudio/mona.c
+++ b/sound/pci/echoaudio/mona.c
@@ -55,7 +55,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/asoundef.h>
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 56fc47b..c0e024a 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -38,7 +38,7 @@
 #include <linux/moduleparam.h>
 
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/emu10k1.h>
 
 #if 0		/* for testing purposes - digital out -> capture */
diff --git a/sound/pci/emu10k1/emumixer.c b/sound/pci/emu10k1/emumixer.c
index 076b117..dd8ef50 100644
--- a/sound/pci/emu10k1/emumixer.c
+++ b/sound/pci/emu10k1/emumixer.c
@@ -35,7 +35,7 @@
 #include <sound/core.h>
 #include <sound/emu10k1.h>
 #include <linux/delay.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "p17v.h"
 
diff --git a/sound/pci/emu10k1/p16v.c b/sound/pci/emu10k1/p16v.c
index fd9ab44..a675873 100644
--- a/sound/pci/emu10k1/p16v.c
+++ b/sound/pci/emu10k1/p16v.c
@@ -99,7 +99,7 @@
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/emu10k1.h>
 #include "p16v.h"
 
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 6813558..6a30d9f 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -62,7 +62,7 @@
 #include <sound/opl3.h>
 #include <sound/mpu401.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 MODULE_AUTHOR("Jaromir Koutek <miri@punknet.cz>");
 MODULE_DESCRIPTION("ESS Solo-1");
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index c47287d..2723d4a 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -23,7 +23,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ac97_codec.h>
 #include <sound/mpu401.h>
 #include <sound/opl3.h>
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 9913be8..655ee51 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -31,7 +31,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include <sound/asoundef.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 #include <sound/jack.h>
 #include "hda_local.h"
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index e7c8f4f..0c1ec5f 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -31,7 +31,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/jack.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "hda_codec.h"
 #include "hda_local.h"
 #include "hda_auto_parser.h"
diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 80bbadc..1ad7bbe 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "hda_codec.h"
 #include "hda_local.h"
 #include "hda_auto_parser.h"
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 56e5204..40f85f2 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -36,7 +36,7 @@
 #include <sound/core.h>
 #include <sound/jack.h>
 #include <sound/asoundef.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/hdaudio.h>
 #include <sound/hda_i915.h>
 #include <sound/hda_chmap.h>
diff --git a/sound/pci/ice1712/aureon.c b/sound/pci/ice1712/aureon.c
index c9411df..b54150e 100644
--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -57,7 +57,7 @@
 #include "ice1712.h"
 #include "envy24ht.h"
 #include "aureon.h"
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /* AC97 register cache for Aureon */
 struct aureon_spec {
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index b4aa4c1..1c205c2 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -60,7 +60,7 @@
 #include <sound/cs8427.h>
 #include <sound/info.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/asoundef.h>
 
diff --git a/sound/pci/ice1712/juli.c b/sound/pci/ice1712/juli.c
index 4f02134..4baeedc 100644
--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -28,7 +28,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ice1712.h"
 #include "envy24ht.h"
diff --git a/sound/pci/ice1712/maya44.c b/sound/pci/ice1712/maya44.c
index 7de25c4..820bbd4 100644
--- a/sound/pci/ice1712/maya44.c
+++ b/sound/pci/ice1712/maya44.c
@@ -27,7 +27,7 @@
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ice1712.h"
 #include "envy24ht.h"
diff --git a/sound/pci/ice1712/phase.c b/sound/pci/ice1712/phase.c
index e9ca89c..1bf6df2 100644
--- a/sound/pci/ice1712/phase.c
+++ b/sound/pci/ice1712/phase.c
@@ -53,7 +53,7 @@
 #include "ice1712.h"
 #include "envy24ht.h"
 #include "phase.h"
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /* AC97 register cache for Phase28 */
 struct phase28_spec {
diff --git a/sound/pci/ice1712/pontis.c b/sound/pci/ice1712/pontis.c
index 5101f40..bae8f01 100644
--- a/sound/pci/ice1712/pontis.c
+++ b/sound/pci/ice1712/pontis.c
@@ -29,7 +29,7 @@
 
 #include <sound/core.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ice1712.h"
 #include "envy24ht.h"
diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index 3919aed..365dc64 100644
--- a/sound/pci/ice1712/prodigy192.c
+++ b/sound/pci/ice1712/prodigy192.c
@@ -64,7 +64,7 @@
 #include "envy24ht.h"
 #include "prodigy192.h"
 #include "stac946x.h"
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 struct prodigy192_spec {
 	struct ak4114 *ak4114;
diff --git a/sound/pci/ice1712/prodigy_hifi.c b/sound/pci/ice1712/prodigy_hifi.c
index 2697402..e882b6e 100644
--- a/sound/pci/ice1712/prodigy_hifi.c
+++ b/sound/pci/ice1712/prodigy_hifi.c
@@ -33,7 +33,7 @@
 
 #include <sound/core.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ice1712.h"
 #include "envy24ht.h"
diff --git a/sound/pci/ice1712/quartet.c b/sound/pci/ice1712/quartet.c
index 7c387b0..52984ac 100644
--- a/sound/pci/ice1712/quartet.c
+++ b/sound/pci/ice1712/quartet.c
@@ -27,7 +27,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/info.h>
 
 #include "ice1712.h"
diff --git a/sound/pci/ice1712/se.c b/sound/pci/ice1712/se.c
index 1c5d5b2..f55b1e6 100644
--- a/sound/pci/ice1712/se.c
+++ b/sound/pci/ice1712/se.c
@@ -27,7 +27,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ice1712.h"
 #include "envy24ht.h"
diff --git a/sound/pci/ice1712/wm8766.c b/sound/pci/ice1712/wm8766.c
index f7ac8d5..75e02e1 100644
--- a/sound/pci/ice1712/wm8766.c
+++ b/sound/pci/ice1712/wm8766.c
@@ -24,7 +24,7 @@
 #include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "wm8766.h"
 
 /* low-level access */
diff --git a/sound/pci/ice1712/wm8776.c b/sound/pci/ice1712/wm8776.c
index ebd2fe4..668f8e8 100644
--- a/sound/pci/ice1712/wm8776.c
+++ b/sound/pci/ice1712/wm8776.c
@@ -24,7 +24,7 @@
 #include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "wm8776.h"
 
 /* low-level access */
diff --git a/sound/pci/ice1712/wtm.c b/sound/pci/ice1712/wtm.c
index 9906119..c6e046e 100644
--- a/sound/pci/ice1712/wtm.c
+++ b/sound/pci/ice1712/wtm.c
@@ -29,7 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/slab.h>
 
 #include "ice1712.h"
diff --git a/sound/pci/lola/lola_mixer.c b/sound/pci/lola/lola_mixer.c
index e7fe15d..8f85ad9 100644
--- a/sound/pci/lola/lola_mixer.c
+++ b/sound/pci/lola/lola_mixer.c
@@ -25,7 +25,7 @@
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "lola.h"
 
 static int lola_init_pin(struct lola *chip, struct lola_pin *pin,
diff --git a/sound/pci/mixart/mixart_mixer.c b/sound/pci/mixart/mixart_mixer.c
index 51e5349..1183ab0 100644
--- a/sound/pci/mixart/mixart_mixer.c
+++ b/sound/pci/mixart/mixart_mixer.c
@@ -30,7 +30,7 @@
 #include "mixart_core.h"
 #include "mixart_hwdep.h"
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "mixart_mixer.h"
 
 static u32 mixart_analog_level[256] = {
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index 74afb6b..f5c7744 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -59,7 +59,7 @@
 #include <sound/initval.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "oxygen.h"
 #include "xonar_dg.h"
 #include "ak4396.h"
diff --git a/sound/pci/oxygen/oxygen_mixer.c b/sound/pci/oxygen/oxygen_mixer.c
index 4ca1266..afe2595 100644
--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -21,7 +21,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/asoundef.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "oxygen.h"
 #include "cm9780.h"
 
diff --git a/sound/pci/oxygen/xonar_cs43xx.c b/sound/pci/oxygen/xonar_cs43xx.c
index d231b93..5ca8e13 100644
--- a/sound/pci/oxygen/xonar_cs43xx.c
+++ b/sound/pci/oxygen/xonar_cs43xx.c
@@ -53,7 +53,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "xonar.h"
 #include "cm9780.h"
 #include "cs4398.h"
diff --git a/sound/pci/oxygen/xonar_dg.c b/sound/pci/oxygen/xonar_dg.c
index 4cf3200..197ece9 100644
--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -59,7 +59,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "oxygen.h"
 #include "xonar_dg.h"
 #include "cs4245.h"
diff --git a/sound/pci/oxygen/xonar_dg_mixer.c b/sound/pci/oxygen/xonar_dg_mixer.c
index b885dac..8bbf528 100644
--- a/sound/pci/oxygen/xonar_dg_mixer.c
+++ b/sound/pci/oxygen/xonar_dg_mixer.c
@@ -22,7 +22,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/pcm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "oxygen.h"
 #include "xonar_dg.h"
 #include "cs4245.h"
diff --git a/sound/pci/oxygen/xonar_hdmi.c b/sound/pci/oxygen/xonar_hdmi.c
index 91d92bc..a669ecb 100644
--- a/sound/pci/oxygen/xonar_hdmi.c
+++ b/sound/pci/oxygen/xonar_hdmi.c
@@ -23,7 +23,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "xonar.h"
 
 static void hdmi_write_command(struct oxygen *chip, u8 command,
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm179x.c
index 24109d3..330331d 100644
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -187,7 +187,7 @@
 #include <sound/info.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "xonar.h"
 #include "cm9780.h"
 #include "pcm1796.h"
diff --git a/sound/pci/oxygen/xonar_wm87x6.c b/sound/pci/oxygen/xonar_wm87x6.c
index 90ac479..b69e8e0 100644
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -67,7 +67,7 @@
 #include <sound/jack.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "xonar.h"
 #include "wm8776.h"
 #include "wm8766.h"
diff --git a/sound/pci/pcxhr/pcxhr_mix22.c b/sound/pci/pcxhr/pcxhr_mix22.c
index 6a56e53..d1b9f2b 100644
--- a/sound/pci/pcxhr/pcxhr_mix22.c
+++ b/sound/pci/pcxhr/pcxhr_mix22.c
@@ -25,7 +25,7 @@
 #include <linux/pci.h>
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/asoundef.h>
 #include "pcxhr.h"
 #include "pcxhr_core.h"
diff --git a/sound/pci/pcxhr/pcxhr_mixer.c b/sound/pci/pcxhr/pcxhr_mixer.c
index 63136c4..57a0127 100644
--- a/sound/pci/pcxhr/pcxhr_mixer.c
+++ b/sound/pci/pcxhr/pcxhr_mixer.c
@@ -30,7 +30,7 @@
 #include "pcxhr_hwdep.h"
 #include "pcxhr_core.h"
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/asoundef.h>
 #include "pcxhr_mixer.h"
 #include "pcxhr_mix22.h"
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index 27f0ed8..a771b4a 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -41,7 +41,7 @@
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "trident.h"
 #include <sound/asoundef.h>
 
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 38a17b4..7a7a6a7 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -58,7 +58,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ac97_codec.h>
 #include <sound/mpu401.h>
 #include <sound/initval.h>
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index ecbaf47..685c779 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "vx222.h"
 
 #define CARD_NAME "VX222"
diff --git a/sound/pci/vx222/vx222_ops.c b/sound/pci/vx222/vx222_ops.c
index af83b3b..b5d069b 100644
--- a/sound/pci/vx222/vx222_ops.c
+++ b/sound/pci/vx222/vx222_ops.c
@@ -28,7 +28,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "vx222.h"
 
 
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index ffee284..817c016 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -32,7 +32,7 @@
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "ymfpci.h"
 #include <sound/asoundef.h>
 #include <sound/mpu401.h>
diff --git a/sound/pcmcia/vx/vxp_mixer.c b/sound/pcmcia/vx/vxp_mixer.c
index a4a6642..4f57065 100644
--- a/sound/pcmcia/vx/vxp_mixer.c
+++ b/sound/pcmcia/vx/vxp_mixer.c
@@ -22,7 +22,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "vxpocket.h"
 
 #define MIC_LEVEL_MIN	0
diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index b16f42d..1a2bf9f 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -27,7 +27,7 @@
 #include <pcmcia/ciscode.h>
 #include <pcmcia/cisreg.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /*
  */
diff --git a/sound/soc/atmel/atmel-classd.c b/sound/soc/atmel/atmel-classd.c
index 6d9b8b4..de0543a 100644
--- a/sound/soc/atmel/atmel-classd.c
+++ b/sound/soc/atmel/atmel-classd.c
@@ -17,7 +17,7 @@
 #include <sound/core.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "atmel-classd.h"
 
 struct atmel_classd_pdata {
diff --git a/sound/soc/atmel/atmel-pdmic.c b/sound/soc/atmel/atmel-pdmic.c
index 5f56da6..a5b5e59 100644
--- a/sound/soc/atmel/atmel-pdmic.c
+++ b/sound/soc/atmel/atmel-pdmic.c
@@ -17,7 +17,7 @@
 #include <sound/core.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "atmel-pdmic.h"
 
 struct atmel_pdmic_pdata {
diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index e8bed6b..c077cb3 100644
--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -21,7 +21,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 #include <sound/jack.h>
 #include <trace/events/asoc.h>
diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 2fc8915..b4ed743 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -42,7 +42,7 @@
 #include <sound/initval.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ab8500-codec.h"
 
diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index e2ce6c4..04d8a78 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -17,7 +17,7 @@
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/spi/spi.h>
 #include <linux/regmap.h>
 
diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 3a3f3f2..9a3f599 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -16,7 +16,7 @@
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ad193x.h"
 
diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 1556b36..df27503 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -18,7 +18,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/adau1373.h>
 
diff --git a/sound/soc/codecs/adau1761.c b/sound/soc/codecs/adau1761.c
index b95d29d..78cd723 100644
--- a/sound/soc/codecs/adau1761.c
+++ b/sound/soc/codecs/adau1761.c
@@ -16,7 +16,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/platform_data/adau17x1.h>
 
 #include "adau17x1.h"
diff --git a/sound/soc/codecs/adau1781.c b/sound/soc/codecs/adau1781.c
index bc1bb56..bc38749 100644
--- a/sound/soc/codecs/adau1781.c
+++ b/sound/soc/codecs/adau1781.c
@@ -16,7 +16,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/platform_data/adau17x1.h>
 
 #include "adau17x1.h"
diff --git a/sound/soc/codecs/adau17x1.c b/sound/soc/codecs/adau17x1.c
index 439aa3f..0f79004 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -16,7 +16,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/gcd.h>
 #include <linux/i2c.h>
 #include <linux/spi/spi.h>
diff --git a/sound/soc/codecs/adau1977.c b/sound/soc/codecs/adau1977.c
index 9bdd15f..23cdd99 100644
--- a/sound/soc/codecs/adau1977.c
+++ b/sound/soc/codecs/adau1977.c
@@ -23,7 +23,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "adau1977.h"
 
diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
index acff8d6..f88fb22 100644
--- a/sound/soc/codecs/adav80x.c
+++ b/sound/soc/codecs/adav80x.c
@@ -16,7 +16,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "adav80x.h"
 
diff --git a/sound/soc/codecs/ak4613.c b/sound/soc/codecs/ak4613.c
index 97798d2..402b758 100644
--- a/sound/soc/codecs/ak4613.c
+++ b/sound/soc/codecs/ak4613.c
@@ -22,7 +22,7 @@
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define PW_MGMT1	0x00 /* Power Management 1 */
 #define PW_MGMT2	0x01 /* Power Management 2 */
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index b14176f..dd953b9 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/ak4641.h>
 
 #include "ak4641.h"
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index cc941d6..e2cef8e 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -33,7 +33,7 @@
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define PW_MGMT1	0x00
 #define PW_MGMT2	0x01
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index c73a9f6..98f56e9 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -19,7 +19,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ak4671.h"
 
diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index d2e3a3e..d6d6fdb 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -27,7 +27,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
 #include <sound/alc5623.h>
diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index 4d3ba33..0198012 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -26,7 +26,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
 
diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index ecfdbfc..03d8e21 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -16,7 +16,7 @@
 #include <linux/pm_runtime.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/cs35l32.c b/sound/soc/codecs/cs35l32.c
index 287d137..06c6ba3 100644
--- a/sound/soc/codecs/cs35l32.c
+++ b/sound/soc/codecs/cs35l32.c
@@ -30,7 +30,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <dt-bindings/sound/cs35l32.h>
 
 #include "cs35l32.h"
diff --git a/sound/soc/codecs/cs35l33.c b/sound/soc/codecs/cs35l33.c
index 6f9c1ad..a1b754b 100644
--- a/sound/soc/codecs/cs35l33.c
+++ b/sound/soc/codecs/cs35l33.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <sound/cs35l33.h>
diff --git a/sound/soc/codecs/cs4265.c b/sound/soc/codecs/cs4265.c
index 55db19d..8322d45 100644
--- a/sound/soc/codecs/cs4265.c
+++ b/sound/soc/codecs/cs4265.c
@@ -28,7 +28,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "cs4265.h"
 
 struct cs4265_private {
diff --git a/sound/soc/codecs/cs4271.c b/sound/soc/codecs/cs4271.c
index 0c0010b..ff3ce43 100644
--- a/sound/soc/codecs/cs4271.c
+++ b/sound/soc/codecs/cs4271.c
@@ -29,7 +29,7 @@
 #include <linux/regulator/consumer.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/cs4271.h>
 #include "cs4271.h"
 
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 35488f1..5b464dc 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 #include <sound/pcm_params.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 47b97fc..8cf88d0 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -31,7 +31,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/cs42l52.h>
 #include "cs42l52.h"
 
diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index eec1ff8..b3f6c78 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -32,7 +32,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/cs42l56.h>
 #include "cs42l56.h"
 
diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 42a8fd4..f2819ee 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -28,7 +28,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/cs42l73.h>
 #include "cs42l73.h"
 
diff --git a/sound/soc/codecs/cs42xx8.c b/sound/soc/codecs/cs42xx8.c
index 1179101..b5890ee 100644
--- a/sound/soc/codecs/cs42xx8.c
+++ b/sound/soc/codecs/cs42xx8.c
@@ -18,7 +18,7 @@
 #include <linux/regulator/consumer.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "cs42xx8.h"
 
diff --git a/sound/soc/codecs/cs4349.c b/sound/soc/codecs/cs4349.c
index 0ac8fc5..de85415 100644
--- a/sound/soc/codecs/cs4349.c
+++ b/sound/soc/codecs/cs4349.c
@@ -29,7 +29,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "cs4349.h"
 
 
diff --git a/sound/soc/codecs/cs47l24.c b/sound/soc/codecs/cs47l24.c
index 954a4f5..74ddd17 100644
--- a/sound/soc/codecs/cs47l24.c
+++ b/sound/soc/codecs/cs47l24.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/cs53l30.c b/sound/soc/codecs/cs53l30.c
index 2c0d9c4..613b333 100644
--- a/sound/soc/codecs/cs53l30.c
+++ b/sound/soc/codecs/cs53l30.c
@@ -21,7 +21,7 @@
 #include <linux/regulator/consumer.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "cs53l30.h"
 
diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index af23a61..a54be32 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /* DA7210 register space */
 #define DA7210_PAGE_CONTROL		0x00
diff --git a/sound/soc/codecs/da7213.c b/sound/soc/codecs/da7213.c
index e5527bc..3281097 100644
--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -22,7 +22,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/da7213.h>
 #include "da7213.h"
diff --git a/sound/soc/codecs/da7218.c b/sound/soc/codecs/da7218.c
index 99ce23e..53dbd90 100644
--- a/sound/soc/codecs/da7218.c
+++ b/sound/soc/codecs/da7218.c
@@ -26,7 +26,7 @@
 #include <sound/soc-dapm.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include <sound/da7218.h>
diff --git a/sound/soc/codecs/da7219.c b/sound/soc/codecs/da7219.c
index 50ea943..846b483 100644
--- a/sound/soc/codecs/da7219.c
+++ b/sound/soc/codecs/da7219.c
@@ -27,7 +27,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include <sound/da7219.h>
diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index 461506a..5cda857 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -26,7 +26,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include "da732x.h"
diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index 0b2ede8..6cbed44 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/da9055.h>
 
 /* DA9055 register space */
diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 2086d71..b391959 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -23,7 +23,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "es8328.h"
 
 static const unsigned int rates_12288[] = {
diff --git a/sound/soc/codecs/ics43432.c b/sound/soc/codecs/ics43432.c
index dd850b9..03433a3 100644
--- a/sound/soc/codecs/ics43432.c
+++ b/sound/soc/codecs/ics43432.c
@@ -17,7 +17,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define ICS43432_RATE_MIN 7190 /* Hz, from data sheet */
 #define ICS43432_RATE_MAX 52800  /* Hz, from data sheet */
diff --git a/sound/soc/codecs/inno_rk3036.c b/sound/soc/codecs/inno_rk3036.c
index 9b6e884..ef88d96 100644
--- a/sound/soc/codecs/inno_rk3036.c
+++ b/sound/soc/codecs/inno_rk3036.c
@@ -6,7 +6,7 @@
  */
 
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc-dapm.h>
 #include <sound/soc-dai.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/isabelle.c b/sound/soc/codecs/isabelle.c
index be44837..0fd9556 100644
--- a/sound/soc/codecs/isabelle.c
+++ b/sound/soc/codecs/isabelle.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
 #include <asm/div64.h>
diff --git a/sound/soc/codecs/jz4740.c b/sound/soc/codecs/jz4740.c
index 1f5ab99..5adba63 100644
--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define JZ4740_REG_CODEC_1 0x0
 #define JZ4740_REG_CODEC_2 0x4
diff --git a/sound/soc/codecs/lm4857.c b/sound/soc/codecs/lm4857.c
index 558de10..6486eda 100644
--- a/sound/soc/codecs/lm4857.c
+++ b/sound/soc/codecs/lm4857.c
@@ -21,7 +21,7 @@
 
 #include <sound/core.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 static const struct reg_default lm4857_default_regs[] = {
 	{ 0x0, 0x00 },
diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
index 9af5640..3a0077a 100644
--- a/sound/soc/codecs/lm49453.c
+++ b/sound/soc/codecs/lm49453.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
 #include <asm/div64.h>
diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index 5b82e26..d9069fd 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -17,7 +17,7 @@
 
 #include <sound/core.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/max9768.h>
 
 /* "Registers" */
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index fc22804..276f190 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -21,7 +21,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/slab.h>
 #include <asm/div64.h>
 #include <sound/max98088.h>
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 584aab8..b20b078 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -22,7 +22,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/max98090.h>
 #include "max98090.h"
 
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 3577003..bbe1877 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -22,7 +22,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/slab.h>
 #include <asm/div64.h>
 #include <sound/max98095.h>
diff --git a/sound/soc/codecs/max98371.c b/sound/soc/codecs/max98371.c
index cf0a39b..f39df1e 100644
--- a/sound/soc/codecs/max98371.c
+++ b/sound/soc/codecs/max98371.c
@@ -15,7 +15,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "max98371.h"
 
 static const char *const monomix_text[] = {
diff --git a/sound/soc/codecs/max9850.c b/sound/soc/codecs/max9850.c
index c14a79d..6f75b59 100644
--- a/sound/soc/codecs/max9850.c
+++ b/sound/soc/codecs/max9850.c
@@ -23,7 +23,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "max9850.h"
 
diff --git a/sound/soc/codecs/max9860.c b/sound/soc/codecs/max9860.c
index 68074c9..b6e227a 100644
--- a/sound/soc/codecs/max9860.c
+++ b/sound/soc/codecs/max9860.c
@@ -30,7 +30,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "max9860.h"
 
diff --git a/sound/soc/codecs/max9867.c b/sound/soc/codecs/max9867.c
index 2a22fdd..d5f3f53 100644
--- a/sound/soc/codecs/max9867.c
+++ b/sound/soc/codecs/max9867.c
@@ -14,7 +14,7 @@
 #include <linux/regmap.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "max9867.h"
 
 static const char *const max9867_spmode[] = {
diff --git a/sound/soc/codecs/max9877.c b/sound/soc/codecs/max9877.c
index 61cc18e..f1022df 100644
--- a/sound/soc/codecs/max9877.c
+++ b/sound/soc/codecs/max9877.c
@@ -16,7 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "max9877.h"
 
diff --git a/sound/soc/codecs/max98925.c b/sound/soc/codecs/max98925.c
index 5990de3..6306b29 100644
--- a/sound/soc/codecs/max98925.c
+++ b/sound/soc/codecs/max98925.c
@@ -14,7 +14,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "max98925.h"
 
 static const char *const dai_text[] = {
diff --git a/sound/soc/codecs/max98926.c b/sound/soc/codecs/max98926.c
index 8d14ada..bceadef 100644
--- a/sound/soc/codecs/max98926.c
+++ b/sound/soc/codecs/max98926.c
@@ -14,7 +14,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "max98926.h"
 
 static const char * const max98926_boost_voltage_txt[] = {
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
index f561c78..c2d6823 100644
--- a/sound/soc/codecs/ml26124.c
+++ b/sound/soc/codecs/ml26124.c
@@ -28,7 +28,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "ml26124.h"
 
 #define DVOL_CTL_DVMUTE_ON		BIT(4)	/* Digital volume MUTE On */
diff --git a/sound/soc/codecs/nau8825.c b/sound/soc/codecs/nau8825.c
index 5c9707a..ae97f48 100644
--- a/sound/soc/codecs/nau8825.c
+++ b/sound/soc/codecs/nau8825.c
@@ -21,7 +21,7 @@
 #include <linux/semaphore.h>
 
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/pcm1681.c b/sound/soc/codecs/pcm1681.c
index 33e1fc2d..f3059fb 100644
--- a/sound/soc/codecs/pcm1681.c
+++ b/sound/soc/codecs/pcm1681.c
@@ -27,7 +27,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define PCM1681_PCM_FORMATS (SNDRV_PCM_FMTBIT_S16_LE  |		\
 			     SNDRV_PCM_FMTBIT_S24_LE)
diff --git a/sound/soc/codecs/pcm179x.c b/sound/soc/codecs/pcm179x.c
index 88fbdd1..2670906 100644
--- a/sound/soc/codecs/pcm179x.c
+++ b/sound/soc/codecs/pcm179x.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/of.h>
 
 #include "pcm179x.h"
diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 992a77e..f647f13 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -18,7 +18,7 @@
 
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "pcm3168a.h"
 
diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 047c489..8cd6032 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -26,7 +26,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "pcm512x.h"
 
diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
index 74c0e4e..9e012a2 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/jack.h>
 #include <linux/workqueue.h>
 #include <sound/rt286.h>
diff --git a/sound/soc/codecs/rt298.c b/sound/soc/codecs/rt298.c
index f80cfe4..614ba10 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/jack.h>
 #include <linux/workqueue.h>
 #include <sound/rt298.h>
diff --git a/sound/soc/codecs/rt5514-spi.c b/sound/soc/codecs/rt5514-spi.c
index 77ff8eb..49b46a7 100644
--- a/sound/soc/codecs/rt5514-spi.c
+++ b/sound/soc/codecs/rt5514-spi.c
@@ -33,7 +33,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rt5514-spi.h"
 
diff --git a/sound/soc/codecs/rt5514.c b/sound/soc/codecs/rt5514.c
index 7162f05..01c9c25 100644
--- a/sound/soc/codecs/rt5514.c
+++ b/sound/soc/codecs/rt5514.c
@@ -26,7 +26,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5514.h"
diff --git a/sound/soc/codecs/rt5616.c b/sound/soc/codecs/rt5616.c
index f527b5b..4cec8ce 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5616.h"
diff --git a/sound/soc/codecs/rt5631.c b/sound/soc/codecs/rt5631.c
index 1be2bab..5004d33 100644
--- a/sound/soc/codecs/rt5631.c
+++ b/sound/soc/codecs/rt5631.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rt5631.h"
 
diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 09e8988..479f162 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -29,7 +29,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5640.h"
diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 490bfe6..546da7d 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -29,7 +29,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5645.h"
diff --git a/sound/soc/codecs/rt5651.c b/sound/soc/codecs/rt5651.c
index 7a61970..0c2034b 100644
--- a/sound/soc/codecs/rt5651.c
+++ b/sound/soc/codecs/rt5651.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5651.h"
diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index 1b30914..9c34dc6 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -27,7 +27,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/rt5659.h>
 
 #include "rl6231.h"
diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index 8ef467f..103b8c4 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -27,7 +27,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/rt5670.h>
 
 #include "rl6231.h"
diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index da9483c..56875f7 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -27,7 +27,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "rl6231.h"
 #include "rt5677.h"
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 527b759..43acfa0 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -23,7 +23,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of_device.h>
 #include <sound/core.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
diff --git a/sound/soc/codecs/sirf-audio-codec.c b/sound/soc/codecs/sirf-audio-codec.c
index 6bfd25c..08eb5c4 100644
--- a/sound/soc/codecs/sirf-audio-codec.c
+++ b/sound/soc/codecs/sirf-audio-codec.c
@@ -19,7 +19,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/dmaengine_pcm.h>
 
diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index 3a7de01..1044ff0 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -36,7 +36,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/jack.h>
 #include "sn95031.h"
 
diff --git a/sound/soc/codecs/ssm2518.c b/sound/soc/codecs/ssm2518.c
index e2e0bfa..a2e7385 100644
--- a/sound/soc/codecs/ssm2518.c
+++ b/sound/soc/codecs/ssm2518.c
@@ -20,7 +20,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ssm2518.h"
 
diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index 4452fea..56eb241 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -33,7 +33,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "ssm2602.h"
 
diff --git a/sound/soc/codecs/ssm4567.c b/sound/soc/codecs/ssm4567.c
index 080c78e..02660a6 100644
--- a/sound/soc/codecs/ssm4567.c
+++ b/sound/soc/codecs/ssm4567.c
@@ -21,7 +21,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #define SSM4567_REG_POWER_CTRL		0x00
 #define SSM4567_REG_AMP_SNS_CTRL		0x01
diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index a9844b2..34dbb4e 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -37,7 +37,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/sta32x.h>
 #include "sta32x.h"
diff --git a/sound/soc/codecs/sta350.c b/sound/soc/codecs/sta350.c
index 33a4612..f81e99b 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -38,7 +38,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/sta350.h>
 #include "sta350.h"
diff --git a/sound/soc/codecs/sta529.c b/sound/soc/codecs/sta529.c
index 2cdaca9..69b2643 100644
--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -27,7 +27,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /* STA529 Register offsets */
 #define	 STA529_FFXCFG0		0x00
diff --git a/sound/soc/codecs/stac9766.c b/sound/soc/codecs/stac9766.c
index 0945c51..17b4719 100644
--- a/sound/soc/codecs/stac9766.c
+++ b/sound/soc/codecs/stac9766.c
@@ -24,7 +24,7 @@
 #include <sound/initval.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "stac9766.h"
 
diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
index cc1d398..82f8869 100644
--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -32,7 +32,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/tas2552-plat.h>
 #include <dt-bindings/sound/tas2552.h>
 
diff --git a/sound/soc/codecs/tas5086.c b/sound/soc/codecs/tas5086.c
index d49d25d..9bb5c27 100644
--- a/sound/soc/codecs/tas5086.c
+++ b/sound/soc/codecs/tas5086.c
@@ -44,7 +44,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/tas5086.h>
 
 #define TAS5086_PCM_FORMATS (SNDRV_PCM_FMTBIT_S16_LE  |		\
diff --git a/sound/soc/codecs/tas571x.c b/sound/soc/codecs/tas571x.c
index d8baca3..d575753 100644
--- a/sound/soc/codecs/tas571x.c
+++ b/sound/soc/codecs/tas571x.c
@@ -27,7 +27,7 @@
 #include <linux/stddef.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/unaligned.h>
 
 #include "tas571x.h"
diff --git a/sound/soc/codecs/tas5720.c b/sound/soc/codecs/tas5720.c
index f54fb46..eaff09d 100644
--- a/sound/soc/codecs/tas5720.c
+++ b/sound/soc/codecs/tas5720.c
@@ -29,7 +29,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "tas5720.h"
 
diff --git a/sound/soc/codecs/tfa9879.c b/sound/soc/codecs/tfa9879.c
index cb5310d..6e7f8fb 100644
--- a/sound/soc/codecs/tfa9879.c
+++ b/sound/soc/codecs/tfa9879.c
@@ -16,7 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/pcm_params.h>
 
 #include "tfa9879.h"
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index cd8c02b..4f513ba 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -29,7 +29,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 
 #include "tlv320aic23.h"
diff --git a/sound/soc/codecs/tlv320aic31xx.c b/sound/soc/codecs/tlv320aic31xx.c
index 3c5e1df..1a1dc08 100644
--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -37,7 +37,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <dt-bindings/sound/tlv320aic31xx-micbias.h>
 
 #include "tlv320aic31xx.h"
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 85d4978..199bdb3 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -42,7 +42,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "tlv320aic32x4.h"
 
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index a564759..5f98bc0 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -48,7 +48,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/tlv320aic3x.h>
 
 #include "tlv320aic3x.h"
diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index f7a6ce7..d448340 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -36,7 +36,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/tlv320dac33-plat.h>
 #include "tlv320dac33.h"
diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index f1ea052..1170882 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <sound/tpa6130a2-plat.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/regmap.h>
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index a5a4e9f..b5145b7 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -36,7 +36,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /* Register descriptions are here */
 #include <linux/mfd/twl4030-audio.h>
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 1f70810..8e03400 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -34,7 +34,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "twl6040.h"
 
diff --git a/sound/soc/codecs/uda1380.c b/sound/soc/codecs/uda1380.c
index 35f0469..94028b8 100644
--- a/sound/soc/codecs/uda1380.c
+++ b/sound/soc/codecs/uda1380.c
@@ -27,7 +27,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/uda1380.h>
 
 #include "uda1380.h"
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index a67ea10..5c40105 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -39,7 +39,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/wm2000.h>
 
diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index fd1439e..3ab0a32 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -29,7 +29,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm2200.h>
 
 #include "wm2200.h"
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 512a9d2..2292a23 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -30,7 +30,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm5100.h>
 
 #include "wm5100.h"
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 846deed..bc1a20c 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 1565470..33ebb84 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index ffbf3df..6790f42 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <trace/events/asoc.h>
 
 #include "wm8350.h"
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index b1d346a..7070998 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -28,7 +28,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8400.h"
 
diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index aa287a3..6a98368 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8523.h"
 
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index 66602bf..a9654a7 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -32,7 +32,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 #include <asm/div64.h>
 
diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index c759ec0..4d3f085 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -26,7 +26,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 
 #include "wm8711.h"
diff --git a/sound/soc/codecs/wm8728.c b/sound/soc/codecs/wm8728.c
index 1564e69..a6b69d3 100644
--- a/sound/soc/codecs/wm8728.c
+++ b/sound/soc/codecs/wm8728.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8728.h"
 
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index d18261a..6d83d69 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -31,7 +31,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8731.h"
 
diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index e780760..83c3382 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -27,7 +27,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8737.h"
 
diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index 36ef91f..5201b44 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -27,7 +27,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8741.h"
 
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index cdcc912..7a84280 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -46,7 +46,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include "wm8753.h"
diff --git a/sound/soc/codecs/wm8770.c b/sound/soc/codecs/wm8770.c
index df61784..65b5fe5 100644
--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8770.h"
 
diff --git a/sound/soc/codecs/wm8776.c b/sound/soc/codecs/wm8776.c
index 5af44f9..bb9b20c 100644
--- a/sound/soc/codecs/wm8776.c
+++ b/sound/soc/codecs/wm8776.c
@@ -27,7 +27,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8776.h"
 
diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 8d91470..c83d3b4 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc-dapm.h>
 
 #include "wm8804.h"
diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 5d8dca88..e94755c 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -31,7 +31,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8900.h"
 
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index a26ca49..f6dc6fc 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -31,7 +31,7 @@
 #include <sound/jack.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
 #include <sound/wm8903.h>
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index edd7a77..e75955e 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm8904.h>
 
 #include "wm8904.h"
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 1c60081..fef4f35 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -35,7 +35,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8940.h"
 
diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index 9db00d5..e7809c9 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm8955.h>
 
 #include "wm8955.h"
diff --git a/sound/soc/codecs/wm8958-dsp2.c b/sound/soc/codecs/wm8958-dsp2.c
index 6b864c0..634ae2b 100644
--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <trace/events/asoc.h>
 
 #include <linux/mfd/wm8994/core.h>
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index d7f444f..0bd172b 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -23,7 +23,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm8960.h>
 
 #include "wm8960.h"
diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index e30446a..8c51b00 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8961.h"
 
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index f3109da..b1c4102 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -33,7 +33,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm8962.h>
 #include <trace/events/asoc.h>
 
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index dc8c3b1..00e26de 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8974.h"
 
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index d36d600..7ccf2aa 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include "wm8978.h"
diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 0c002a5..f2523cd 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8983.h"
 
diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 7347abf..68bc235 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -31,7 +31,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8985.h"
 
diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 895721a2..48f274d 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -22,7 +22,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
 
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 23ecd30..f813b47 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include "wm8990.h"
diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index c9ee0ac..5f5be32 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -26,7 +26,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/div64.h>
 
 #include "wm8991.h"
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 8668c4c..cd2ebda 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -23,7 +23,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
 #include <sound/wm8993.h>
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index a18aecb..b1a06e8 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -28,7 +28,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <trace/events/asoc.h>
 
 #include <linux/mfd/wm8994/core.h>
diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 24500ba..7032059 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -28,7 +28,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8995.h"
 
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index a730442..9e01e6a 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -30,7 +30,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <trace/events/asoc.h>
 
 #include <sound/wm8996.h>
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 6b0785b..df2a49c 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/wm8998.c b/sound/soc/codecs/wm8998.c
index 3a5c896..96c11f3 100644
--- a/sound/soc/codecs/wm8998.c
+++ b/sound/soc/codecs/wm8998.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 363b3b6..6d991db 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -25,7 +25,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include <sound/wm9081.h>
 #include "wm9081.h"
diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index 5d73729..d0f61be 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/wm9090.h>
 
 #include "wm9090.h"
diff --git a/sound/soc/codecs/wm9712.c b/sound/soc/codecs/wm9712.c
index 488a922..a8f7a86 100644
--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -20,7 +20,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "wm9712.h"
 
 #define WM9712_VENDOR_ID 0x574d4c12
diff --git a/sound/soc/codecs/wm9713.c b/sound/soc/codecs/wm9713.c
index 9849643..22ef5cd 100644
--- a/sound/soc/codecs/wm9713.c
+++ b/sound/soc/codecs/wm9713.c
@@ -25,7 +25,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
 #include <sound/pcm_params.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/soc.h>
 
 #include "wm9713.h"
diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 21fbe7d..29c9af5 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -30,7 +30,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm_adsp.h"
 
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 624b3b9..8b0e30e 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -23,7 +23,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "wm8993.h"
 #include "wm_hubs.h"
diff --git a/sound/soc/fsl/mx27vis-aic32x4.c b/sound/soc/fsl/mx27vis-aic32x4.c
index 198eeb3..7c701c8 100644
--- a/sound/soc/fsl/mx27vis-aic32x4.c
+++ b/sound/soc/fsl/mx27vis-aic32x4.c
@@ -31,7 +31,7 @@
 #include <sound/pcm.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <asm/mach-types.h>
 
 #include "../codecs/tlv320aic32x4.h"
diff --git a/sound/soc/intel/atom/sst-atom-controls.c b/sound/soc/intel/atom/sst-atom-controls.c
index 98720a9..f4f8cdf 100644
--- a/sound/soc/intel/atom/sst-atom-controls.c
+++ b/sound/soc/intel/atom/sst-atom-controls.c
@@ -24,7 +24,7 @@
 
 #include <linux/slab.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include "sst-mfld-platform.h"
 #include "sst-atom-controls.h"
 
diff --git a/sound/soc/intel/atom/sst-atom-controls.h b/sound/soc/intel/atom/sst-atom-controls.h
index e011311..2628815 100644
--- a/sound/soc/intel/atom/sst-atom-controls.h
+++ b/sound/soc/intel/atom/sst-atom-controls.h
@@ -24,7 +24,7 @@
 #define __SST_ATOM_CONTROLS_H__
 
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 enum {
 	MERR_DPCM_AUDIO = 0,
diff --git a/sound/soc/intel/haswell/sst-haswell-pcm.c b/sound/soc/intel/haswell/sst-haswell-pcm.c
index 3154525..2dc26f08 100644
--- a/sound/soc/intel/haswell/sst-haswell-pcm.c
+++ b/sound/soc/intel/haswell/sst-haswell-pcm.c
@@ -26,7 +26,7 @@
 #include <sound/pcm_params.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/compress_driver.h>
 
 #include "../haswell/sst-haswell-ipc.h"
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index ee7f15a..390f091 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -33,7 +33,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/soc-topology.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 /*
  * We make several passes over the data (since it wont necessarily be ordered)
diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index 44f170c..f81cc90 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -34,7 +34,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 #include <sound/initval.h>
 #include <sound/dmaengine_pcm.h>
 
diff --git a/sound/usb/6fire/control.c b/sound/usb/6fire/control.c
index 54656ee..409720d4 100644
--- a/sound/usb/6fire/control.c
+++ b/sound/usb/6fire/control.c
@@ -19,7 +19,7 @@
 
 #include <linux/interrupt.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "control.h"
 #include "comm.h"
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 2f8c388..8b829b0 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -56,7 +56,7 @@
 #include <sound/control.h>
 #include <sound/hwdep.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "usbaudio.h"
 #include "mixer.h"
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f6c3bf7..33f1588 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -37,7 +37,7 @@
 #include <sound/control.h>
 #include <sound/hwdep.h>
 #include <sound/info.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "usbaudio.h"
 #include "mixer.h"
diff --git a/sound/usb/mixer_scarlett.c b/sound/usb/mixer_scarlett.c
index 7438e7c..9e0c38a 100644
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -133,7 +133,7 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "usbaudio.h"
 #include "mixer.h"
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 8e9548bc..eec38b6 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -24,7 +24,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/control.h>
-#include <sound/tlv.h>
+#include <uapi/sound/tlv.h>
 
 #include "usbaudio.h"
 #include "card.h"
-- 
2.7.4

