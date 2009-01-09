Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43379 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZAIUU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 15:20:57 -0500
Date: Fri, 9 Jan 2009 12:20:54 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
In-Reply-To: <Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0901091215100.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
 <20090108175627.0ebd9f36@pedra.chehab.org> <Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
 <20090108193923.580fcd5b@pedra.chehab.org> <Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
 <20090109092018.59a6d9eb@pedra.chehab.org> <20090109124357.549acef6@hyperion.delvare>
 <Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Jan 2009, Trent Piepho wrote:
> Here is a new version against latest v4l-dvb sources.  Jean, are you trying
> to apply against the kernel tree?  These patches are against the v4l-dvb Hg
> repository which isn't quite the same as what's in the kernel.
>
> I have some more patches at http://linuxtv.org/hg/~tap/zoran

Forgot the patch

# HG changeset patch
# User Trent Piepho <xyzzy@speakeasy.org>
# Date 1231532196 28800
# Node ID fdc7c04dd10d8dee62724b2d27cb725360cfda0f
# Parent  f9b51cde30807a1603a697aac7a490a77a0e3868
zoran: Convert to be a pci driver

From: Trent Piepho <xyzzy@speakeasy.org>

This is a really old and crufty driver that wasn't using the long
established pci driver framework.

Priority: normal

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff -r f9b51cde3080 -r fdc7c04dd10d linux/drivers/media/video/zoran/zoran_card.c
--- a/linux/drivers/media/video/zoran/zoran_card.c	Fri Jan 09 12:16:35 2009 -0800
+++ b/linux/drivers/media/video/zoran/zoran_card.c	Fri Jan 09 12:16:36 2009 -0800
@@ -154,16 +154,13 @@ MODULE_AUTHOR("Serguei Miridonov");
 MODULE_AUTHOR("Serguei Miridonov");
 MODULE_LICENSE("GPL");

-#if (defined(CONFIG_VIDEO_ZORAN_MODULE) && defined(MODULE))
 static struct pci_device_id zr36067_pci_tbl[] = {
-	{PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36057,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_DEVICE(PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36057), },
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, zr36067_pci_tbl);
-#endif
-
-int zoran_num;			/* number of Buzs in use */
+
+atomic_t zoran_num = ATOMIC_INIT(0);		/* number of Buzs in use */
 struct zoran *zoran[BUZ_MAX];

 /* videocodec bus functions ZR36060 */
@@ -1147,7 +1144,7 @@ zr36057_init (struct zoran *zr)
 	strcpy(zr->video_dev->name, ZR_DEVNAME(zr));
 	err = video_register_device(zr->video_dev, VFL_TYPE_GRABBER, video_nr[zr->id]);
 	if (err < 0)
-		goto exit_unregister;
+		goto exit_free;

 	zoran_init_hardware(zr);
 	if (zr36067_debug > 2)
@@ -1162,19 +1159,19 @@ zr36057_init (struct zoran *zr)
 	zr->initialized = 1;
 	return 0;

-exit_unregister:
-	zoran_unregister_i2c(zr);
 exit_free:
 	kfree(zr->stat_com);
 	kfree(zr->video_dev);
 	return err;
 }

-static void
-zoran_release (struct zoran *zr)
-{
+static void __devexit zoran_remove(struct pci_dev *pdev)
+{
+	struct zoran *zr = pci_get_drvdata(pdev);
+
 	if (!zr->initialized)
 		goto exit_free;
+
 	/* unregister videocodec bus */
 	if (zr->codec) {
 		struct videocodec_master *master = zr->codec->master_data;
@@ -1203,6 +1200,7 @@ zoran_release (struct zoran *zr)
 	pci_disable_device(zr->pci_dev);
 	video_unregister_device(zr->video_dev);
 exit_free:
+	pci_set_drvdata(pdev, NULL);
 	kfree(zr);
 }

@@ -1265,323 +1263,330 @@ zoran_setup_videocodec (struct zoran *zr
  *   Scan for a Buz card (actually for the PCI controller ZR36057),
  *   request the irq and map the io memory
  */
-static int __devinit
-find_zr36057 (void)
+static int __devinit zoran_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
 {
 	unsigned char latency, need_latency;
 	struct zoran *zr;
-	struct pci_dev *dev = NULL;
 	int result;
 	struct videocodec_master *master_vfe = NULL;
 	struct videocodec_master *master_codec = NULL;
 	int card_num;
 	char *i2c_enc_name, *i2c_dec_name, *codec_name, *vfe_name;
-
-	zoran_num = 0;
-	while (zoran_num < BUZ_MAX &&
-	       (dev = pci_get_device(PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36057, dev)) != NULL) {
-		card_num = card[zoran_num];
-		zr = kzalloc(sizeof(struct zoran), GFP_KERNEL);
-		if (!zr) {
+	unsigned int nr;
+
+
+	nr = atomic_inc_return(&zoran_num) - 1;
+	if (nr >= BUZ_MAX) {
+		dev_err(&pdev->dev, "driver limited to %d card(s) maximum\n", BUZ_MAX);
+		return -ENOENT;
+	}
+
+	card_num = card[nr];
+	zr = kzalloc(sizeof(struct zoran), GFP_KERNEL);
+	if (!zr) {
+		dprintk(1,
+			KERN_ERR
+			"%s: find_zr36057() - kzalloc failed\n",
+			ZORAN_NAME);
+		/* The entry in zoran[] gets leaked */
+		return -ENOMEM;
+	}
+	zr->pci_dev = pdev;
+	zr->id = nr;
+	snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)), "MJPEG[%u]", zr->id);
+	spin_lock_init(&zr->spinlock);
+	mutex_init(&zr->resource_lock);
+	if (pci_enable_device(pdev))
+		goto zr_free_mem;
+	zr->zr36057_adr = pci_resource_start(zr->pci_dev, 0);
+	pci_read_config_byte(zr->pci_dev, PCI_CLASS_REVISION, &zr->revision);
+	if (zr->revision < 2) {
+		dprintk(1,
+			KERN_INFO
+			"%s: Zoran ZR36057 (rev %d) irq: %d, memory: 0x%08x.\n",
+			ZR_DEVNAME(zr), zr->revision, zr->pci_dev->irq,
+			zr->zr36057_adr);
+
+		if (card_num == -1) {
 			dprintk(1,
 				KERN_ERR
-				"%s: find_zr36057() - kzalloc failed\n",
-				ZORAN_NAME);
-			continue;
+				"%s: find_zr36057() - no card specified, please use the card=X insmod option\n",
+				ZR_DEVNAME(zr));
+			goto zr_free_mem;
 		}
-		zr->pci_dev = dev;
-		//zr->zr36057_mem = NULL;
-		zr->id = zoran_num;
-		snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)), "MJPEG[%u]", zr->id);
-		spin_lock_init(&zr->spinlock);
-		mutex_init(&zr->resource_lock);
-		if (pci_enable_device(dev))
-			goto zr_free_mem;
-		zr->zr36057_adr = pci_resource_start(zr->pci_dev, 0);
-		pci_read_config_byte(zr->pci_dev, PCI_CLASS_REVISION,
-				     &zr->revision);
-		if (zr->revision < 2) {
-			dprintk(1,
-				KERN_INFO
-				"%s: Zoran ZR36057 (rev %d) irq: %d, memory: 0x%08x.\n",
-				ZR_DEVNAME(zr), zr->revision, zr->pci_dev->irq,
-				zr->zr36057_adr);
-
-			if (card_num == -1) {
+	} else {
+		int i;
+		unsigned short ss_vendor, ss_device;
+
+		ss_vendor = zr->pci_dev->subsystem_vendor;
+		ss_device = zr->pci_dev->subsystem_device;
+		dprintk(1,
+			KERN_INFO
+			"%s: Zoran ZR36067 (rev %d) irq: %d, memory: 0x%08x\n",
+			ZR_DEVNAME(zr), zr->revision, zr->pci_dev->irq,
+			zr->zr36057_adr);
+		dprintk(1,
+			KERN_INFO
+			"%s: subsystem vendor=0x%04x id=0x%04x\n",
+			ZR_DEVNAME(zr), ss_vendor, ss_device);
+		if (card_num == -1) {
+			dprintk(3,
+				KERN_DEBUG
+				"%s: find_zr36057() - trying to autodetect card type\n",
+				ZR_DEVNAME(zr));
+			for (i=0;i<NUM_CARDS;i++) {
+				if (ss_vendor == zoran_cards[i].vendor_id &&
+				    ss_device == zoran_cards[i].device_id) {
+					dprintk(3,
+						KERN_DEBUG
+						"%s: find_zr36057() - card %s detected\n",
+						ZR_DEVNAME(zr),
+						zoran_cards[i].name);
+					card_num = i;
+					break;
+				}
+			}
+			if (i == NUM_CARDS) {
 				dprintk(1,
 					KERN_ERR
-					"%s: find_zr36057() - no card specified, please use the card=X insmod option\n",
+					"%s: find_zr36057() - unknown card\n",
 					ZR_DEVNAME(zr));
 				goto zr_free_mem;
 			}
-		} else {
-			int i;
-			unsigned short ss_vendor, ss_device;
-
-			ss_vendor = zr->pci_dev->subsystem_vendor;
-			ss_device = zr->pci_dev->subsystem_device;
-			dprintk(1,
-				KERN_INFO
-				"%s: Zoran ZR36067 (rev %d) irq: %d, memory: 0x%08x\n",
-				ZR_DEVNAME(zr), zr->revision, zr->pci_dev->irq,
-				zr->zr36057_adr);
-			dprintk(1,
-				KERN_INFO
-				"%s: subsystem vendor=0x%04x id=0x%04x\n",
-				ZR_DEVNAME(zr), ss_vendor, ss_device);
-			if (card_num == -1) {
-				dprintk(3,
-					KERN_DEBUG
-					"%s: find_zr36057() - trying to autodetect card type\n",
-					ZR_DEVNAME(zr));
-				for (i=0;i<NUM_CARDS;i++) {
-					if (ss_vendor == zoran_cards[i].vendor_id &&
-					    ss_device == zoran_cards[i].device_id) {
-						dprintk(3,
-							KERN_DEBUG
-							"%s: find_zr36057() - card %s detected\n",
-							ZR_DEVNAME(zr),
-							zoran_cards[i].name);
-						card_num = i;
-						break;
-					}
-				}
-				if (i == NUM_CARDS) {
-					dprintk(1,
-						KERN_ERR
-						"%s: find_zr36057() - unknown card\n",
-						ZR_DEVNAME(zr));
-					goto zr_free_mem;
-				}
-			}
 		}
-
-		if (card_num < 0 || card_num >= NUM_CARDS) {
-			dprintk(2,
-				KERN_ERR
-				"%s: find_zr36057() - invalid cardnum %d\n",
-				ZR_DEVNAME(zr), card_num);
-			goto zr_free_mem;
-		}
-
-		/* even though we make this a non pointer and thus
-		 * theoretically allow for making changes to this struct
-		 * on a per-individual card basis at runtime, this is
-		 * strongly discouraged. This structure is intended to
-		 * keep general card information, no settings or anything */
-		zr->card = zoran_cards[card_num];
-		snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)),
-			 "%s[%u]", zr->card.name, zr->id);
-
-		zr->zr36057_mem = ioremap_nocache(zr->zr36057_adr, 0x1000);
-		if (!zr->zr36057_mem) {
+	}
+
+	if (card_num < 0 || card_num >= NUM_CARDS) {
+		dprintk(2,
+			KERN_ERR
+			"%s: find_zr36057() - invalid cardnum %d\n",
+			ZR_DEVNAME(zr), card_num);
+		goto zr_free_mem;
+	}
+
+	/* even though we make this a non pointer and thus
+	 * theoretically allow for making changes to this struct
+	 * on a per-individual card basis at runtime, this is
+	 * strongly discouraged. This structure is intended to
+	 * keep general card information, no settings or anything */
+	zr->card = zoran_cards[card_num];
+	snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)),
+		 "%s[%u]", zr->card.name, zr->id);
+
+	zr->zr36057_mem = ioremap_nocache(zr->zr36057_adr, 0x1000);
+	if (!zr->zr36057_mem) {
+		dprintk(1,
+			KERN_ERR
+			"%s: find_zr36057() - ioremap failed\n",
+			ZR_DEVNAME(zr));
+		goto zr_free_mem;
+	}
+
+	result = request_irq(zr->pci_dev->irq, zoran_irq,
+			     IRQF_SHARED | IRQF_DISABLED, ZR_DEVNAME(zr), zr);
+	if (result < 0) {
+		if (result == -EINVAL) {
 			dprintk(1,
 				KERN_ERR
-				"%s: find_zr36057() - ioremap failed\n",
+				"%s: find_zr36057() - bad irq number or handler\n",
 				ZR_DEVNAME(zr));
-			goto zr_free_mem;
-		}
-
-		result = request_irq(zr->pci_dev->irq,
-				     zoran_irq,
-				     IRQF_SHARED | IRQF_DISABLED,
-				     ZR_DEVNAME(zr),
-				     (void *) zr);
-		if (result < 0) {
-			if (result == -EINVAL) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - bad irq number or handler\n",
-					ZR_DEVNAME(zr));
-			} else if (result == -EBUSY) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - IRQ %d busy, change your PnP config in BIOS\n",
-					ZR_DEVNAME(zr), zr->pci_dev->irq);
-			} else {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - can't assign irq, error code %d\n",
-					ZR_DEVNAME(zr), result);
-			}
-			goto zr_unmap;
-		}
-
-		/* set PCI latency timer */
-		pci_read_config_byte(zr->pci_dev, PCI_LATENCY_TIMER,
-				     &latency);
-		need_latency = zr->revision > 1 ? 32 : 48;
-		if (latency != need_latency) {
-			dprintk(2,
-				KERN_INFO
-				"%s: Changing PCI latency from %d to %d.\n",
-				ZR_DEVNAME(zr), latency, need_latency);
-			pci_write_config_byte(zr->pci_dev,
-					      PCI_LATENCY_TIMER,
-					      need_latency);
-		}
-
-		zr36057_restart(zr);
-		/* i2c */
-		dprintk(2, KERN_INFO "%s: Initializing i2c bus...\n",
-			ZR_DEVNAME(zr));
-
-		/* i2c decoder */
-		if (decoder[zr->id] != -1) {
-			i2c_dec_name = i2cid_to_modulename(decoder[zr->id]);
-			zr->card.i2c_decoder = decoder[zr->id];
-		} else if (zr->card.i2c_decoder != 0) {
-			i2c_dec_name =
-				i2cid_to_modulename(zr->card.i2c_decoder);
-		} else {
-			i2c_dec_name = NULL;
-		}
-
-		if (i2c_dec_name) {
-			if ((result = request_module(i2c_dec_name)) < 0) {
-				dprintk(1,
-					KERN_ERR
-					"%s: failed to load module %s: %d\n",
-					ZR_DEVNAME(zr), i2c_dec_name, result);
-			}
-		}
-
-		/* i2c encoder */
-		if (encoder[zr->id] != -1) {
-			i2c_enc_name = i2cid_to_modulename(encoder[zr->id]);
-			zr->card.i2c_encoder = encoder[zr->id];
-		} else if (zr->card.i2c_encoder != 0) {
-			i2c_enc_name =
-				i2cid_to_modulename(zr->card.i2c_encoder);
-		} else {
-			i2c_enc_name = NULL;
-		}
-
-		if (i2c_enc_name) {
-			if ((result = request_module(i2c_enc_name)) < 0) {
-				dprintk(1,
-					KERN_ERR
-					"%s: failed to load module %s: %d\n",
-					ZR_DEVNAME(zr), i2c_enc_name, result);
-			}
-		}
-
-		if (zoran_register_i2c(zr) < 0) {
+		} else if (result == -EBUSY) {
 			dprintk(1,
 				KERN_ERR
-				"%s: find_zr36057() - can't initialize i2c bus\n",
+				"%s: find_zr36057() - IRQ %d busy, change your PnP config in BIOS\n",
+				ZR_DEVNAME(zr), zr->pci_dev->irq);
+		} else {
+			dprintk(1,
+				KERN_ERR
+				"%s: find_zr36057() - can't assign irq, error code %d\n",
+				ZR_DEVNAME(zr), result);
+		}
+		goto zr_unmap;
+	}
+
+	/* set PCI latency timer */
+	pci_read_config_byte(zr->pci_dev, PCI_LATENCY_TIMER,
+			     &latency);
+	need_latency = zr->revision > 1 ? 32 : 48;
+	if (latency != need_latency) {
+		dprintk(2,
+			KERN_INFO
+			"%s: Changing PCI latency from %d to %d\n",
+			ZR_DEVNAME(zr), latency, need_latency);
+		pci_write_config_byte(zr->pci_dev, PCI_LATENCY_TIMER,
+				      need_latency);
+	}
+
+	zr36057_restart(zr);
+	/* i2c */
+	dprintk(2, KERN_INFO "%s: Initializing i2c bus...\n",
+		ZR_DEVNAME(zr));
+
+	/* i2c decoder */
+	if (decoder[zr->id] != -1) {
+		i2c_dec_name = i2cid_to_modulename(decoder[zr->id]);
+		zr->card.i2c_decoder = decoder[zr->id];
+	} else if (zr->card.i2c_decoder != 0) {
+		i2c_dec_name = i2cid_to_modulename(zr->card.i2c_decoder);
+	} else {
+		i2c_dec_name = NULL;
+	}
+
+	if (i2c_dec_name) {
+		if ((result = request_module(i2c_dec_name)) < 0) {
+			dprintk(1,
+				KERN_ERR
+				"%s: failed to load module %s: %d\n",
+				ZR_DEVNAME(zr), i2c_dec_name, result);
+		}
+	}
+
+	/* i2c encoder */
+	if (encoder[zr->id] != -1) {
+		i2c_enc_name = i2cid_to_modulename(encoder[zr->id]);
+		zr->card.i2c_encoder = encoder[zr->id];
+	} else if (zr->card.i2c_encoder != 0) {
+		i2c_enc_name = i2cid_to_modulename(zr->card.i2c_encoder);
+	} else {
+		i2c_enc_name = NULL;
+	}
+
+	if (i2c_enc_name) {
+		if ((result = request_module(i2c_enc_name)) < 0) {
+			dprintk(1,
+				KERN_ERR
+				"%s: failed to load module %s: %d\n",
+				ZR_DEVNAME(zr), i2c_enc_name, result);
+		}
+	}
+
+	if (zoran_register_i2c(zr) < 0) {
+		dprintk(1,
+			KERN_ERR
+			"%s: find_zr36057() - can't initialize i2c bus\n",
+			ZR_DEVNAME(zr));
+		goto zr_free_irq;
+	}
+
+	dprintk(2,
+		KERN_INFO "%s: Initializing videocodec bus...\n",
+		ZR_DEVNAME(zr));
+
+	if (zr->card.video_codec != 0 &&
+	    (codec_name = codecid_to_modulename(zr->card.video_codec)) != NULL) {
+		if ((result = request_module(codec_name)) < 0) {
+			dprintk(1,
+				KERN_ERR
+				"%s: failed to load modules %s: %d\n",
+				ZR_DEVNAME(zr), codec_name, result);
+		}
+	}
+	if (zr->card.video_vfe != 0 &&
+	    (vfe_name = codecid_to_modulename(zr->card.video_vfe)) != NULL) {
+		if ((result = request_module(vfe_name)) < 0) {
+			dprintk(1,
+				KERN_ERR
+				"%s: failed to load modules %s: %d\n",
+				ZR_DEVNAME(zr), vfe_name, result);
+		}
+	}
+
+	/* reset JPEG codec */
+	jpeg_codec_sleep(zr, 1);
+	jpeg_codec_reset(zr);
+	/* video bus enabled */
+	/* display codec revision */
+	if (zr->card.video_codec != 0) {
+		master_codec = zoran_setup_videocodec(zr, zr->card.video_codec);
+		if (!master_codec)
+			goto zr_unreg_i2c;
+		zr->codec = videocodec_attach(master_codec);
+		if (!zr->codec) {
+			dprintk(1,
+				KERN_ERR
+				"%s: find_zr36057() - no codec found\n",
 				ZR_DEVNAME(zr));
-			goto zr_free_irq;
+			goto zr_free_codec;
 		}
-
-		dprintk(2,
-			KERN_INFO "%s: Initializing videocodec bus...\n",
+		if (zr->codec->type != zr->card.video_codec) {
+			dprintk(1,
+				KERN_ERR
+				"%s: find_zr36057() - wrong codec\n",
+				ZR_DEVNAME(zr));
+			goto zr_detach_codec;
+		}
+	}
+	if (zr->card.video_vfe != 0) {
+		master_vfe = zoran_setup_videocodec(zr, zr->card.video_vfe);
+		if (!master_vfe)
+			goto zr_detach_codec;
+		zr->vfe = videocodec_attach(master_vfe);
+		if (!zr->vfe) {
+			dprintk(1,
+				KERN_ERR
+				"%s: find_zr36057() - no VFE found\n",
+				ZR_DEVNAME(zr));
+			goto zr_free_vfe;
+		}
+		if (zr->vfe->type != zr->card.video_vfe) {
+			dprintk(1,
+				KERN_ERR
+				"%s: find_zr36057() = wrong VFE\n",
+				ZR_DEVNAME(zr));
+			goto zr_detach_vfe;
+		}
+	}
+	zoran[nr] = zr;
+
+	/* take care of Natoma chipset and a revision 1 zr36057 */
+	if ((pci_pci_problems & PCIPCI_NATOMA) && zr->revision <= 1) {
+		zr->jpg_buffers.need_contiguous = 1;
+		dprintk(1,
+			KERN_INFO
+			"%s: ZR36057/Natoma bug, max. buffer size is 128K\n",
 			ZR_DEVNAME(zr));
-
-		if (zr->card.video_codec != 0 &&
-		    (codec_name =
-		     codecid_to_modulename(zr->card.video_codec)) != NULL) {
-			if ((result = request_module(codec_name)) < 0) {
-				dprintk(1,
-					KERN_ERR
-					"%s: failed to load modules %s: %d\n",
-					ZR_DEVNAME(zr), codec_name, result);
-			}
-		}
-		if (zr->card.video_vfe != 0 &&
-		    (vfe_name =
-		     codecid_to_modulename(zr->card.video_vfe)) != NULL) {
-			if ((result = request_module(vfe_name)) < 0) {
-				dprintk(1,
-					KERN_ERR
-					"%s: failed to load modules %s: %d\n",
-					ZR_DEVNAME(zr), vfe_name, result);
-			}
-		}
-
-		/* reset JPEG codec */
-		jpeg_codec_sleep(zr, 1);
-		jpeg_codec_reset(zr);
-		/* video bus enabled */
-		/* display codec revision */
-		if (zr->card.video_codec != 0) {
-			master_codec = zoran_setup_videocodec(zr,
-							      zr->card.video_codec);
-			if (!master_codec)
-				goto zr_unreg_i2c;
-			zr->codec = videocodec_attach(master_codec);
-			if (!zr->codec) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - no codec found\n",
-					ZR_DEVNAME(zr));
-				goto zr_free_codec;
-			}
-			if (zr->codec->type != zr->card.video_codec) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - wrong codec\n",
-					ZR_DEVNAME(zr));
-				goto zr_detach_codec;
-			}
-		}
-		if (zr->card.video_vfe != 0) {
-			master_vfe = zoran_setup_videocodec(zr,
-							    zr->card.video_vfe);
-			if (!master_vfe)
-				goto zr_detach_codec;
-			zr->vfe = videocodec_attach(master_vfe);
-			if (!zr->vfe) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() - no VFE found\n",
-					ZR_DEVNAME(zr));
-				goto zr_free_vfe;
-			}
-			if (zr->vfe->type != zr->card.video_vfe) {
-				dprintk(1,
-					KERN_ERR
-					"%s: find_zr36057() = wrong VFE\n",
-					ZR_DEVNAME(zr));
-				goto zr_detach_vfe;
-			}
-		}
-		/* Success so keep the pci_dev referenced */
-		pci_dev_get(zr->pci_dev);
-		zoran[zoran_num++] = zr;
-		continue;
-
-		// Init errors
-	      zr_detach_vfe:
-		videocodec_detach(zr->vfe);
-	      zr_free_vfe:
-		kfree(master_vfe);
-	      zr_detach_codec:
-		videocodec_detach(zr->codec);
-	      zr_free_codec:
-		kfree(master_codec);
-	      zr_unreg_i2c:
-		zoran_unregister_i2c(zr);
-	      zr_free_irq:
-		btwrite(0, ZR36057_SPGPPCR);
-		free_irq(zr->pci_dev->irq, zr);
-	      zr_unmap:
-		iounmap(zr->zr36057_mem);
-	      zr_free_mem:
-		kfree(zr);
-		continue;
-	}
-	if (dev)	/* Clean up ref count on early exit */
-		pci_dev_put(dev);
-
-	if (zoran_num == 0) {
-		dprintk(1, KERN_INFO "No known MJPEG cards found.\n");
-	}
-	return zoran_num;
-}
-
-static int __init
-init_dc10_cards (void)
+	}
+
+	if (zr36057_init(zr) < 0)
+		goto zr_detach_vfe;
+
+	zoran_proc_init(zr);
+
+	pci_set_drvdata(pdev, zr);
+
+	return 0;
+
+	// Init errors
+      zr_detach_vfe:
+	videocodec_detach(zr->vfe);
+      zr_free_vfe:
+	kfree(master_vfe);
+      zr_detach_codec:
+	videocodec_detach(zr->codec);
+      zr_free_codec:
+	kfree(master_codec);
+      zr_unreg_i2c:
+	zoran_unregister_i2c(zr);
+      zr_free_irq:
+	btwrite(0, ZR36057_SPGPPCR);
+	free_irq(zr->pci_dev->irq, zr);
+      zr_unmap:
+	iounmap(zr->zr36057_mem);
+      zr_free_mem:
+	kfree(zr);
+
+	return -ENODEV;
+}
+
+static struct pci_driver zoran_driver = {
+	.name = "zr36067",
+	.id_table = zr36067_pci_tbl,
+	.probe = zoran_probe,
+	.remove = zoran_remove,
+};
+
+static int __init zoran_init(void)
 {
 	int i;

@@ -1589,14 +1594,6 @@ init_dc10_cards (void)
 	printk(KERN_INFO "Zoran MJPEG board driver version %d.%d.%d\n",
 	       MAJOR_VERSION, MINOR_VERSION, RELEASE_VERSION);

-	/* Look for cards */
-	if (find_zr36057() < 0) {
-		return -EIO;
-	}
-	if (zoran_num == 0)
-		return -ENODEV;
-	dprintk(1, KERN_INFO "%s: %d card(s) found\n", ZORAN_NAME,
-		zoran_num);
 	/* check the parameters we have been given, adjust if necessary */
 	if (v4l_nbufs < 2)
 		v4l_nbufs = 2;
@@ -1638,37 +1635,32 @@ init_dc10_cards (void)
 			ZORAN_NAME);
 	}

-	/* take care of Natoma chipset and a revision 1 zr36057 */
-	for (i = 0; i < zoran_num; i++) {
-		struct zoran *zr = zoran[i];
-
-		if ((pci_pci_problems & PCIPCI_NATOMA) && zr->revision <= 1) {
-			zr->jpg_buffers.need_contiguous = 1;
-			dprintk(1,
-				KERN_INFO
-				"%s: ZR36057/Natoma bug, max. buffer size is 128K\n",
-				ZR_DEVNAME(zr));
-		}
-
-		if (zr36057_init(zr) < 0) {
-			for (i = 0; i < zoran_num; i++)
-				zoran_release(zoran[i]);
-			return -EIO;
-		}
-		zoran_proc_init(zr);
+	i = pci_register_driver(&zoran_driver);
+	if (i) {
+		dprintk(1,
+			KERN_ERR
+			"%s: Unable to register ZR36057 driver\n",
+			ZORAN_NAME);
+		return i;
 	}

 	return 0;
 }

-static void __exit
-unload_dc10_cards (void)
-{
-	int i;
-
-	for (i = 0; i < zoran_num; i++)
-		zoran_release(zoran[i]);
-}
-
-module_init(init_dc10_cards);
-module_exit(unload_dc10_cards);
+static void __exit zoran_exit(void)
+{
+	pci_unregister_driver(&zoran_driver);
+}
+
+module_init(zoran_init);
+module_exit(zoran_exit);
+
+/*
+todo:
+	use pci ioremap functions
+
+	use id table to provide card type
+
+	get rid of zoran[] array
+*/
+
diff -r f9b51cde3080 -r fdc7c04dd10d linux/drivers/media/video/zoran/zoran_card.h
--- a/linux/drivers/media/video/zoran/zoran_card.h	Fri Jan 09 12:16:35 2009 -0800
+++ b/linux/drivers/media/video/zoran/zoran_card.h	Fri Jan 09 12:16:36 2009 -0800
@@ -40,7 +40,7 @@ extern int zr36067_debug;

 /* Anybody who uses more than four? */
 #define BUZ_MAX 4
-extern int zoran_num;
+extern atomic_t zoran_num;
 extern struct zoran *zoran[BUZ_MAX];

 extern struct video_device zoran_template;
diff -r f9b51cde3080 -r fdc7c04dd10d linux/drivers/media/video/zoran/zoran_driver.c
--- a/linux/drivers/media/video/zoran/zoran_driver.c	Fri Jan 09 12:16:35 2009 -0800
+++ b/linux/drivers/media/video/zoran/zoran_driver.c	Fri Jan 09 12:16:36 2009 -0800
@@ -1271,7 +1271,7 @@ zoran_open(struct file  *file)

 	lock_kernel();
 	/* find the device */
-	for (i = 0; i < zoran_num; i++) {
+	for (i = 0; i < atomic_read(&zoran_num); i++) {
 		if (zoran[i]->video_dev->minor == minor) {
 			zr = zoran[i];
 			break;
