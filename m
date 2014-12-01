Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44361 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbaLANLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:11:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] media: remove emacs editor variables
Date: Mon,  1 Dec 2014 14:10:42 +0100
Message-Id: <1417439445-34862-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
References: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

1) This is not allowed by the kernel coding style
2) Just configure your editor correctly
3) It's really ugly

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml  |  8 --------
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml |  8 --------
 drivers/media/common/btcx-risc.c                           |  6 ------
 drivers/media/common/btcx-risc.h                           |  6 ------
 drivers/media/dvb-frontends/au8522.h                       |  5 -----
 drivers/media/dvb-frontends/lg2160.c                       |  6 ------
 drivers/media/dvb-frontends/lgdt3305.c                     |  6 ------
 drivers/media/dvb-frontends/lgdt330x.c                     |  6 ------
 drivers/media/dvb-frontends/lgdt330x.h                     |  6 ------
 drivers/media/dvb-frontends/lgdt330x_priv.h                |  6 ------
 drivers/media/dvb-frontends/nxt200x.h                      |  6 ------
 drivers/media/dvb-frontends/or51132.c                      |  6 ------
 drivers/media/dvb-frontends/or51132.h                      |  6 ------
 drivers/media/dvb-frontends/s5h1409.c                      |  6 ------
 drivers/media/dvb-frontends/s5h1409.h                      |  5 -----
 drivers/media/dvb-frontends/s5h1411.c                      |  5 -----
 drivers/media/dvb-frontends/s5h1411.h                      |  5 -----
 drivers/media/i2c/msp3400-driver.c                         |  8 --------
 drivers/media/pci/bt8xx/bt878.c                            |  6 ------
 drivers/media/pci/bt8xx/bttv-cards.c                       |  7 -------
 drivers/media/pci/bt8xx/bttv-driver.c                      |  6 ------
 drivers/media/pci/bt8xx/bttv-gpio.c                        |  6 ------
 drivers/media/pci/bt8xx/bttv-if.c                          |  6 ------
 drivers/media/pci/bt8xx/bttv-risc.c                        |  6 ------
 drivers/media/pci/bt8xx/bttv-vbi.c                         |  7 -------
 drivers/media/pci/bt8xx/bttv.h                             |  5 -----
 drivers/media/pci/bt8xx/bttvp.h                            |  6 ------
 drivers/media/pci/cx88/cx88-core.c                         |  7 -------
 drivers/media/pci/cx88/cx88-mpeg.c                         |  7 -------
 drivers/media/pci/cx88/cx88-tvaudio.c                      |  7 -------
 drivers/media/tuners/mt20xx.c                              |  8 --------
 drivers/media/tuners/mt2131.c                              |  5 -----
 drivers/media/tuners/mt2131.h                              |  5 -----
 drivers/media/tuners/mt2131_priv.h                         |  5 -----
 drivers/media/tuners/mxl5007t.c                            |  8 --------
 drivers/media/tuners/mxl5007t.h                            |  9 ---------
 drivers/media/tuners/tda18271-fe.c                         |  8 --------
 drivers/media/tuners/tda18271-maps.c                       |  8 --------
 drivers/media/tuners/tda18271-priv.h                       |  8 --------
 drivers/media/tuners/tda827x.c                             |  8 --------
 drivers/media/tuners/tda8290.c                             |  8 --------
 drivers/media/tuners/tda9887.c                             |  8 --------
 drivers/media/tuners/tuner-simple.c                        |  8 --------
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c              |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h              |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c               |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h               |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c                |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h                |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c                |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h                |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h                |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c              |  8 --------
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h              |  9 ---------
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                    |  6 ------
 drivers/media/usb/dvb-usb-v2/mxl111sf.h                    |  6 ------
 drivers/media/usb/dvb-usb/m920x.c                          |  5 -----
 drivers/media/usb/pvrusb2/pvrusb2-audio.c                  | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-audio.h                  | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-context.c                | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-context.h                |  9 ---------
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c               | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h               | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.c                   | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.h                   | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c            | 12 ------------
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h            | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-debug.h                  | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c               | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.h               | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c                | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h                | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c                 | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.h                 | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c                | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-encoder.h                | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h                | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h           | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                    | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c               | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h               | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-io.c                     | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-io.h                     | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c                 | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-ioread.h                 | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-main.c                   | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-std.c                    | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-std.h                    | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c                  | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.h                  | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-util.h                   | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                   | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.h                   | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c              | 11 -----------
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h              | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c                 | 12 ------------
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.h                 | 10 ----------
 drivers/media/usb/pvrusb2/pvrusb2.h                        | 10 ----------
 drivers/media/usb/usbvision/usbvision-core.c               |  8 --------
 drivers/media/usb/usbvision/usbvision-i2c.c                |  8 --------
 drivers/media/usb/usbvision/usbvision-video.c              |  8 --------
 drivers/media/usb/usbvision/usbvision.h                    |  8 --------
 drivers/media/v4l2-core/v4l2-dev.c                         |  7 -------
 include/media/videobuf-dvb.h                               |  6 ------
 104 files changed, 840 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
index 28a8c1e..a2017bf 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -212,11 +212,3 @@ standards set in the <structfield>standards</structfield> field.
     &return-value;
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
index b9fdfea..6e3cadd 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
@@ -131,11 +131,3 @@ is out of bounds or the <structfield>pad</structfield> number is invalid.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/drivers/media/common/btcx-risc.c b/drivers/media/common/btcx-risc.c
index ac1b268..e67338a 100644
--- a/drivers/media/common/btcx-risc.c
+++ b/drivers/media/common/btcx-risc.c
@@ -252,9 +252,3 @@ EXPORT_SYMBOL(btcx_screen_clips);
 EXPORT_SYMBOL(btcx_align);
 EXPORT_SYMBOL(btcx_sort_clips);
 EXPORT_SYMBOL(btcx_calc_skips);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/common/btcx-risc.h b/drivers/media/common/btcx-risc.h
index f8bc6e8..03583ef 100644
--- a/drivers/media/common/btcx-risc.h
+++ b/drivers/media/common/btcx-risc.h
@@ -26,9 +26,3 @@ void btcx_sort_clips(struct v4l2_clip *clips, unsigned int nclips);
 void btcx_calc_skips(int line, int width, int *maxy,
 		     struct btcx_skiplist *skips, unsigned int *nskips,
 		     const struct v4l2_clip *clips, unsigned int nclips);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index 83fe9a6..6122519 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -91,8 +91,3 @@ enum au8522_audio_input {
 };
 
 #endif /* __AU8522_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index 5fd14f8..99efeba 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1456,9 +1456,3 @@ MODULE_DESCRIPTION("LG Electronics LG216x ATSC/MH Demodulator Driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.3");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 92c891a..60df376 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -1215,9 +1215,3 @@ MODULE_DESCRIPTION("LG Electronics LGDT3304/5 ATSC/QAM-B Demodulator Driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.2");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index e046622..2e1a618 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -823,9 +823,3 @@ MODULE_AUTHOR("Wilson Michaels");
 MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(lgdt330x_attach);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index ca0eab5..8bb3322 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -65,9 +65,3 @@ static inline struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config*
 #endif // CONFIG_DVB_LGDT330X
 
 #endif /* LGDT330X_H */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/lgdt330x_priv.h b/drivers/media/dvb-frontends/lgdt330x_priv.h
index 38c7669..1922f09 100644
--- a/drivers/media/dvb-frontends/lgdt330x_priv.h
+++ b/drivers/media/dvb-frontends/lgdt330x_priv.h
@@ -69,9 +69,3 @@ enum I2C_REG {
 };
 
 #endif /* _LGDT330X_PRIV_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/nxt200x.h b/drivers/media/dvb-frontends/nxt200x.h
index b518d54..e38d01f 100644
--- a/drivers/media/dvb-frontends/nxt200x.h
+++ b/drivers/media/dvb-frontends/nxt200x.h
@@ -55,9 +55,3 @@ static inline struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* c
 #endif // CONFIG_DVB_NXT200X
 
 #endif /* NXT200X_H */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index 5ef9218..cbbd259 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -623,9 +623,3 @@ MODULE_AUTHOR("Trent Piepho");
 MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(or51132_attach);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/or51132.h b/drivers/media/dvb-frontends/or51132.h
index 9389583..cdb5be3 100644
--- a/drivers/media/dvb-frontends/or51132.h
+++ b/drivers/media/dvb-frontends/or51132.h
@@ -47,9 +47,3 @@ static inline struct dvb_frontend* or51132_attach(const struct or51132_config* c
 #endif // CONFIG_DVB_OR51132
 
 #endif // OR51132_H
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index f71b062..5ff474a 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -1021,9 +1021,3 @@ static struct dvb_frontend_ops s5h1409_ops = {
 MODULE_DESCRIPTION("Samsung S5H1409 QAM-B/ATSC Demodulator driver");
 MODULE_AUTHOR("Steven Toth");
 MODULE_LICENSE("GPL");
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index 63b1e0a..9e143f5 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -81,8 +81,3 @@ static inline struct dvb_frontend *s5h1409_attach(
 #endif /* CONFIG_DVB_S5H1409 */
 
 #endif /* __S5H1409_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index 6cc4b7a..64f35fe 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -944,8 +944,3 @@ MODULE_PARM_DESC(debug, "Enable verbose debug messages");
 MODULE_DESCRIPTION("Samsung S5H1411 QAM-B/ATSC Demodulator driver");
 MODULE_AUTHOR("Steven Toth");
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/dvb-frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
index e4f5687..1d7deb6 100644
--- a/drivers/media/dvb-frontends/s5h1411.h
+++ b/drivers/media/dvb-frontends/s5h1411.h
@@ -83,8 +83,3 @@ static inline struct dvb_frontend *s5h1411_attach(
 #endif /* CONFIG_DVB_S5H1411 */
 
 #endif /* __S5H1411_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 4d9c6bc..dcc68ec 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -904,11 +904,3 @@ static struct i2c_driver msp_driver = {
 };
 
 module_i2c_driver(msp_driver);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 1176583..0939d39 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -590,9 +590,3 @@ module_init(bt878_init_module);
 module_exit(bt878_cleanup_module);
 
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 4105560..c518677 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -5048,10 +5048,3 @@ int bttv_handle_chipset(struct bttv *btv)
 		pci_write_config_byte(btv->c.pci, PCI_LATENCY_TIMER, latency);
 	return 0;
 }
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 4a8176c..665e46d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4429,9 +4429,3 @@ static void __exit bttv_cleanup_module(void)
 
 module_init(bttv_init_module);
 module_exit(bttv_cleanup_module);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8xx/bttv-gpio.c
index 3f364b7..25b9916 100644
--- a/drivers/media/pci/bt8xx/bttv-gpio.c
+++ b/drivers/media/pci/bt8xx/bttv-gpio.c
@@ -181,9 +181,3 @@ void bttv_gpio_bits(struct bttv_core *core, u32 mask, u32 bits)
 	btwrite(data,BT848_GPIO_DATA);
 	spin_unlock_irqrestore(&btv->gpio_lock,flags);
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-if.c b/drivers/media/pci/bt8xx/bttv-if.c
index a6a540d..538652e 100644
--- a/drivers/media/pci/bt8xx/bttv-if.c
+++ b/drivers/media/pci/bt8xx/bttv-if.c
@@ -113,9 +113,3 @@ int bttv_write_gpio(unsigned int card, unsigned long mask, unsigned long data)
 		bttv_gpio_tracking(btv,"extern write");
 	return 0;
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
index 4d3f05a..3859dde 100644
--- a/drivers/media/pci/bt8xx/bttv-risc.c
+++ b/drivers/media/pci/bt8xx/bttv-risc.c
@@ -901,9 +901,3 @@ bttv_overlay_risc(struct bttv *btv,
 	buf->vb.field = ov->field;
 	return 0;
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv-vbi.c b/drivers/media/pci/bt8xx/bttv-vbi.c
index b433267..e77129c 100644
--- a/drivers/media/pci/bt8xx/bttv-vbi.c
+++ b/drivers/media/pci/bt8xx/bttv-vbi.c
@@ -450,10 +450,3 @@ void bttv_vbi_fmt_reset(struct bttv_vbi_fmt *f, unsigned int norm)
 	/* See bttv_vbi_fmt_set(). */
 	f->end                  = tvnorm->vbistart[0] * 2 + 2;
 }
-
-/* ----------------------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index f081262..91301c3 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -378,8 +378,3 @@ extern void bttv_input_fini(struct bttv *dev);
 extern void bttv_input_irq(struct bttv *dev);
 
 #endif /* _BTTV_H_ */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 9fe19488..e6e2c60 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -531,9 +531,3 @@ static inline unsigned int bttv_muxsel(const struct bttv *btv,
 #define btaor(dat,mask,adr) btwrite((dat) | ((mask) & btread(adr)), adr)
 
 #endif /* _BTTVP_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index dee177e..c38d5a1 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1091,10 +1091,3 @@ EXPORT_SYMBOL(cx88_core_put);
 
 EXPORT_SYMBOL(cx88_ir_start);
 EXPORT_SYMBOL(cx88_ir_stop);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index f181a3a..8ad09e8 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -830,10 +830,3 @@ EXPORT_SYMBOL(cx8802_start_dma);
 EXPORT_SYMBOL(cx8802_register_driver);
 EXPORT_SYMBOL(cx8802_unregister_driver);
 EXPORT_SYMBOL(cx8802_get_driver);
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index 424fd97..6bbce6a 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -1050,10 +1050,3 @@ EXPORT_SYMBOL(cx88_newstation);
 EXPORT_SYMBOL(cx88_set_stereo);
 EXPORT_SYMBOL(cx88_get_stereo);
 EXPORT_SYMBOL(cx88_audio_thread);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 0e74e97..9e03104 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -660,11 +660,3 @@ EXPORT_SYMBOL_GPL(microtune_attach);
 MODULE_DESCRIPTION("Microtune tuner driver");
 MODULE_AUTHOR("Ralph Metzler, Gerd Knorr, Gunther Mayer");
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
index f83b0c1..6e2cdd2 100644
--- a/drivers/media/tuners/mt2131.c
+++ b/drivers/media/tuners/mt2131.c
@@ -294,8 +294,3 @@ EXPORT_SYMBOL(mt2131_attach);
 MODULE_AUTHOR("Steven Toth");
 MODULE_DESCRIPTION("Microtune MT2131 silicon tuner driver");
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/tuners/mt2131.h b/drivers/media/tuners/mt2131.h
index 09ceaf6..837c854 100644
--- a/drivers/media/tuners/mt2131.h
+++ b/drivers/media/tuners/mt2131.h
@@ -47,8 +47,3 @@ static inline struct dvb_frontend* mt2131_attach(struct dvb_frontend *fe,
 #endif /* CONFIG_MEDIA_TUNER_MT2131 */
 
 #endif /* __MT2131_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/tuners/mt2131_priv.h b/drivers/media/tuners/mt2131_priv.h
index 62aeedf..91283b5 100644
--- a/drivers/media/tuners/mt2131_priv.h
+++ b/drivers/media/tuners/mt2131_priv.h
@@ -41,8 +41,3 @@ struct mt2131_priv {
 };
 
 #endif /* __MT2131_PRIV_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index 1810ad6..f4ae04c 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -938,11 +938,3 @@ MODULE_DESCRIPTION("MaxLinear MxL5007T Silicon IC tuner driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.2");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
index 37b0942..ae7037d 100644
--- a/drivers/media/tuners/mxl5007t.h
+++ b/drivers/media/tuners/mxl5007t.h
@@ -93,12 +93,3 @@ static inline struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
 #endif
 
 #endif /* __MXL5007T_H__ */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 4995b89..f862074 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1355,11 +1355,3 @@ MODULE_DESCRIPTION("NXP TDA18271HD analog / digital tuner driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.4");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tda18271-maps.c b/drivers/media/tuners/tda18271-maps.c
index b62e925..1e89dd9 100644
--- a/drivers/media/tuners/tda18271-maps.c
+++ b/drivers/media/tuners/tda18271-maps.c
@@ -1305,11 +1305,3 @@ int tda18271_assign_map_layout(struct dvb_frontend *fe)
 
 	return ret;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tda18271-priv.h b/drivers/media/tuners/tda18271-priv.h
index b36a7b7..cc80f54 100644
--- a/drivers/media/tuners/tda18271-priv.h
+++ b/drivers/media/tuners/tda18271-priv.h
@@ -226,11 +226,3 @@ extern int tda18271_calc_ir_measure(struct dvb_frontend *fe, u32 *freq);
 extern int tda18271_calc_rf_cal(struct dvb_frontend *fe, u32 *freq);
 
 #endif /* __TDA18271_PRIV_H__ */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index 73453a2..edcb4a7 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -907,11 +907,3 @@ MODULE_DESCRIPTION("DVB TDA827x driver");
 MODULE_AUTHOR("Hartmut Hackmann <hartmut.hackmann@t-online.de>");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index ab4106c..998e82b 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -881,11 +881,3 @@ EXPORT_SYMBOL_GPL(tda829x_probe);
 MODULE_DESCRIPTION("Philips/NXP TDA8290/TDA8295 analog IF demodulator driver");
 MODULE_AUTHOR("Gerd Knorr, Hartmut Hackmann, Michael Krufky");
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
index 9823248..56be6c2 100644
--- a/drivers/media/tuners/tda9887.c
+++ b/drivers/media/tuners/tda9887.c
@@ -707,11 +707,3 @@ struct dvb_frontend *tda9887_attach(struct dvb_frontend *fe,
 EXPORT_SYMBOL_GPL(tda9887_attach);
 
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index ca274c2..8e9ce14 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -1148,11 +1148,3 @@ EXPORT_SYMBOL_GPL(simple_tuner_attach);
 MODULE_DESCRIPTION("Simple 4-control-bytes style tuner driver");
 MODULE_AUTHOR("Ralph Metzler, Gerd Knorr, Gunther Mayer");
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
index 0a98d04..ecefa5c 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -604,9 +604,3 @@ MODULE_DESCRIPTION("MaxLinear MxL111SF DVB-T demodulator driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
index 2d4530f..0bd83e5 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
@@ -47,9 +47,3 @@ struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
 #endif /* CONFIG_DVB_USB_MXL111SF */
 
 #endif /* __MXL111SF_DEMOD_H__ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
index a619410..2180c13 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c
@@ -755,9 +755,3 @@ int mxl111sf_gpio_mode_switch(struct mxl111sf_state *state, unsigned int mode)
 	}
 	return 0;
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
index b85a577..16fa4d4 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h
@@ -48,9 +48,3 @@ int mxl111sf_config_pin_mux_modes(struct mxl111sf_state *state,
 				  enum mxl111sf_mux_config pin_mux_config);
 
 #endif /* _DVB_USB_MXL111SF_GPIO_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
index a101d06..283495c 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -842,9 +842,3 @@ int mxl111sf_i2c_xfer(struct i2c_adapter *adap,
 
 	return i == num ? num : -EREMOTEIO;
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
index 4657621..c486fe0 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h
@@ -27,9 +27,3 @@ int mxl111sf_i2c_xfer(struct i2c_adapter *adap,
 		      struct i2c_msg msg[], int num);
 
 #endif /* _DVB_USB_MXL111SF_I2C_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
index f6b3480..5b01911 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
@@ -335,9 +335,3 @@ int mxl111sf_idac_config(struct mxl111sf_state *state,
 
 	return ret;
 }
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
index 0643738..25aa4a1 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h
@@ -45,9 +45,3 @@ int mxl111sf_idac_config(struct mxl111sf_state *state,
 			 u8 current_value, u8 hysteresis_value);
 
 #endif /* _DVB_USB_MXL111SF_PHY_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
index 89bf115..1f4bfbc 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h
@@ -171,9 +171,3 @@
 #define V6_DIG_RF_PWR_MSB_REG  0x47
 
 #endif /* _DVB_USB_MXL111SF_REG_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index a8d2c70..444579b 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -515,11 +515,3 @@ MODULE_DESCRIPTION("MaxLinear MxL111SF CMOS tuner driver");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
index 2046db2..e6caab2 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -77,12 +77,3 @@ struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 #endif
 
 #endif /* __MXL111SF_TUNER_H__ */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index c3447ea..bec12b0 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -1425,9 +1425,3 @@ MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_DESCRIPTION("Driver for MaxLinear MxL111SF");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
index 8516c01..ee70df1 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -152,9 +152,3 @@ extern int dvb_usb_mxl111sf_debug;
 })
 
 #endif /* _DVB_USB_MXL111SF_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index abf8ab2..eafc5c8 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -1269,8 +1269,3 @@ MODULE_AUTHOR("Aapo Tahkola <aet@rasterburn.org>");
 MODULE_DESCRIPTION("DVB Driver for ULI M920x");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-audio.c b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
index cc06d5e..45276c6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
@@ -84,13 +84,3 @@ void pvr2_msp3400_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 			MSP_OUTPUT(MSP_SC_IN_DSP_SCART1), 0);
 	}
 }
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-audio.h b/drivers/media/usb/pvrusb2/pvrusb2-audio.h
index e3e63d7..27cefb5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-audio.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-audio.h
@@ -25,13 +25,3 @@
 #include "pvrusb2-hdw-internal.h"
 void pvr2_msp3400_subdev_update(struct pvr2_hdw *, struct v4l2_subdev *);
 #endif /* __PVRUSB2_AUDIO_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
index c8761c7..924fc4c 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.c
@@ -418,14 +418,3 @@ struct pvr2_ioread *pvr2_channel_create_mpeg_stream(
 	pvr2_ioread_set_sync_key(cp,stream_sync_key,sizeof(stream_sync_key));
 	return cp;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.h b/drivers/media/usb/pvrusb2/pvrusb2-context.h
index d657e53..1c1d442 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.h
@@ -83,12 +83,3 @@ int pvr2_context_global_init(void);
 void pvr2_context_global_done(void);
 
 #endif /* __PVRUSB2_CONTEXT_H */
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
index 8832090..f82f0f0 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
@@ -82,14 +82,3 @@ void pvr2_cs53l32a_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		sd->ops->audio->s_routing(sd, input, 0, 0);
 	}
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h
index 53ba548..86c17be 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h
@@ -36,13 +36,3 @@
 void pvr2_cs53l32a_subdev_update(struct pvr2_hdw *, struct v4l2_subdev *);
 
 #endif /* __PVRUSB2_AUDIO_CS53L32A_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ctrl.c b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.c
index 7d5a713..958db17 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.c
@@ -596,14 +596,3 @@ int pvr2_ctrl_value_to_sym(struct pvr2_ctrl *cptr,
 	} while(0); LOCK_GIVE(cptr->hdw->big_lock);
 	return ret;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ctrl.h b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.h
index 794ff90..c175571 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ctrl.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.h
@@ -110,13 +110,3 @@ int pvr2_ctrl_value_to_sym_internal(struct pvr2_ctrl *,
 			   unsigned int *len);
 
 #endif /* __PVRUSB2_CTRL_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
index c514d0b..1a81aa7 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -152,15 +152,3 @@ void pvr2_cx25840_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		sd->ops->audio->s_routing(sd, (u32)aud_input, 0, 0);
 	}
 }
-
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h
index e35c232..2eed7b7 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h
@@ -40,13 +40,3 @@ void pvr2_cx25840_subdev_update(struct pvr2_hdw *, struct v4l2_subdev *sd);
 
 
 #endif /* __PVRUSB2_CX2584X_V4L_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debug.h b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
index be79249..4ef2ebc 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-debug.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
@@ -57,13 +57,3 @@ extern int pvrusb2_debug;
 
 
 #endif /* __PVRUSB2_HDW_INTERNAL_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
index 4279ebb..e4022bc 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
@@ -322,14 +322,3 @@ int pvr2_debugifc_docmd(struct pvr2_hdw *hdw,const char *buf,
 
 	return 0;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.h b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.h
index 2f8d467..a8dfc55 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-debugifc.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.h
@@ -40,13 +40,3 @@ int pvr2_debugifc_docmd(struct pvr2_hdw *,
 			const char *buf_ptr,unsigned int buf_size);
 
 #endif /* __PVRUSB2_DEBUGIFC_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
index adc501d3..06c4c3d 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
@@ -564,13 +564,3 @@ MODULE_FIRMWARE(PVR2_FIRMWARE_29xxx);
 MODULE_FIRMWARE(PVR2_FIRMWARE_24xxx);
 MODULE_FIRMWARE(PVR2_FIRMWARE_73xxx);
 MODULE_FIRMWARE(PVR2_FIRMWARE_75xxx);
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-devattr.h b/drivers/media/usb/pvrusb2/pvrusb2-devattr.h
index 273c8d4..5aeefb6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-devattr.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-devattr.h
@@ -187,13 +187,3 @@ struct pvr2_device_desc {
 extern struct usb_device_id pvr2_device_table[];
 
 #endif /* __PVRUSB2_HDW_INTERNAL_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
index 9515f3a..e1907cd 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
@@ -152,13 +152,3 @@ int pvr2_eeprom_analyze(struct pvr2_hdw *hdw)
 
 	return 0;
 }
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.h b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.h
index cca3216..f1e33c8 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.h
@@ -27,13 +27,3 @@ struct pvr2_hdw;
 int pvr2_eeprom_analyze(struct pvr2_hdw *);
 
 #endif /* __PVRUSB2_EEPROM_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
index f7702ae..593b3e9 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
@@ -538,14 +538,3 @@ int pvr2_encoder_stop(struct pvr2_hdw *hdw)
 
 	return status;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.h b/drivers/media/usb/pvrusb2/pvrusb2-encoder.h
index 232fefb..a2bfb48 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.h
@@ -30,13 +30,3 @@ int pvr2_encoder_start(struct pvr2_hdw *);
 int pvr2_encoder_stop(struct pvr2_hdw *);
 
 #endif /* __PVRUSB2_ENCODER_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h b/drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h
index 614755e..06a15a6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h
@@ -60,13 +60,3 @@
 #define FX2CMD_ONAIR_DTV_POWER_OFF     0xa3u
 
 #endif /* _PVRUSB2_FX2_CMD_H_ */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
index 036952f..1f9c028 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
@@ -394,13 +394,3 @@ unsigned long pvr2_hdw_get_cur_freq(struct pvr2_hdw *);
 void pvr2_hdw_status_poll(struct pvr2_hdw *);
 
 #endif /* __PVRUSB2_HDW_INTERNAL_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 4184707..fc50379 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -343,13 +343,3 @@ void pvr2_hdw_trigger_module_log(struct pvr2_hdw *hdw);
 int pvr2_upload_firmware2(struct pvr2_hdw *hdw);
 
 #endif /* __PVRUSB2_HDW_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index b5e929f..4baa9d6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -686,13 +686,3 @@ void pvr2_i2c_core_done(struct pvr2_hdw *hdw)
 		hdw->i2c_linked = 0;
 	}
 }
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h
index 6a757692..a10a3e8 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h
@@ -27,14 +27,3 @@ void pvr2_i2c_core_done(struct pvr2_hdw *);
 
 
 #endif /* __PVRUSB2_I2C_ADAPTER_H */
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
index 1e35474..0c08f22 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -682,14 +682,3 @@ int pvr2_buffer_get_id(struct pvr2_buffer *bp)
 {
 	return bp->id;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.h b/drivers/media/usb/pvrusb2/pvrusb2-io.h
index afb7e87..0c47c6a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.h
@@ -90,13 +90,3 @@ int pvr2_buffer_get_id(struct pvr2_buffer *);
 int pvr2_buffer_queue(struct pvr2_buffer *);
 
 #endif /* __PVRUSB2_IO_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index bba6115..cd995b5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -499,14 +499,3 @@ int pvr2_ioread_read(struct pvr2_ioread *cp,void __user *buf,unsigned int cnt)
 		   cp,req_cnt,ret);
 	return ret;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.h b/drivers/media/usb/pvrusb2/pvrusb2-ioread.h
index 100e078..0b1f0fb 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.h
@@ -36,13 +36,3 @@ int pvr2_ioread_read(struct pvr2_ioread *,void __user *buf,unsigned int cnt);
 int pvr2_ioread_avail(struct pvr2_ioread *);
 
 #endif /* __PVRUSB2_IOREAD_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-main.c b/drivers/media/usb/pvrusb2/pvrusb2-main.c
index c1d9bb6..86be902 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-main.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-main.c
@@ -169,14 +169,3 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.9.1");
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-std.c b/drivers/media/usb/pvrusb2/pvrusb2-std.c
index 453627b..9a596a3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-std.c
@@ -398,14 +398,3 @@ v4l2_std_id pvr2_std_get_usable(void)
 {
 	return CSTD_ALL;
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-std.h b/drivers/media/usb/pvrusb2/pvrusb2-std.h
index a35c53d..ed4ec04 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-std.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-std.h
@@ -47,13 +47,3 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 v4l2_std_id pvr2_std_get_usable(void);
 
 #endif /* __PVRUSB2_STD_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 6ef1335..06fe63c 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -848,14 +848,3 @@ static ssize_t debugcmd_store(struct device *class_dev,
 	return count;
 }
 #endif /* CONFIG_VIDEO_PVRUSB2_DEBUGIFC */
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.h b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.h
index 6d875bf..6f0579e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.h
@@ -34,13 +34,3 @@ struct pvr2_sysfs *pvr2_sysfs_create(struct pvr2_context *,
 				     struct pvr2_sysfs_class *);
 
 #endif /* __PVRUSB2_SYSFS_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-util.h b/drivers/media/usb/pvrusb2/pvrusb2-util.h
index 92b7554..5465bf9 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-util.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-util.h
@@ -50,13 +50,3 @@
 
 
 #endif /* __PVRUSB2_UTIL_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 1b158f1..422d79e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1360,13 +1360,3 @@ struct pvr2_v4l2 *pvr2_v4l2_create(struct pvr2_context *mnp)
 	pvr2_v4l2_destroy_no_lock(vp);
 	return NULL;
 }
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.h b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.h
index 34c011a..e455c95 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.h
@@ -27,13 +27,3 @@ struct pvr2_v4l2;
 struct pvr2_v4l2 *pvr2_v4l2_create(struct pvr2_context *);
 
 #endif /* __PVRUSB2_V4L2_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
index 2e205c9..139b397 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
@@ -101,14 +101,3 @@ void pvr2_saa7115_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		sd->ops->video->s_routing(sd, input, 0, 0);
 	}
 }
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h
index 3b0bd5d..dacf3ec 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h
@@ -36,13 +36,3 @@
 void pvr2_saa7115_subdev_update(struct pvr2_hdw *, struct v4l2_subdev *);
 
 #endif /* __PVRUSB2_VIDEO_V4L_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
index 3ac8d75..f1df94a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
@@ -56,15 +56,3 @@ void pvr2_wm8775_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 		sd->ops->audio->s_routing(sd, input, 0, 0);
 	}
 }
-
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.h b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.h
index 0577bc7..a4ee12e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-wm8775.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.h
@@ -40,13 +40,3 @@ void pvr2_wm8775_subdev_update(struct pvr2_hdw *, struct v4l2_subdev *sd);
 
 
 #endif /* __PVRUSB2_WM8775_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2.h b/drivers/media/usb/pvrusb2/pvrusb2.h
index 240de9b..95f98a8 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2.h
@@ -30,13 +30,3 @@
 #define PVR_NUM 20
 
 #endif /* __PVRUSB2_H */
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 70 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 302aa07..2144b7b 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2502,11 +2502,3 @@ int usbvision_muxsel(struct usb_usbvision *usbvision, int channel)
 	usbvision_set_audio(usbvision, audio[channel]);
 	return 0;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
index ba262a3..26dbcb1 100644
--- a/drivers/media/usb/usbvision/usbvision-i2c.c
+++ b/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -445,11 +445,3 @@ static struct i2c_adapter i2c_adap_template = {
 	.owner = THIS_MODULE,
 	.name              = "usbvision",
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 9bfa041..621bcbe 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1715,11 +1715,3 @@ static void __exit usbvision_exit(void)
 
 module_init(usbvision_init);
 module_exit(usbvision_exit);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index a0c73cf..77aeb1e 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -517,11 +517,3 @@ int usbvision_power_off(struct usb_usbvision *usbvision);
 int usbvision_power_on(struct usb_usbvision *usbvision);
 
 #endif									/* __LINUX_USBVISION_H */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 9aa530a..a13cc61 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1033,10 +1033,3 @@ MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_DESCRIPTION("Device registrar for Video4Linux drivers v2");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(VIDEO_MAJOR);
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/include/media/videobuf-dvb.h b/include/media/videobuf-dvb.h
index d63965a..c3bfa47 100644
--- a/include/media/videobuf-dvb.h
+++ b/include/media/videobuf-dvb.h
@@ -56,9 +56,3 @@ struct videobuf_dvb_frontend * videobuf_dvb_get_frontend(struct videobuf_dvb_fro
 int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f, struct dvb_frontend *p);
 
 #endif			/* _VIDEOBUF_DVB_H_ */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
2.1.3

