Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4BCoD9E007028
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 08:50:13 -0400
Received: from belle.abrahamsson.com (belle.abrahamsson.com [194.187.61.10]
	(may be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4BCmQPK029759
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 08:49:27 -0400
From: "Sverker Abrahamsson" <sverker@abrahamsson.com>
To: <video4linux-list@redhat.com>
Date: Mon, 11 May 2009 14:47:52 +0200
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAN5fehIZv/BBsQLx9nhfoL3ihQAAEAAAAKI1En61O+tDoEZgbOaYLvMBAAAAAA==@abrahamsson.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_030C_01C9D247.7759BAD0"
Content-Language: sv
Cc: 'Trent Piepho' <xyzzy@speakeasy.org>
Subject: Sound capture with Osprey 230
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.

------=_NextPart_000_030C_01C9D247.7759BAD0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,
I've been using Osprey 230 cards for AV capture for several years, earlier
with a modified version of Viewcast's driver but it was never very stable.
When doing a new setup I therefore wanted to get the Alsa driver to work. I
found that there were two trees in the repository in regards to these cards,
http://linuxtv.org/hg/~mchehab/osprey and http://linuxtv.org/hg/~tap/osprey.
It seems that mchehab tree is the patches that Viewcast submitted which does
not address the necessary changes for ALSA driver while tap tree does but
for Osprey 440 and older kernels.

I've therefore ported the changes from tap to the main tree and added
support for detecting Osprey 210/220/230 plus a minor fix to support
specifying digital_rate as module parameter. It might also work for Osprey
240 (which is PCI-e variant of 230) but I don't have any such card so I
haven't been able to test.

The only question mark I have is that the current implementation use the
depreciated interfaces from bttv-if.c to find which bttv driver corresponds
to this audio driver and adds a function to get the bttv core. It is
suggested to use the routines in bttv-gpio.c instead but I don't find an
obvious replacement for bttv_get_pcidev nor how to get bttv_core.

I see two alternatives:
1. Implement snd-87x module as a subdevice to bttv. Is this correct as the
video and audio devices are two separate pci devices?
2. Implement a hook in snd-87x module which register a subdevice with bttv
to get hold of bttv_core. Seams a bit upside down
Any suggestions?

The patch in its current form is attached.
/Sverker

------=_NextPart_000_030C_01C9D247.7759BAD0
Content-Type: application/octet-stream;
	name="osprey-snd.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="osprey-snd.patch"

diff --git a/linux/drivers/media/video/bt8xx/bttv-if.c =
b/linux/drivers/media/video/bt8xx/bttv-if.c=0A=
--- a/linux/drivers/media/video/bt8xx/bttv-if.c=0A=
+++ b/linux/drivers/media/video/bt8xx/bttv-if.c=0A=
@@ -34,6 +34,7 @@=0A=
 #include "bttvp.h"=0A=
 =0A=
 EXPORT_SYMBOL(bttv_get_pcidev);=0A=
+EXPORT_SYMBOL(bttv_get_core);=0A=
 EXPORT_SYMBOL(bttv_gpio_enable);=0A=
 EXPORT_SYMBOL(bttv_read_gpio);=0A=
 EXPORT_SYMBOL(bttv_write_gpio);=0A=
@@ -53,6 +54,12 @@=0A=
 	return bttvs[card]->c.pci;=0A=
 }=0A=
 =0A=
+struct bttv_core *bttv_get_core(unsigned int card)=0A=
+{=0A=
+	if (card >=3D bttv_num)=0A=
+		return NULL;=0A=
+	return &bttvs[card]->c;=0A=
+}=0A=
 =0A=
 int bttv_gpio_enable(unsigned int card, unsigned long mask, unsigned =
long data)=0A=
 {=0A=
diff --git a/linux/drivers/media/video/bt8xx/bttv.h =
b/linux/drivers/media/video/bt8xx/bttv.h=0A=
--- a/linux/drivers/media/video/bt8xx/bttv.h=0A=
+++ b/linux/drivers/media/video/bt8xx/bttv.h=0A=
@@ -301,6 +301,7 @@=0A=
    interface below for new code */=0A=
 =0A=
 extern struct pci_dev* bttv_get_pcidev(unsigned int card);=0A=
+extern struct bttv_core *bttv_get_core(unsigned int card);=0A=
 =0A=
 /* sets GPOE register (BT848_GPIO_OUT_EN) to new value:=0A=
    data | (current_GPOE_value & ~mask)=0A=
diff --git a/linux/sound/pci/bt87x.c b/linux/sound/pci/bt87x.c=0A=
--- a/linux/sound/pci/bt87x.c=0A=
+++ b/linux/sound/pci/bt87x.c=0A=
@@ -36,6 +36,7 @@=0A=
 #include <sound/pcm_params.h>=0A=
 #include <sound/control.h>=0A=
 #include <sound/initval.h>=0A=
+#include "bttv.h"=0A=
 #include "compat.h"=0A=
 #ifdef COMPAT_SND_CTL_BOOLEAN_MONO=0A=
 static int snd_ctl_boolean_mono_info(struct snd_kcontrol *kcontrol,=0A=
@@ -161,11 +162,22 @@=0A=
 /* SYNC, one WRITE per line, one extra WRITE per page boundary, SYNC, =
JUMP */=0A=
 #define MAX_RISC_SIZE ((1 + 255 + (PAGE_ALIGN(255 * 4092) / PAGE_SIZE - =
1) + 1 + 1) * 8)=0A=
 =0A=
+/* X9221 I2C POT, used in Osprey cards for gain control */=0A=
+#define X9221_ADDR	0x28	/* I2C address */=0A=
+#define X9221_PORT0     0x00    /* First port */=0A=
+#define X9221_PORT1     0x04    /* Second port */=0A=
+#define X9221_READ_WRC  0x90    /* read wiper control register */=0A=
+#define X9221_WRITE_WRC 0xa0    /* write wiper control register */=0A=
+#define X9221_G_WCR_TO_REG 0x80 /* global wcr to register */=0A=
+#define X9221_G_REG_TO_WRC 0x10 /* global register to wrc */=0A=
+=0A=
+=0A=
 /* Cards with configuration information */=0A=
 enum snd_bt87x_boardid {=0A=
 	SND_BT87X_BOARD_UNKNOWN,=0A=
 	SND_BT87X_BOARD_GENERIC,	/* both an & dig interfaces, 32kHz */=0A=
 	SND_BT87X_BOARD_ANALOG,		/* board with no external A/D */=0A=
+	SND_BT87X_BOARD_OSPREY200,=0A=
 	SND_BT87X_BOARD_OSPREY2x0,=0A=
 	SND_BT87X_BOARD_OSPREY440,=0A=
 	SND_BT87X_BOARD_AVPHONE98,=0A=
@@ -177,8 +189,11 @@=0A=
 	u32 digital_fmt;	/* Register settings for digital input */=0A=
 	unsigned no_analog:1;	/* No analog input */=0A=
 	unsigned no_digital:1;	/* No digital input */=0A=
+	unsigned x9221:1;	/* X9221 I2C POT for gain control */=0A=
 };=0A=
 =0A=
+#define DIG_RATE_GPIO -1=0A=
+=0A=
 static __devinitdata struct snd_bt87x_board snd_bt87x_boards[] =3D {=0A=
 	[SND_BT87X_BOARD_UNKNOWN] =3D {=0A=
 		.dig_rate =3D 32000, /* just a guess */=0A=
@@ -189,14 +204,21 @@=0A=
 	[SND_BT87X_BOARD_ANALOG] =3D {=0A=
 		.no_digital =3D 1,=0A=
 	},=0A=
-	[SND_BT87X_BOARD_OSPREY2x0] =3D {=0A=
+	[SND_BT87X_BOARD_OSPREY200] =3D {=0A=
 		.dig_rate =3D 44100,=0A=
 		.digital_fmt =3D CTL_DA_LRI | (1 << CTL_DA_LRD_SHIFT),=0A=
 	},=0A=
-	[SND_BT87X_BOARD_OSPREY440] =3D {=0A=
-		.dig_rate =3D 32000,=0A=
+	[SND_BT87X_BOARD_OSPREY2x0] =3D {=0A=
+		.dig_rate =3D DIG_RATE_GPIO,	/* Controlled via GPIO */=0A=
 		.digital_fmt =3D CTL_DA_LRI | (1 << CTL_DA_LRD_SHIFT),=0A=
 		.no_analog =3D 1,=0A=
+		.x9221 =3D 1,=0A=
+	},=0A=
+	[SND_BT87X_BOARD_OSPREY440] =3D {=0A=
+		.dig_rate =3D DIG_RATE_GPIO,	/* Controlled via GPIO */=0A=
+		.digital_fmt =3D CTL_DA_LRI | (1 << CTL_DA_LRD_SHIFT),=0A=
+		.no_analog =3D 1,=0A=
+		.x9221 =3D 1,=0A=
 	},=0A=
 	[SND_BT87X_BOARD_AVPHONE98] =3D {=0A=
 		.dig_rate =3D 48000,=0A=
@@ -207,6 +229,9 @@=0A=
 	struct snd_card *card;=0A=
 	struct pci_dev *pci;=0A=
 	struct snd_bt87x_board board;=0A=
+	struct bttv_core *core;=0A=
+	struct i2c_adapter *i2c;=0A=
+	int bttvnr;=0A=
 =0A=
 	void __iomem *mmio;=0A=
 	int irq;=0A=
@@ -225,6 +250,7 @@=0A=
 	int current_line;=0A=
 =0A=
 	int pci_parity_errors;=0A=
+	unsigned char x9221vol[2];=0A=
 };=0A=
 =0A=
 enum { DEVICE_DIGITAL, DEVICE_ANALOG };=0A=
@@ -409,9 +435,17 @@=0A=
 {=0A=
 	chip->reg_control |=3D CTL_DA_IOM_DA | CTL_A_PWRDN;=0A=
 	runtime->hw =3D snd_bt87x_digital_hw;=0A=
-	runtime->hw.rates =3D snd_pcm_rate_to_rate_bit(chip->board.dig_rate);=0A=
-	runtime->hw.rate_min =3D chip->board.dig_rate;=0A=
-	runtime->hw.rate_max =3D chip->board.dig_rate;=0A=
+	if (chip->board.dig_rate =3D=3D DIG_RATE_GPIO) {=0A=
+		runtime->hw.rates =3D SNDRV_PCM_RATE_32000 |=0A=
+			SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000;=0A=
+		runtime->hw.rate_min =3D 32000;=0A=
+		runtime->hw.rate_max =3D 48000;=0A=
+	} else {=0A=
+		runtime->hw.rates =3D=0A=
+			snd_pcm_rate_to_rate_bit(chip->board.dig_rate);=0A=
+		runtime->hw.rate_min =3D chip->board.dig_rate;=0A=
+		runtime->hw.rate_max =3D chip->board.dig_rate;=0A=
+	}=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -509,11 +543,33 @@=0A=
 	int decimation;=0A=
 =0A=
 	spin_lock_irq(&chip->reg_lock);=0A=
-	chip->reg_control &=3D ~(CTL_DA_SDR_MASK | CTL_DA_SBR);=0A=
-	decimation =3D (ANALOG_CLOCK + runtime->rate / 4) / runtime->rate;=0A=
-	chip->reg_control |=3D decimation << CTL_DA_SDR_SHIFT;=0A=
-	if (runtime->format =3D=3D SNDRV_PCM_FORMAT_S8)=0A=
-		chip->reg_control |=3D CTL_DA_SBR;=0A=
+	if (substream->pcm->device =3D=3D DEVICE_ANALOG) {=0A=
+		chip->reg_control &=3D ~(CTL_DA_SDR_MASK | CTL_DA_SBR);=0A=
+		decimation =3D (ANALOG_CLOCK + runtime->rate / 4) /=0A=
+			     runtime->rate;=0A=
+		chip->reg_control |=3D decimation << CTL_DA_SDR_SHIFT;=0A=
+		if (runtime->format =3D=3D SNDRV_PCM_FORMAT_S8)=0A=
+			chip->reg_control |=3D CTL_DA_SBR;=0A=
+	} else {=0A=
+		if (chip->board.dig_rate =3D=3D DIG_RATE_GPIO) {=0A=
+			int bits =3D 0;=0A=
+			switch (runtime->rate) {=0A=
+			case 32000: bits =3D 0; break;=0A=
+			case 44100: bits =3D 1; break;=0A=
+			case 48000: bits =3D 2; break;=0A=
+			}=0A=
+			gpio_bits(0x3, bits);=0A=
+		} else {=0A=
+			// The digital rate has been set fixed by module parameter =
digital_rate=0A=
+			switch (chip->board.dig_rate) {=0A=
+			int bits =3D 0;=0A=
+			case 32000: bits =3D 0; break;=0A=
+			case 44100: bits =3D 1; break;=0A=
+			case 48000: bits =3D 2; break;=0A=
+			}=0A=
+			gpio_bits(0x3, bits);=0A=
+		}=0A=
+	}=0A=
 	snd_bt87x_writel(chip, REG_GPIO_DMA_CTL, chip->reg_control);=0A=
 	spin_unlock_irq(&chip->reg_lock);=0A=
 	return 0;=0A=
@@ -720,6 +776,91 @@=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+static int snd_bt87x_dig_volume_info(struct snd_kcontrol *kcontrol,=0A=
+				     struct snd_ctl_elem_info *info)=0A=
+{=0A=
+	info->type =3D SNDRV_CTL_ELEM_TYPE_INTEGER;=0A=
+	info->count =3D 2;=0A=
+	info->value.integer.min =3D 0;=0A=
+	info->value.integer.max =3D 63;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int snd_bt87x_dig_volume_get(struct snd_kcontrol *kcontrol,=0A=
+				    struct snd_ctl_elem_value *value)=0A=
+{=0A=
+	struct snd_bt87x *chip =3D snd_kcontrol_chip(kcontrol);=0A=
+	char cmdR[1] =3D { X9221_READ_WRC|X9221_PORT0 };=0A=
+	char cmdL[1] =3D { X9221_READ_WRC|X9221_PORT1 };=0A=
+	char out;=0A=
+	struct i2c_msg msg[2] =3D {=0A=
+		{ .addr =3D X9221_ADDR, .buf =3D cmdL, .len =3D 1, .flags =3D 0 },=0A=
+		{ .addr =3D X9221_ADDR, .buf =3D &out, .len =3D 1,=0A=
+		  .flags =3D I2C_M_RD|I2C_M_NOSTART },=0A=
+	};=0A=
+	int err;=0A=
+=0A=
+	err =3D i2c_transfer(chip->i2c, msg, 2);=0A=
+	if (err < 0)=0A=
+		return err;=0A=
+	chip->x9221vol[0] =3D value->value.integer.value[0] =3D out;=0A=
+=0A=
+	msg[0].buf =3D cmdR;=0A=
+	err =3D i2c_transfer(chip->i2c, msg, 2);=0A=
+	if (err < 0)=0A=
+		return err;=0A=
+	chip->x9221vol[1] =3D value->value.integer.value[1] =3D out;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int snd_bt87x_dig_volume_put(struct snd_kcontrol *kcontrol,=0A=
+				    struct snd_ctl_elem_value *value)=0A=
+{=0A=
+	struct snd_bt87x *chip =3D snd_kcontrol_chip(kcontrol);=0A=
+	char cmdL[] =3D=0A=
+		{ X9221_WRITE_WRC|X9221_PORT1, value->value.integer.value[0] };=0A=
+	char cmdR[] =3D=0A=
+		{ X9221_WRITE_WRC|X9221_PORT0, value->value.integer.value[1] };=0A=
+	struct i2c_msg msg[2] =3D {=0A=
+		{ .addr =3D X9221_ADDR, .buf =3D cmdR, .len =3D sizeof(cmdR) },=0A=
+		{ .addr =3D X9221_ADDR, .buf =3D cmdL, .len =3D sizeof(cmdR) },=0A=
+	};=0A=
+	int err;=0A=
+=0A=
+	err =3D i2c_transfer(chip->i2c, msg, 2);=0A=
+	if (err < 0)=0A=
+		return err;=0A=
+=0A=
+	if (value->value.integer.value[0] !=3D chip->x9221vol[0] ||=0A=
+	    value->value.integer.value[1] !=3D chip->x9221vol[1]) {=0A=
+		chip->x9221vol[0] =3D value->value.integer.value[0];=0A=
+		chip->x9221vol[1] =3D value->value.integer.value[1];=0A=
+		return 1;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static struct snd_kcontrol_new snd_bt87x_dig_volume =3D {=0A=
+	.iface =3D SNDRV_CTL_ELEM_IFACE_MIXER,=0A=
+	.name =3D "Capture Volume",=0A=
+	.info =3D snd_bt87x_dig_volume_info,=0A=
+	.get =3D snd_bt87x_dig_volume_get,=0A=
+	.put =3D snd_bt87x_dig_volume_put,=0A=
+};=0A=
+=0A=
+static int attach_x9221(struct snd_bt87x *chip)=0A=
+{=0A=
+	chip->i2c =3D &chip->core->i2c_adap;=0A=
+=0A=
+	/* Use a unique name if analog is using "Capture Volume" */=0A=
+	if (!chip->board.no_analog)=0A=
+		snd_bt87x_dig_volume.name =3D "Digital Capture Volume";=0A=
+=0A=
+	return snd_ctl_add(chip->card,=0A=
+			   snd_ctl_new1(&snd_bt87x_dig_volume, chip));=0A=
+}=0A=
+=0A=
 static int snd_bt87x_dev_free(struct snd_device *device)=0A=
 {=0A=
 	struct snd_bt87x *chip =3D device->device_data;=0A=
@@ -812,6 +953,23 @@=0A=
 	return err;=0A=
 }=0A=
 =0A=
+/*=0A=
+ * The the number of the v4l bttv driver's device that matches the audio=0A=
+ * device we are driving.=0A=
+ */=0A=
+static int get_bttvnr(struct snd_bt87x *chip)=0A=
+{=0A=
+	struct pci_dev *pci;=0A=
+	int i;=0A=
+=0A=
+	for (i =3D 0; (pci =3D bttv_get_pcidev(i)); i++) {=0A=
+		if (pci->bus->number =3D=3D chip->pci->bus->number &&=0A=
+		    PCI_SLOT(pci->devfn) =3D=3D PCI_SLOT(chip->pci->devfn))=0A=
+			return i;=0A=
+	}=0A=
+	return -ENODEV;=0A=
+}=0A=
+=0A=
 #define BT_DEVICE(chip, subvend, subdev, id) \=0A=
 	{ .vendor =3D PCI_VENDOR_ID_BROOKTREE, \=0A=
 	  .device =3D chip, \=0A=
@@ -824,8 +982,10 @@=0A=
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0x13eb, GENERIC),=0A=
 	/* Hauppauge WinTV series */=0A=
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_879, 0x0070, 0x13eb, GENERIC),=0A=
-	/* Viewcast Osprey 200 */=0A=
-	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0xff01, OSPREY2x0),=0A=
+	/* Viewcast Osprey 200/250 */=0A=
+	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0xff01, OSPREY200),=0A=
+	/* Viewcast Osprey 210/220/230/240(?) */=0A=
+	//BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0xff01, OSPREY2x0),=0A=
 	/* Viewcast Osprey 440 (rate is configurable via gpio) */=0A=
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0xff07, OSPREY440),=0A=
 	/* ATI TV-Wonder */=0A=
@@ -922,6 +1082,20 @@=0A=
 	if (err < 0)=0A=
 		goto _error;=0A=
 =0A=
+	chip->bttvnr =3D get_bttvnr(chip);=0A=
+	if (chip->bttvnr < 0) {=0A=
+		snd_printk(KERN_ERR=0A=
+			"bt87x%d: Unable to locate matching"=0A=
+			" video device\n", dev);=0A=
+		goto _error;=0A=
+	}=0A=
+	chip->core =3D bttv_get_core(chip->bttvnr);=0A=
+	if(boardid =3D=3D SND_BT87X_BOARD_OSPREY200) {=0A=
+		if(chip->core->type =3D=3D BTTV_BOARD_OSPREY2x0) {=0A=
+			// This is acctually a 210/220/230 card. The pci id is the same so =
bttv driver checks eeprom on card=0A=
+			boardid =3D SND_BT87X_BOARD_OSPREY2x0;=0A=
+		}=0A=
+	}=0A=
 	memcpy(&chip->board, &snd_bt87x_boards[boardid], sizeof(chip->board));=0A=
 =0A=
 	if (!chip->board.no_digital) {=0A=
@@ -933,6 +1107,12 @@=0A=
 		err =3D snd_bt87x_pcm(chip, DEVICE_DIGITAL, "Bt87x Digital");=0A=
 		if (err < 0)=0A=
 			goto _error;=0A=
+=0A=
+		if (chip->board.x9221) {=0A=
+			err =3D attach_x9221(chip);=0A=
+			if (err < 0)=0A=
+				goto _error;=0A=
+		}=0A=
 	}=0A=
 	if (!chip->board.no_analog) {=0A=
 		err =3D snd_bt87x_pcm(chip, DEVICE_ANALOG, "Bt87x Analog");=0A=

------=_NextPart_000_030C_01C9D247.7759BAD0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_NextPart_000_030C_01C9D247.7759BAD0--
