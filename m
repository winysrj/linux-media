Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39288 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab0BPHxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 02:53:25 -0500
Received: by ewy19 with SMTP id 19so4008902ewy.21
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 23:53:23 -0800 (PST)
Date: Tue, 16 Feb 2010 16:53:36 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and =?UTF-8?B?w4PCjsOCwrxQRDYxMTUx?= MPEG2 coder
Message-ID: <20100216165336.62ea3a4d@glory.loctelecom.ru>
In-Reply-To: <201002121644.15896.hverkuil@xs4all.nl>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	<20100129161202.2ecb510a@glory.loctelecom.ru>
	<20100209144150.17fafc52@glory.loctelecom.ru>
	<201002121644.15896.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/7jqGxd0O+t/r1HC4W5d+JY4"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/7jqGxd0O+t/r1HC4W5d+JY4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

Some fixes

> On Tuesday 09 February 2010 06:41:50 Dmitri Belimov wrote:
> > Hi Hans
> >=20
> > This is my last state for review.
> > After small time I'll finish process of initialize the encoder.
> > Configure some register, upload two firmware for video and for
> > audio. Configure the frontends.
> >=20
> > I have the questions.
> > For configuring audio frontend need know samplerate of audio.
> > saa7134 can only 32kHz
> > saa7131/3/5 on I2S 32=D0=BA=D0=93=D1=86 from SIF source and 32/44.1/48 =
from
> > external i.e. RCA stereo audio input.=20
> >=20
> > Hardcode 32kHz or need a function for determine mode of audio??
>=20
> See struct v4l2_subdev_audio_ops: it has a s_clock_freq op for
> precisely that purpose. The saa7134 should call that whenever it sets
> a new samplerate.

This op is not used in saa7134 sources. Now hardcoded 32kHz.

> >=20
> > Other question. For configure VideoFrontend need know 50 or 60Hz
> > Now I use videomode from h structure. I think more correct detect it
> > on saa7134.
>=20
> Whether it is 50 or 60 Hz depends on the video standard that you
> receive via the s_std core op. Just implement that and when you get a
> new standard you can use something like this: is_60hz =3D (std &
> V4L2_STD_525_60) ? 1 : 0;

I do it, if(std & V4L2_STD_625_50) then ....

This data is not real information about input signal. It's what we set from=
 end-user programm.
But OK, I used it.

> Some more review comments:
>=20
> linux/drivers/media/video/saa7134/saa7134.h:
>=20
> @@ -355,6 +377,10 @@
>         unsigned char           empress_addr;
>         unsigned char           rds_addr;
> =20
> +       /* SPI info */
> +       struct saa7134_software_spi     spi;
> +       struct spi_board_info   spi_conf;
>=20
> Make this a struct spi_board_info *. This struct is too large: it is
> only used in one board but all elements of the board array will
> suddenly get this whole struct increasing the memory footprint
> substantially. In this case you can just make it a pointer, that will
> work just as well.

Yes. I don't know what is more good. Now all config data in saa7134-cards d=
escription.
In your case need move spi_board_info to SPI part of code. We will mix code=
 and data.
For add new cards and devices need edit some files for add configs.
May be it's good in my case.

> +
>         unsigned int            tda9887_conf;
>         unsigned int            tuner_config;
>=20
> linux/drivers/media/video/v4l2-common.c, in v4l2_spi_subdev_init():
>=20
> +       /* initialize name */
> +       snprintf(sd->name, sizeof(sd->name), "%s",
> +               spi->dev.driver->name);
>=20
> Use strlcpy here.

Done

> saa7134-spi.c:
>=20
>=20
> static inline u32 getmiso(struct spi_device *dev)
> {
>         struct saa7134_spi_gpio *sb =3D to_sb(dev);
>         unsigned long status;
>=20
>         status =3D saa7134_get_gpio(sb->controller_data);
>         if ( status & (1 << sb->controller_data->spi.miso))
>                 return 1;
>         else
>                 return 0;
> }
>=20
> Simplify to:
>=20
> static inline u32 getmiso(struct spi_device *dev)
> {
>         struct saa7134_spi_gpio *sb =3D to_sb(dev);
>         u32 status;
>=20
>         status =3D saa7134_get_gpio(sb->controller_data);
>         return !!(status & (1 << sb->controller_data->spi.miso));
> }

Thank you.

> Also note that saa7134_get_gpio should return an u32 since unsigned
> long is 64 bits when compiled on a 64-bit kernel, which is probably
> not what you want.

Done

> saa7134_spi_unregister can be a void function as the result code is
> always 0.

Done
=20
> There seems to be some old stuff in upd61151.h. Please remove what is
> not needed.

Done

> In upd61151.c I highly recommend that all functions will use struct
> v4l2_subdev *sd as argument. Only at the lowest level should you go
> from sd to spi. Among others this allows you to use the standard
> v4l2_info/dbg etc. logging functions.

Done

> Don't use RESULT_SUCCESS. Just return 0.

Done
=20
> Remove upd61151_init. The init op is rarely needed and should in
> general not be used.

Done=20

> Remove those emacs editor comments at the end of the files. That's
> bad practice.

Done
=20
With my best regards, Dmitry.

--MP_/7jqGxd0O+t/r1HC4W5d+JY4
Content-Type: text/x-patch; name=behold_spi.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_spi.diff

diff -r b6b82258cf5e linux/drivers/media/video/saa7134/Makefile
--- a/linux/drivers/media/video/saa7134/Makefile	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/Makefile	Tue Feb 16 10:23:52 2010 +0900
@@ -1,9 +1,9 @@
 
 saa7134-objs :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o	\
 		saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
-		saa7134-video.o saa7134-input.o
+		saa7134-video.o saa7134-input.o saa7134-spi.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o upd61151.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Feb 16 10:23:52 2010 +0900
@@ -4619,6 +4619,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4656,6 +4657,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4695,6 +4697,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -5279,23 +5282,43 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x00860000,
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 0,
-			.amux = LINE1,
+			.gpio = 0x00860000
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+			.gpio = 0x00860000
 		}, {
 			.name = name_svideo,
 			.vmux = 9,
 			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
+			.gpio = 0x00860000
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x00860000
+		},
+		.encoder_type = SAA7134_ENCODER_muPD61151,
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+		.spi = {
+			.cs    = 17,
+			.clock = 18,
+			.mosi  = 23,
+			.miso  = 21,
+			.num_chipselect = 1,
+			.spi_enable = 1,
 		},
 	},
 	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue Feb 16 10:23:52 2010 +0900
@@ -139,6 +139,18 @@
 		break;
 	}
 }
+
+u32 saa7134_get_gpio(struct saa7134_dev *dev)
+{
+	unsigned long status;
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
+	return status;
+}
+
 
 /* ------------------------------------------------------------------ */
 
@@ -1057,12 +1069,42 @@
 
 	saa7134_hwinit2(dev);
 
-	/* load i2c helpers */
+	/* initialize software SPI bus */
+	if (saa7134_boards[dev->board].spi.spi_enable)
+	{
+		dev->spi = saa7134_boards[dev->board].spi;
+
+		/* register SPI master and SPI slave */
+		if (saa7134_spi_register(dev, &saa7134_boards[dev->board].spi_conf))
+			saa7134_boards[dev->board].spi.spi_enable = 0;
+	}
+
+	/* load bus helpers */
 	if (card_is_empress(dev)) {
-		struct v4l2_subdev *sd =
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		struct v4l2_subdev *sd = NULL;
+
+		dev->encoder_type = saa7134_boards[dev->board].encoder_type;
+
+		switch (dev->encoder_type) {
+		case SAA7134_ENCODER_muPD61151:
+		{
+			printk(KERN_INFO "%s: found muPD61151 MPEG encoder\n", dev->name);
+
+			if (saa7134_boards[dev->board].spi.spi_enable)
+				sd = v4l2_spi_new_subdev(&dev->v4l2_dev, dev->spi_adap, &saa7134_boards[dev->board].spi_conf);
+		}
+			break;
+		case SAA7134_ENCODER_SAA6752HS:
+		{
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"saa6752hs", "saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
+		}
+			break;
+		default:
+			printk(KERN_INFO "%s: MPEG encoder is not configured\n", dev->name);
+		    break;
+		}
 
 		if (sd)
 			sd->grp_id = GRP_EMPRESS;
@@ -1139,6 +1181,8 @@
 	return 0;
 
  fail4:
+	if ((card_is_empress(dev)) && (dev->encoder_type == SAA7134_ENCODER_muPD61151))
+		saa7134_spi_unregister(dev);
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
@@ -1412,6 +1456,7 @@
 /* ----------------------------------------------------------- */
 
 EXPORT_SYMBOL(saa7134_set_gpio);
+EXPORT_SYMBOL(saa7134_get_gpio);
 EXPORT_SYMBOL(saa7134_boards);
 
 /* ----------------- for the DMA sound modules --------------- */
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Feb 16 10:23:52 2010 +0900
@@ -30,6 +30,13 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+
+/* ifdef software SPI insert here start */
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/spi/spi_bitbang.h>
+/* ifdef software SPI insert here stop */
 
 #include <asm/io.h>
 
@@ -337,6 +344,21 @@
 	SAA7134_MPEG_TS_SERIAL,
 };
 
+enum saa7134_encoder_type {
+	SAA7134_ENCODER_UNUSED,
+	SAA7134_ENCODER_SAA6752HS,
+	SAA7134_ENCODER_muPD61151,
+};
+
+struct saa7134_software_spi {
+	unsigned char cs:5;
+	unsigned char clock:5;
+	unsigned char mosi:5;
+	unsigned char miso:5;
+	unsigned char num_chipselect:3;
+	unsigned char spi_enable:1;
+};
+
 struct saa7134_board {
 	char                    *name;
 	unsigned int            audio_clock;
@@ -355,6 +377,10 @@
 	unsigned char		empress_addr;
 	unsigned char		rds_addr;
 
+	/* SPI info */
+	struct saa7134_software_spi	spi;
+	struct spi_board_info   spi_conf;
+
 	unsigned int            tda9887_conf;
 	unsigned int            tuner_config;
 
@@ -362,6 +388,7 @@
 	enum saa7134_video_out  video_out;
 	enum saa7134_mpeg_type  mpeg;
 	enum saa7134_mpeg_ts_type ts_type;
+	enum saa7134_encoder_type encoder_type;
 	unsigned int            vid_port_opts;
 	unsigned int            ts_force_val:1;
 };
@@ -506,6 +533,12 @@
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
+struct saa7134_spi_gpio {
+	struct spi_bitbang         bitbang;
+	struct spi_master          *master;
+	struct saa7134_dev         *controller_data;
+};
+
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -553,6 +586,10 @@
 	struct i2c_client          i2c_client;
 	unsigned char              eedata[256];
 	int 			   has_rds;
+
+	/* software spi */
+	struct saa7134_software_spi spi;
+	struct spi_master          *spi_adap;
 
 	/* video overlay */
 	struct v4l2_framebuffer    ovbuf;
@@ -615,6 +652,7 @@
 	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
+	enum saa7134_encoder_type  encoder_type;
 
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 	/* SAA7134_MPEG_DVB only */
@@ -681,6 +719,7 @@
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
+u32 saa7134_get_gpio(struct saa7134_dev *dev);
 
 #define SAA7134_PGTABLE_SIZE 4096
 
@@ -726,6 +765,11 @@
 int saa7134_i2c_register(struct saa7134_dev *dev);
 int saa7134_i2c_unregister(struct saa7134_dev *dev);
 
+/* ----------------------------------------------------------- */
+/* saa7134-spi.c                                               */
+
+int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info);
+void saa7134_spi_unregister(struct saa7134_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* saa7134-video.c                                             */
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Feb 16 10:23:52 2010 +0900
@@ -51,6 +51,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#include <linux/spi/spi.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -1069,6 +1070,66 @@
 
 #endif /* defined(CONFIG_I2C) */
 
+//#if defined(CONFIG_SPI) || (defined(CONFIG_SPI_MODULE) && defined(MODULE)) + SPI_BITBANG
+
+/* Load an spi sub-device. */
+
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
+	/* the owner is the same as the spi_device's driver owner */
+	sd->owner = spi->dev.driver->owner;
+	/* spi_device and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, spi);
+	spi_set_drvdata(spi, sd);
+	/* initialize name */
+	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
+
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct spi_device *spi = NULL;
+
+	BUG_ON(!v4l2_dev);
+
+	if (info->modalias)
+		request_module(info->modalias);
+
+	spi = spi_new_device(master,info);
+
+	if (spi == NULL || spi->dev.driver ==NULL)
+		goto error;
+
+	if (!try_module_get(spi->dev.driver->owner))
+		goto error;
+
+	sd = spi_get_drvdata(spi);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(spi->dev.driver->owner);
+
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+	if (spi && sd == NULL)
+		spi_unregister_device(spi);
+
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
+
+//#endif /* defined(CONFIG_SPI) */
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-device.c
--- a/linux/drivers/media/video/v4l2-device.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-device.c	Tue Feb 16 10:23:52 2010 +0900
@@ -100,6 +100,14 @@
 		}
 #endif
 #endif
+/* FIXME: ADD if def's for SPI subdevices */
+		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
+			struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+			if (spi)
+				spi_unregister_device(spi);
+		}
+
 	}
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
diff -r b6b82258cf5e linux/include/media/v4l2-chip-ident.h
--- a/linux/include/media/v4l2-chip-ident.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-chip-ident.h	Tue Feb 16 10:23:52 2010 +0900
@@ -278,6 +278,11 @@
 	/* module cs53132a: just ident 53132 */
 	V4L2_IDENT_CS53l32A = 53132,
 
+	/* modules upd61151 MPEG2 encoder: just ident 54000 */
+	V4L2_IDENT_UPD61161 = 54000,
+	/* modules upd61152 MPEG2 encoder with AC3: just ident 54001 */
+	V4L2_IDENT_UPD61162 = 54001,
+
 	/* module upd64031a: just ident 64031 */
 	V4L2_IDENT_UPD64031A = 64031,
 
diff -r b6b82258cf5e linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-common.h	Tue Feb 16 10:23:52 2010 +0900
@@ -191,6 +191,25 @@
 
 /* ------------------------------------------------------------------------- */
 
+/* SPI Helper functions */
+
+#include <linux/spi/spi.h>
+
+struct spi_device_id;
+struct spi_device;
+
+/* Load an spi module and return an initialized v4l2_subdev struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info);
+
+/* Initialize an v4l2_subdev with data from an spi_device struct */
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops);
+
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Tue Feb 16 10:23:52 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.

--MP_/7jqGxd0O+t/r1HC4W5d+JY4
Content-Type: text/x-c++src; name=saa7134-spi.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134-spi.c

/*
 *
 * Device driver for philips saa7134 based TV cards
 * SPI software interface support
 *
 * (c) 2009 Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
 *
 *  Important: now support ONLY SPI_MODE_0, see FIXME
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "saa7134-reg.h"
#include "saa7134.h"
#include <media/v4l2-common.h>

/* ----------------------------------------------------------- */

static unsigned int spi_debug;
module_param(spi_debug, int, 0644);
MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");

#define d1printk if (1 == spi_debug) printk
#define d2printk if (2 == spi_debug) printk

static inline void spidelay(unsigned d)
{
	ndelay(d);
}

static inline struct saa7134_spi_gpio *to_sb(struct spi_device *spi)
{
	return spi_master_get_devdata(spi->master);
}

static inline void setsck(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, on ? 1 : 0);
}

static inline void setmosi(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.mosi, on ? 1 : 0);
}

static inline u32 getmiso(struct spi_device *dev)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);
	unsigned long status;

	status = saa7134_get_gpio(sb->controller_data);
	return !!( status & (1 << sb->controller_data->spi.miso));
}

#define EXPAND_BITBANG_TXRX 1
#include <linux/spi/spi_bitbang.h>

static void saa7134_spi_gpio_chipsel(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	if (on)
	{
		/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, 0);
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 0);
	}
	else
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 1);
}

/* Our actual bitbanger routine. */
static u32 saa7134_txrx(struct spi_device *spi, unsigned nsecs, u32 word, u8 bits)
{
	return bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
}

int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info)
{
	struct spi_master *master = NULL;
	struct saa7134_spi_gpio *sb = NULL;
	int ret = 0;

	master = spi_alloc_master(&dev->pci->dev, sizeof(struct saa7134_spi_gpio));

	if (master == NULL) 
	{
		dev_err(&dev->pci->dev, "failed to allocate spi master\n");
		ret = -ENOMEM;
		goto err;
	}

	sb = spi_master_get_devdata(master);

	master->num_chipselect = dev->spi.num_chipselect;
	master->bus_num = -1;
	sb->master = spi_master_get(master);
	sb->bitbang.master = sb->master;
	sb->bitbang.master->bus_num = -1;
	sb->bitbang.master->num_chipselect = dev->spi.num_chipselect;
	sb->bitbang.chipselect = saa7134_spi_gpio_chipsel;
	sb->bitbang.txrx_word[SPI_MODE_0] = saa7134_txrx;

	/* set state of spi pins */
	saa7134_set_gpio(dev, dev->spi.cs, 1);
	/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
	saa7134_set_gpio(dev, dev->spi.clock, 0);
	saa7134_set_gpio(dev, dev->spi.mosi, 1);
	saa7134_set_gpio(dev, dev->spi.miso, 3);

	/* start SPI bitbang master */
	ret = spi_bitbang_start(&sb->bitbang);
	if (ret) {
		dev_err(&dev->pci->dev, "Failed to register SPI master\n");
		goto err_no_bitbang;
	}
	dev_info(&dev->pci->dev,
		"spi master registered: bus_num=%d num_chipselect=%d\n",
		master->bus_num, master->num_chipselect);

	sb->controller_data = dev;
	info->bus_num = sb->master->bus_num;
	info->controller_data = master;
	dev->spi_adap = master;

err_no_bitbang:
	spi_master_put(master);
err:
	return ret;
}

void saa7134_spi_unregister(struct saa7134_dev *dev)
{
	struct saa7134_spi_gpio *sb = spi_master_get_devdata(dev->spi_adap);

	spi_bitbang_stop(&sb->bitbang);
	spi_master_put(sb->master);
}


/*
 * Overrides for Emacs so that we follow Linus's tabbing style.
 * ---------------------------------------------------------------------------
 * Local variables:
 * c-basic-offset: 8
 * End:
 */
 
--MP_/7jqGxd0O+t/r1HC4W5d+JY4
Content-Type: text/x-c++src; name=upd61151.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.c

 /*
    upd61151 - driver for the uPD61151 by NEC

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    Based on the saa6752s.c driver.
    Copyright (C) 2004 Andrew de Quincey

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License vs published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mvss Ave, Cambridge, MA 02139, USA.
  */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/sysfs.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/spi/spi.h>
#include <linux/types.h>
#include "compat.h"
#include <linux/videodev2.h>
#include <media/v4l2-device.h>
#include <media/v4l2-common.h>
#include <media/v4l2-chip-ident.h>
#include <media/upd61151.h>

#include <linux/crc32.h>
#include "saa7134.h"

#define DRVNAME		"upd61151"

static unsigned int spi_debug;
module_param(spi_debug, int, 0644);
MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");

#define d1printk_spi if (1 <= spi_debug) printk
#define d2printk_spi if (2 <= spi_debug) printk

static unsigned int core_debug;
module_param(core_debug, int, 0644);
MODULE_PARM_DESC(core_debug,"enable debug messages [core]");

#define d1printk_core if (1 <= core_debug) printk
#define d2printk_core if (2 <= core_debug) printk

MODULE_DESCRIPTION("device driver for uPD61151 MPEG2 encoder");
MODULE_AUTHOR("Dmitry V Belimov");
MODULE_LICENSE("GPL");

/* Result codes */
#define RESULT_SUCCESS              0
#define RESULT_FAILURE              1
#define STATUS_DEVICE_NOT_READY     2
#define STATUS_DEVICE_DATA_ERROR    3

enum upd61151_videoformat {
	UPD61151_VF_D1 = 0,    /* 720x480/720x576 */
	UPD61151_VF_D2 = 1,    /* 704x480/704x576 */
	UPD61151_VF_D3 = 2,    /* 352x480/352x576 */
	UPD61151_VF_D4 = 3,    /* 352x240/352x288 */
	UPD61151_VF_D5 = 4,    /* 544x480/544x576 */
	UPD61151_VF_D6 = 5,    /* 480x480/480x576 */
	UPD61151_VF_D7 = 6,    /* 352x240/352x288 */
	UPD61151_VF_D8 = 8,    /* 640x480/640x576 */
	UPD61151_VF_D9 = 9,    /* 320x480/320x576 */
	UPD61151_VF_D10 = 10,  /* 320x240/320x288 */
	UPD61151_VF_UNKNOWN,
};

struct upd61151_mpeg_params {
	/* transport streams */
	__u16				ts_pid_pmt;
	__u16				ts_pid_audio;
	__u16				ts_pid_video;
	__u16				ts_pid_pcr;

	/* audio */
	enum v4l2_mpeg_audio_encoding    au_encoding;
	enum v4l2_mpeg_audio_l2_bitrate  au_l2_bitrate;

	/* video */
	enum v4l2_mpeg_video_aspect	vi_aspect;
	enum v4l2_mpeg_video_bitrate_mode vi_bitrate_mode;
	__u32 				vi_bitrate;
	__u32 				vi_bitrate_peak;
};

static const struct v4l2_format v4l2_format_table[] =
{
	[UPD61151_VF_D1] =
		{ .fmt = { .pix = { .width = 720, .height = 576 }}},
	[UPD61151_VF_D2] =
		{ .fmt = { .pix = { .width = 704, .height = 576 }}},
	[UPD61151_VF_D3] =
		{ .fmt = { .pix = { .width = 352, .height = 576 }}},
	[UPD61151_VF_D4] =
		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
	[UPD61151_VF_D5] =
		{ .fmt = { .pix = { .width = 544, .height = 576 }}},
	[UPD61151_VF_D6] =
		{ .fmt = { .pix = { .width = 480, .height = 576 }}},
	[UPD61151_VF_D7] =
		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
	[UPD61151_VF_D8] =
		{ .fmt = { .pix = { .width = 640, .height = 576 }}},
	[UPD61151_VF_D9] =
		{ .fmt = { .pix = { .width = 320, .height = 576 }}},
	[UPD61151_VF_D10] =
		{ .fmt = { .pix = { .width = 320, .height = 288 }}},
	[UPD61151_VF_UNKNOWN] =
		{ .fmt = { .pix = { .width = 0, .height = 0}}},
};

struct upd61151_state {
	struct v4l2_subdev            sd;
	struct upd61151_mpeg_params   params;
	enum upd61151_videoformat     video_format;
	v4l2_std_id                   standard;
	enum upd61151_encode_state    enstate;
};

static struct upd61151_mpeg_params param_defaults =
{
	.ts_pid_pmt      = 16,
	.ts_pid_video    = 260,
	.ts_pid_audio    = 256,
	.ts_pid_pcr      = 259,

	.vi_aspect       = V4L2_MPEG_VIDEO_ASPECT_4x3,
	.vi_bitrate      = 4000,
	.vi_bitrate_peak = 6000,
	.vi_bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,

	.au_encoding     = V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
	.au_l2_bitrate   = V4L2_MPEG_AUDIO_L2_BITRATE_256K,
};

static int write_reg(struct spi_device *spi, u8 address, u8 data)
{
	u8 buf[2];

	buf[0] = ((address >> 2) << 2);
	buf[1] = data;

	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x <= 0x%x\n",spi->modalias,address,data);

	return spi_write(spi, buf, ARRAY_SIZE(buf));
}

static void write_fw(struct spi_device *spi, u8 address, const struct firmware *fw)
{
	u8 buf[2];
	u32 i;

	buf[0] = ((address >> 2) << 2);

	for (i=0; i < fw->size; i++)
	{
		buf[1] = *(fw->data+i);
		spi_write(spi, buf, 2);
	}
}

static int read_reg(struct spi_device *spi, unsigned char address, unsigned char *data)
{
	u8 buf[1];
	int ret;

	ret = 0;
	buf[0] = ((address >> 2) << 2) | 0x02;
	ret = spi_write_then_read(spi, buf, 1, data, 1);

	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x => 0x%x, status %d\n",spi->modalias, address, *data, ret);

	return ret;
}

static u8 upd61151_get_state(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_STATUS, &rbyte);

	d2printk_core(KERN_DEBUG "%s: MPEG2 core status %d\n", spi->modalias, rbyte & 0x07);

	return rbyte & 0x07;
}

static int upd61151_set_state(struct v4l2_subdev *sd, enum upd61151_config nstate)
{
printk("upd61151_set_state\n");
printk("WARNING: The function upd61151_set_state is EMPTY\n");
	return RESULT_SUCCESS;
}

static void upd61151_reset_core(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);

	write_reg(spi, UPD61151_SOFTWARE_RST, 0x01);
}

static void upd61151_set_dest_addr(struct v4l2_subdev *sd, u32 addr)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);

	write_reg(spi, UPD61151_TRANSFER_ADDR1, (u8)((addr >> 16) & 0xFF));
	write_reg(spi, UPD61151_TRANSFER_ADDR2, (u8)((addr >> 8) & 0xFF));
	write_reg(spi, UPD61151_TRANSFER_ADDR3, (u8)(addr & 0xFF));
}

static void upd61151_set_data_size(struct v4l2_subdev *sd, u32 dsize)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);

	write_reg(spi, UPD61151_DATA_COUNTER1, (u8)((dsize >> 16) & 0xFF));
	write_reg(spi, UPD61151_DATA_COUNTER2, (u8)((dsize >> 8) & 0xFF));
	write_reg(spi, UPD61151_DATA_COUNTER3, (u8)(dsize & 0xFF));
}

static u8 upd61151_clear_transfer_irq(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_TRANSFER_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: Transfer IRQ status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_IRQ, rbyte);

	return rbyte;
}

static void upd61151_handle_transfer_err(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte;
printk("upd61151_handle_transfer_err\n");
	/* Set data transfer count size = 1 */
	upd61151_set_data_size(sd, 0x01);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);

	/* Read one byte from SDRAM */
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);

	/* Release transfer mode */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(sd);

	/* Set destination address to 0x000000 */
	upd61151_set_dest_addr(sd, 0x000000);

	/* Set data transfer count size = 3 */
	upd61151_set_data_size(sd, 0x03);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(sd);

	/* Read 3 byte from SDRAM */
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(sd);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(sd);
}

static int upd61151_wait_transfer_irq(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 i, rstatus;

	rstatus = 0;
	/* Wait transfer interrupt */
	for (i=0; i<5; i++)
	{
		rstatus = upd61151_clear_transfer_irq(sd);
		if (rstatus)
			break;
		msleep(1);
	}

	if (!rstatus)
		return STATUS_DEVICE_NOT_READY;

	if (rstatus & 0x04)
	{
		/* Data transfer error */
		upd61151_handle_transfer_err(sd);
		return STATUS_DEVICE_DATA_ERROR;
	}

	return RESULT_SUCCESS;
}

static u8 upd61151_clear_info_irq(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_IRQ, rbyte);

	return rbyte;
}

static u8 upd61151_clear_error_irq(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_ERROR_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ error status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_ERROR_IRQ, rbyte);

	return rbyte;
}

static u8 upd61151_clear_except_irq(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_EXCEPT_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ exception status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_EXCEPT_IRQ, rbyte);

	return rbyte;
}

static int upd61151_load_base_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u32 size;
	const struct firmware *fw;
	int ret = RESULT_SUCCESS;

printk("DEBUG: upd61151_load_base_firmware\n");

	size = UPD61151_DEFAULT_PS_FIRMWARE_SIZE / 4;

	/* request the firmware, this will block and timeout */
	printk(KERN_INFO "%s: waiting for base firmware upload (%s)...\n",
		spi->modalias, UPD61151_DEFAULT_PS_FIRMWARE);

	ret = request_firmware(&fw, UPD61151_DEFAULT_PS_FIRMWARE,
		spi->dev.parent);
	if (ret)
	{
		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	else
		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
		       fw->size);

	if (fw->size != UPD61151_DEFAULT_PS_FIRMWARE_SIZE)
	{
		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	printk(KERN_INFO "%s: base firmware uploading...\n", spi->modalias);

	upd61151_clear_transfer_irq(sd);

	/* CPU reset ON */
	write_reg(spi, UPD61151_SOFTWARE_RST, 0x02);

	/* Set destination address to 0x000000 */
	upd61151_set_dest_addr(sd, 0x000000);

	/* Set transfer data count to firmware size / 4 */
	upd61151_set_data_size(sd, size);

	/* Set transfer mode to Host -> iRAM */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x80);
printk("fw upload start\n");
	write_fw(spi, UPD61151_TRANSFER_DATA, fw);
printk("fw upload stop\n");

	if (upd61151_wait_transfer_irq(sd) == RESULT_SUCCESS)
	{
		/* Release transfer mode */
		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
		printk(KERN_INFO "%s: base firmware upload complete...\n", spi->modalias);
	}
	else
		printk(KERN_INFO "%s: base firmware upload FAIL...\n", spi->modalias);

out:
	/* CPU reset OFF */
	write_reg(spi, UPD61151_SOFTWARE_RST, 0x00);
	release_firmware(fw);
	return ret;
}

static int upd61151_load_audio_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	const struct firmware *fw;
	u32 addr, i;
	int ret = RESULT_SUCCESS;

printk("DEBUG: upd61151_load_audio_firmware\n");

	/* request the firmware, this will block and timeout */
	printk(KERN_INFO "%s: waiting for audio firmware upload (%s)...\n",
		spi->modalias, UPD61151_DEFAULT_AUDIO_FIRMWARE);

	ret = request_firmware(&fw, UPD61151_DEFAULT_AUDIO_FIRMWARE,
		spi->dev.parent);
	if (ret)
	{
		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	else
		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
		       fw->size);

	if (fw->size != UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE)
	{
		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	printk(KERN_INFO "%s: audio firmware uploading...\n", spi->modalias);

	addr = 0x308F00;
	addr >>= 5;

	upd61151_clear_transfer_irq(sd);

	/* Set destination address */
	upd61151_set_dest_addr(sd, addr);

	/* Set transfer data count to firmware size */
	upd61151_set_data_size(sd, UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE);

	/* Set transfer mode to Host -> SDRAM */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x02);

printk("fw upload start\n");

	for (i = 0; i < UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE; i++)
	{
		write_reg(spi, UPD61151_TRANSFER_DATA, *(fw->data+i));

		/* Check Transfer interrupt each 128 bytes */
		if ( ((i+1) % 128) ==0 )
		{
			ret = upd61151_wait_transfer_irq(sd);
			if (ret != RESULT_SUCCESS)
				break;
		}
	}

printk("fw upload stop\n");

	if (ret == RESULT_SUCCESS)
	{
		/* Release transfer mode */
		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
		printk(KERN_INFO "%s: audio firmware upload complete...\n", spi->modalias);
	}
	else
		printk(KERN_INFO "%s: audio firmware upload FAIL...\n", spi->modalias);

out:
	release_firmware(fw);
	return ret;
}

static int upd61151_chip_command(struct v4l2_subdev *sd, enum upd61151_command command)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u8 cycles, wait, i, irqerr;
	enum upd61151_command want_state;

printk("DEBUG uPD61151: upd61151_chip_command\n");

	/* calculate delay */
	cycles = 100;
	wait = 10;

	switch (command)
	{
	case UPD61151_COMMAND_STANDBY_STOP:
	case UPD61151_COMMAND_PAUSE:
		break;

	case UPD61151_COMMAND_START_RESTART:
		cycles = 200;
		wait = 1;
		break;

	default:
		return RESULT_FAILURE;
	}

	/* Clear IRQ */
	upd61151_clear_error_irq(sd);

	write_reg(spi, UPD61151_COMMAND, command);

	for (i=0; i < cycles; i++)
	{
		/* Check state */
		want_state = upd61151_get_state(sd);
		if (want_state == command)
		{
			upd61151_clear_info_irq(sd);
			d2printk_core(KERN_DEBUG "%s: SetState %d SUCCESS, delay [%d ms].\n", spi->modalias, want_state, i*wait);
			return 0;
		}

		/* Check error interrupt */
		irqerr = upd61151_clear_error_irq(sd);

		if (irqerr & 0x01)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Command (IC).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x02)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Parameter (IP).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x04)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Audio Firmware Download (IADL).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x08)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid System Bit Rate (ISBR).\n", spi->modalias, command);
			break;
		}

		msleep(wait);
	}

	if (i >= cycles)
	{
		d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, TIMEOUT [%d ms].\n", spi->modalias, command, cycles*wait);
	}

	return RESULT_FAILURE;
}

static int upd61151_setup_video_frontend(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);
	u8 dbyte;

printk("upd61151_setup_video_frontend\n");

	dbyte = 0x00;
printk("dbyte = 0x%x  ",dbyte);
	/* Update FIDT */
	if (h->standard & V4L2_STD_625_50)
		dbyte |= 0x10;
printk("   0x%x  ",dbyte);
	dbyte |= h->video_format;
printk("   0x%x  \n",dbyte);
	write_reg(spi, UPD61151_VIDEO_ATTRIBUTE, dbyte);

	/* SAV/EAV (ITU-656), FID not inverted */
	write_reg(spi, UPD61151_VIDEO_SYNC, 0x80);

	/* Set H offset */
	write_reg(spi, UPD61151_VIDEO_HOFFSET, 0x00);

	/* Set V offset */
	if (h->standard & V4L2_STD_625_50)
		dbyte = 0x01;
	else
		dbyte = 0x03;
	write_reg(spi, UPD61151_VIDEO_VOFFSET, dbyte);

	/* Setup VBI */
	/* SLCEN = 0, VBIOFFV = 4, VBIOFFH = 8*/
	write_reg(spi, UPD61151_VBI_ADJ1, 0x48);

	return 0;
}

static int upd61151_setup_audio_frontend(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);

printk("upd61151_setup_audio_frontend\n");
	/* Setup AUDIO attribute 1 */
	/* FIXME: hardcoded samplerate of audio to 32kHz */
	/* default bitrate is 256Kbit */
	write_reg(spi, UPD61151_AUDIO_ATTRIBUTE1, 0x29);

	/* PLLs = internal, AMCLK = 384fs, AQ = 16bit & 64bck, APCMI = I2S, APCMO = OFF*/
	write_reg(spi, UPD61151_AUDIO_INTERFACE, 0x5B);
	return 0;
}

static int upd61151_config_encoder(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

printk("upd61151_config_encoder\n");
printk("WARNING: The function upd61151_config_encoder is EMPTY\n");

	return 0;
}

static int upd61151_download_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

printk("DEBUG: upd61151_download_firmware\n");
	h->enstate = UPD61151_ENCODE_STATE_IDLE;

	upd61151_reset_core(sd);

	udelay(1);

	/* Init SDRAM */
	write_reg(spi, UPD61151_SDRAM_IF_DELAY_ADJ, 0x01);
	write_reg(spi, UPD61151_SDRAM_FCLK_SEL, 0xA0);

	udelay(200);

	/* Set SDRAM to STANDBY */
	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x01);

	udelay(10);

	/* Release SDRAM from STANDBY */
	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x00);

	if (upd61151_load_base_firmware(sd))
		return RESULT_FAILURE;

	if (upd61151_load_audio_firmware(sd))
		return RESULT_FAILURE;

	/* Clear IRQ flags */
	if ( !(upd61151_clear_info_irq(sd) & 0x10) )
	{
		/* INICM not running */
		d1printk_core(KERN_DEBUG "%s: download firmware FAILED. INICM is not run.\n", spi->modalias);
		return RESULT_FAILURE;
	}

	/* Set STANDBY state */
	if (upd61151_chip_command(sd, UPD61151_COMMAND_STANDBY_STOP))
		return RESULT_FAILURE;

	/* Setup video input frontend */
	upd61151_setup_video_frontend(sd);

	/* Setup audio input frontend */
	upd61151_setup_audio_frontend(sd);

	/* Config encoder params */
	upd61151_config_encoder(sd);

	/* Set all config and upload audio firmware */
	if (upd61151_set_state(sd, UPD61151_CONFIG_ALL))
		return RESULT_FAILURE;

	/* Return to STANDBY state */
	if (upd61151_chip_command(sd, UPD61151_COMMAND_STANDBY_STOP))
		return RESULT_FAILURE;

	return 0;
}

static int upd61151_is_need_reload_fw(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);

	if (upd61151_get_state(sd) == UPD61151_COMMAND_INITIAL)
	{
		d1printk_core(KERN_DEBUG "%s: need reload firmware\n", spi->modalias);
		return 1;
	}

	if (upd61151_clear_except_irq(sd) & 0x04)
	{
		d1printk_core(KERN_DEBUG "%s: mainly buffer of encoder is overflowed\n", spi->modalias);
		return 1;
	}

	return 0;
}

static int upd61151_set_bitrate(struct v4l2_subdev *sd,
				 struct upd61151_state *h)
{
printk("DEBUG uPD61151: upd61151_set_bitrate\n");
printk("WARNING: The function upd61151_set_bitrate is EMPTY\n");
	return 0;
}

static int upd61151_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
{
printk("DEBUG uPD61151: upd61151_queryctrl\n");
printk("WARNING: The function upd61151_queryctrl is EMPTY\n");
	return 0;
}

static int upd61151_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qmenu)
{
printk("DEBUG uPD61151: upd61151_querymenu\n");
printk("WARNING: The function upd61151_querymenu is EMPTY\n");
	return 0;
}

static int upd61151_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls, int set)
{
printk("DEBUG uPD61151: upd61151_do_ext_ctrls\n");
printk("WARNING: The function upd61151_do_ext_ctrls is EMPTY\n");
	return 0;
}

static int upd61151_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 1);
}

static int upd61151_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 0);
}

static int upd61151_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_g_ext_ctrls\n");
printk("WARNING: The function upd61151_g_ext_ctrls is EMPTY\n");
	return 0;
}

static int upd61151_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

	if (h->video_format == UPD61151_VF_UNKNOWN)
		h->video_format = UPD61151_VF_D1;
	f->fmt.pix.width =
		v4l2_format_table[h->video_format].fmt.pix.width;
	f->fmt.pix.height =
		v4l2_format_table[h->video_format].fmt.pix.height;

printk("DEBUG uPD61151: upd61151_g_fmt\n");
	return 0;
}

static int upd61151_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

printk("DEBUG uPD61151: upd61151_s_fmt\n");

	if (f->fmt.pix.width <= 320)
	{
		if (f->fmt.pix.height <= 288)
		{
			f->fmt.pix.width = 320;
			f->fmt.pix.height = 288;
			h->video_format = UPD61151_VF_D10;
			return 0;
		}
		else
		{
			f->fmt.pix.width = 320;
			f->fmt.pix.height = 576;
			h->video_format = UPD61151_VF_D9;
			return 0;
		}
	}

	if (f->fmt.pix.width <= 352)
	{
		if (f->fmt.pix.height <= 288)
		{
			f->fmt.pix.width = 352;
			f->fmt.pix.height = 288;
			h->video_format = UPD61151_VF_D4;
			return 0;
		}
		else
		{
			f->fmt.pix.width = 352;
			f->fmt.pix.height = 576;
			h->video_format = UPD61151_VF_D3;
			return 0;
		}
	}

	if (f->fmt.pix.width <= 480)
	{
		f->fmt.pix.width = 480;
		f->fmt.pix.height = 576;
		h->video_format = UPD61151_VF_D6;
		return 0;
	}

	if (f->fmt.pix.width <= 544)
	{
		f->fmt.pix.width = 544;
		f->fmt.pix.height = 576;
		h->video_format = UPD61151_VF_D5;
		return 0;
	}

	if (f->fmt.pix.width <= 640)
	{
		f->fmt.pix.width = 640;
		f->fmt.pix.height = 576;
		h->video_format = UPD61151_VF_D8;
		return 0;
	}

	if (f->fmt.pix.width <= 704)
	{
		f->fmt.pix.width = 704;
		f->fmt.pix.height = 576;
		h->video_format = UPD61151_VF_D2;
		return 0;
	}

	f->fmt.pix.width = 720;
	f->fmt.pix.height = 576;
	h->video_format = UPD61151_VF_D1;
	return 0;
}

static int upd61151_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);
printk("DEBUG uPD61151: upd61151_s_std\n");
	h->standard = std;
	return 0;
}

static int upd61151_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
{
printk("DEBUG uPD61151: upd61151_g_chip_ident\n");
	chip->ident	= V4L2_IDENT_UPD61161;
	chip->revision	= 0;

	return 0;
}

/* ----------------------------------------------------------------------- */

static const struct v4l2_subdev_core_ops upd61151_core_ops = {
	.g_chip_ident = upd61151_g_chip_ident,
	.queryctrl = upd61151_queryctrl,
	.querymenu = upd61151_querymenu,
	.g_ext_ctrls = upd61151_g_ext_ctrls,
	.s_ext_ctrls = upd61151_s_ext_ctrls,
	.try_ext_ctrls = upd61151_try_ext_ctrls,
	.s_std = upd61151_s_std,
};

static const struct v4l2_subdev_video_ops upd61151_video_ops = {
	.s_fmt = upd61151_s_fmt,
	.g_fmt = upd61151_g_fmt,
};

static const struct v4l2_subdev_ops upd61151_ops = {
	.core = &upd61151_core_ops,
	.video = &upd61151_video_ops,
};

static int __devinit upd61151_probe(struct spi_device *spi)
{
	struct upd61151_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
	struct v4l2_subdev *sd;

printk("upd61151_probe function\n");

	if (h == NULL)
		return -ENOMEM;
	sd = &h->sd;

	v4l2_spi_subdev_init(sd, spi, &upd61151_ops);

	spi_set_drvdata(spi, h);

	if (upd61151_is_need_reload_fw(sd))
	{
		printk("Start load firmware...\n");
		if (!upd61151_download_firmware(sd))
			printk("Firmware downloaded SUCCESS!!!\n");
		else
			printk("Firmware downloaded FAIL!!!\n");
	}
	else
		printk("Firmware is OK\n");

	h->params = param_defaults;
	h->standard = 0; /* Assume 625 input lines */
	return 0;
}

static int __devexit upd61151_remove(struct spi_device *spi)
{
	struct upd61151_state *h = spi_get_drvdata(spi);
printk("upd61151_remove function\n");
	v4l2_device_unregister_subdev(&h->sd);
//	kfree(&h->sd);
	kfree(h);
	spi_unregister_device(spi);
	return 0;
}

static struct spi_driver upd61151_driver = {
	.driver = {
		.name   = DRVNAME,
		.bus    = &spi_bus_type,
		.owner  = THIS_MODULE,
	},
	.probe = upd61151_probe,
	.remove = __devexit_p(upd61151_remove),
};


static int __init init_upd61151(void)
{
	return spi_register_driver(&upd61151_driver);
}
module_init(init_upd61151);

static void __exit exit_upd61151(void)
{
	spi_unregister_driver(&upd61151_driver);
}
module_exit(exit_upd61151);

--MP_/7jqGxd0O+t/r1HC4W5d+JY4
Content-Type: text/x-chdr; name=upd61151.h
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.h

/*
    upd61151.h - definition for NEC uPD61151 MPEG encoder

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/
#include <linux/firmware.h>

#define UPD61151_DEFAULT_PS_FIRMWARE "D61151_PS_7133_v22_031031.bin"
#define UPD61151_DEFAULT_PS_FIRMWARE_SIZE 97002

#define UPD61151_DEFAULT_AUDIO_FIRMWARE "audrey_MPE_V1r51.bin"
#define UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE 40064

enum mpeg_video_bitrate_mode {
	MPEG_VIDEO_BITRATE_MODE_VBR = 0, /* Variable bitrate */
	MPEG_VIDEO_BITRATE_MODE_CBR = 1, /* Constant bitrate */

	MPEG_VIDEO_BITRATE_MODE_MAX
};

enum mpeg_audio_bitrate {
	MPEG_AUDIO_BITRATE_128 = 5,  /* 128 kBit/sec */
	MPEG_AUDIO_BITRATE_160 = 6,  /* 160 kBit/sec */
	MPEG_AUDIO_BITRATE_192 = 7,  /* 192 kBit/sec */
	MPEG_AUDIO_BITRATE_224 = 8,  /* 224 kBit/sec */
	MPEG_AUDIO_BITRATE_256 = 9,  /* 256 kBit/sec */
	MPEG_AUDIO_BITRATE_320 = 10, /* 320 kBit/sec */
	MPEG_AUDIO_BITRATE_384 = 11, /* 384 kBit/sec */

	MPEG_AUDIO_BITRATE_MAX
};

enum mpeg_video_format {
	MPEG_VIDEO_FORMAT_D1 = 0,    /* 720x480/720x576 */
	MPEG_VIDEO_FORMAT_D2 = 1,    /* 704x480/704x576 */
	MPEG_VIDEO_FORMAT_D3 = 2,    /* 352x480/352x576 */
	MPEG_VIDEO_FORMAT_D4 = 3,    /* 352x240/352x288 */
	MPEG_VIDEO_FORMAT_D5 = 4,    /* 544x480/544x576 */
	MPEG_VIDEO_FORMAT_D6 = 5,    /* 480x480/480x576 */
	MPEG_VIDEO_FORMAT_D7 = 6,    /* 352x240/352x288 */
	MPEG_VIDEO_FORMAT_D8 = 8,    /* 640x480/640x576 */
	MPEG_VIDEO_FORMAT_D9 = 9,    /* 320x480/320x576 */
	MPEG_VIDEO_FORMAT_D10 = 10,  /* 320x240/320x288 */

	MPEG_VIDEO_FORMAT_MAX
};

#define MPEG_VIDEO_TARGET_BITRATE_MAX 15000
#define MPEG_VIDEO_MAX_BITRATE_MAX 15000
#define MPEG_TOTAL_BITRATE_MAX 15000
#define MPEG_PID_MAX ((1 << 14) - 1)

/* FIXME START: OLD FROM SAA6752HS */

struct mpeg_params {
	enum mpeg_video_bitrate_mode video_bitrate_mode;
	unsigned int video_target_bitrate;
	unsigned int video_max_bitrate; // only used for VBR
	enum mpeg_audio_bitrate audio_bitrate;
	unsigned int total_bitrate;

	unsigned int pmt_pid;
	unsigned int video_pid;
	unsigned int audio_pid;
	unsigned int pcr_pid;

	enum mpeg_video_format video_format;
};

/* FIXME STOP: OLD FROM SAA6752HS */

enum upd61151_command {
	UPD61151_COMMAND_INITIAL           = 0,
	UPD61151_COMMAND_STANDBY_STOP      = 1,
	UPD61151_COMMAND_CONFIG            = 2,
	UPD61151_COMMAND_START_RESTART     = 3,
	UPD61151_COMMAND_PAUSE             = 4,
	UPD61151_COMMAND_CHANGE            = 5,
};

enum upd61151_encode_state {
	UPD61151_ENCODE_STATE_IDLE         = 0,
	UPD61151_ENCODE_STATE_ENCODE       = 1,
	UPD61151_ENCODE_STATE_PAUSE        = 2,
};

enum upd61151_config {
	UPD61151_CONFIG_ALL                = 0x00,
	UPD61151_CONFIG_AUDIO_FW           = 0x10,
	UPD61151_CONFIG_VIDEO_INPUT        = 0x20,
	UPD61151_CONFIG_VBI_INPUT          = 0x30,
	UPD61151_CONFIG_AUDIO_INPUT        = 0x40,
};

#define UPD61151_COMMAND             0x00
#define UPD61151_STATUS              0x04
#define UPD61151_VIDEO_ATTRIBUTE     0x1C
#define UPD61151_VIDEO_MODE          0x20
#define UPD61151_AUDIO_ATTRIBUTE1    0x2C
#define UPD61151_VIDEO_SYNC          0x54
#define UPD61151_VIDEO_HOFFSET       0x58
#define UPD61151_VIDEO_VOFFSET       0x5C
#define UPD61151_AUDIO_INTERFACE     0x60
#define UPD61151_VBI_ADJ1            0x74
#define UPD61151_VBI_ADJ2            0x78
#define UPD61151_TRANSFER_MODE       0x80
#define UPD61151_TRANSFER_ADDR1      0x90
#define UPD61151_TRANSFER_ADDR2      0x94
#define UPD61151_TRANSFER_ADDR3      0x98
#define UPD61151_DATA_COUNTER1       0x9C
#define UPD61151_DATA_COUNTER2       0xA0
#define UPD61151_DATA_COUNTER3       0xA4
#define UPD61151_TRANSFER_IRQ        0xC0
#define UPD61151_IRQ                 0xC4
#define UPD61151_ERROR_IRQ           0xCC
#define UPD61151_EXCEPT_IRQ          0xD0
#define UPD61151_SDRAM_IF_DELAY_ADJ  0xDC
#define UPD61151_SDRAM_FCLK_SEL      0xE0
#define UPD61151_SDRAM_STANDBY       0xE8
#define UPD61151_SOFTWARE_RST        0xF8
#define UPD61151_TRANSFER_DATA       0xFC

/*
 * Local variables:
 * c-basic-offset: 8
 * End:
 */

--MP_/7jqGxd0O+t/r1HC4W5d+JY4--
