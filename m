Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6U2gm6v008187
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 22:42:48 -0400
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6U2gWb8017770
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 22:42:33 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, Gunther Mayer <gmy@gmx.org>
In-Reply-To: <20080729121938.3d4668f4@gaivota>
References: <20080711231113.13054808@hyperion.delvare>
	<20080729121938.3d4668f4@gaivota>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 04:35:58 +0200
Message-Id: <1217385358.2671.28.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com
Subject: Re: bt832 driver
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

Hi,

Am Dienstag, den 29.07.2008, 12:19 -0300 schrieb Mauro Carvalho Chehab:
> Hi Jean,
> 
> On Fri, 11 Jul 2008 23:11:13 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Hi Mauro,
> > 
> > As part of the next big i2c-core change, I must update all the legacy
> > i2c drivers. I was about to update the bt832 driver, but found that
> > there was no reference to it in the build system. After adding a
> > reference to force it to build, I found that it wouldn't actually
> > build, because the last change to the driver broke it and apparently
> > nobody noticed. Looking at the code, the driver doesn't appear to be
> > functional.
> > 
> > So rather than wasting my time fixing this broken driver nobody is
> > using, I believe that it would be better to delete it. If this is OK
> > with you, here's a patch doing that. Thanks.
> 
> I'm ok with this removal.
> 
> Since you did your patch against -git, it doesn't apply at -hg. So, I've
> re-generated it. Please check if everything is all right. I did a small
> additional cleanup at bttv driver, since you've kept a test that is not needed
> anymore.
> 
> Cheers,
> Mauro.

I'm not sure, if any of you is aware about the extend of contribution we
have from Gunther.

Mauro should at least be a little.

To remove it likely is fine, but there should be at least an attempt to
inform the author.

http://www.bttv-gallery.de

is only a minor part of his work, but is still without any even close to
it.

Else I'm talking about several hundreds crucial and substantial patches
he provided in the past, not to forget that he is a coauthor of tuner.

I don't like that style to proceed, without even trying to reach those
on whose back and work we still stand.

Hermann

 
> > * * * * *
> > 
> > Subject: Delete broken bt832 driver
> > 
> > The bt832 driver was added to the kernel tree in January 2003, but it
> > was never integrated in the build system. According to the header
> > comments, it doesn't actually work (which a quick inspection of the
> > code seems to confirm.) In fact, it doesn't even build at the moment.
> > To lower the maintenance cost, I propose that we delete this driver
> > now.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> 
> diff -r 02bfc69e3849 linux/drivers/media/video/bt8xx/bt832.c
> --- a/linux/drivers/media/video/bt8xx/bt832.c	Mon Jul 28 18:07:35 2008 -0300
> +++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
> @@ -1,287 +0,0 @@
> -/* Driver for Bt832 CMOS Camera Video Processor
> -    i2c-addresses: 0x88 or 0x8a
> -
> -  The BT832 interfaces to a Quartzsight Digital Camera (352x288, 25 or 30 fps)
> -  via a 9 pin connector ( 4-wire SDATA, 2-wire i2c, SCLK, VCC, GND).
> -  It outputs an 8-bit 4:2:2 YUV or YCrCb video signal which can be directly
> -  connected to bt848/bt878 GPIO pins on this purpose.
> -  (see: VLSI Vision Ltd. www.vvl.co.uk for camera datasheets)
> -
> -  Supported Cards:
> -  -  Pixelview Rev.4E: 0x8a
> -		GPIO 0x400000 toggles Bt832 RESET, and the chip changes to i2c 0x88 !
> -
> -  (c) Gunther Mayer, 2002
> -
> -  STATUS:
> -  - detect chip and hexdump
> -  - reset chip and leave low power mode
> -  - detect camera present
> -
> -  TODO:
> -  - make it work (find correct setup for Bt832 and Bt878)
> -*/
> -
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/i2c.h>
> -#include <linux/types.h>
> -#include "compat.h"
> -#include <linux/videodev.h>
> -#include <linux/init.h>
> -#include <linux/errno.h>
> -#include <linux/slab.h>
> -#include <media/v4l2-common.h>
> -
> -#include "bttv.h"
> -#include "bt832.h"
> -
> -MODULE_LICENSE("GPL");
> -
> -/* Addresses to scan */
> -static unsigned short normal_i2c[] = { I2C_ADDR_BT832_ALT1>>1, I2C_ADDR_BT832_ALT2>>1,
> -				       I2C_CLIENT_END };
> -I2C_CLIENT_INSMOD;
> -
> -int debug;    /* debug output */
> -module_param(debug,            int, 0644);
> -
> -/* ---------------------------------------------------------------------- */
> -
> -static int bt832_detach(struct i2c_client *client);
> -
> -
> -static struct i2c_driver driver;
> -static struct i2c_client client_template;
> -
> -struct bt832 {
> -	struct i2c_client client;
> -};
> -
> -int bt832_hexdump(struct i2c_client *i2c_client_s, unsigned char *buf)
> -{
> -	int i,rc;
> -	buf[0]=0x80; // start at register 0 with auto-increment
> -	if (1 != (rc = i2c_master_send(i2c_client_s,buf,1)))
> -		v4l_err(i2c_client_s,"i2c i/o error: rc == %d (should be 1)\n",rc);
> -
> -	for(i=0;i<65;i++)
> -		buf[i]=0;
> -	if (65 != (rc=i2c_master_recv(i2c_client_s,buf,65)))
> -		v4l_err(i2c_client_s,"i2c i/o error: rc == %d (should be 65)\n",rc);
> -
> -	// Note: On READ the first byte is the current index
> -	//  (e.g. 0x80, what we just wrote)
> -
> -	if(debug>1) {
> -		int i;
> -		v4l_dbg(2, debug,i2c_client_s,"hexdump:");
> -		for(i=1;i<65;i++) {
> -			if(i!=1) {
> -				if(((i-1)%8)==0) printk(" ");
> -				if(((i-1)%16)==0) {
> -					printk("\n");
> -					v4l_dbg(2, debug,i2c_client_s,"hexdump:");
> -				}
> -			}
> -			printk(" %02x",buf[i]);
> -		}
> -		printk("\n");
> -	}
> -	return 0;
> -}
> -
> -// Return: 1 (is a bt832), 0 (No bt832 here)
> -int bt832_init(struct i2c_client *i2c_client_s)
> -{
> -	unsigned char *buf;
> -	int rc;
> -
> -	buf=kmalloc(65,GFP_KERNEL);
> -	if (!buf) {
> -		v4l_err(&t->client,
> -			"Unable to allocate memory. Detaching.\n");
> -		return 0;
> -	}
> -	bt832_hexdump(i2c_client_s,buf);
> -
> -	if(buf[0x40] != 0x31) {
> -		v4l_err(i2c_client_s,"This i2c chip is no bt832 (id=%02x). Detaching.\n",buf[0x40]);
> -		kfree(buf);
> -		return 0;
> -	}
> -
> -	v4l_err(i2c_client_s,"Write 0 tp VPSTATUS\n");
> -	buf[0]=BT832_VP_STATUS; // Reg.52
> -	buf[1]= 0x00;
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_err(i2c_client_s,"i2c i/o error VPS: rc == %d (should be 2)\n",rc);
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -
> -
> -	// Leave low power mode:
> -	v4l_err(i2c_client_s,"leave low power mode.\n");
> -	buf[0]=BT832_CAM_SETUP0; //0x39 57
> -	buf[1]=0x08;
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_err(i2c_client_s,"i2c i/o error LLPM: rc == %d (should be 2)\n",rc);
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -
> -	v4l_info(i2c_client_s,"Write 0 tp VPSTATUS\n");
> -	buf[0]=BT832_VP_STATUS; // Reg.52
> -	buf[1]= 0x00;
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_err(i2c_client_s,"i2c i/o error VPS: rc == %d (should be 2)\n",rc);
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -
> -
> -	// Enable Output
> -	v4l_info(i2c_client_s,"Enable Output\n");
> -	buf[0]=BT832_VP_CONTROL1; // Reg.40
> -	buf[1]= 0x27 & (~0x01); // Default | !skip
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_err(i2c_client_s,"i2c i/o error EO: rc == %d (should be 2)\n",rc);
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -
> -#if 0
> -	// Full 30/25 Frame rate
> -	v4l_err(i2c_client_s,"Full 30/25 Frame rate\n");
> -	buf[0]=BT832_VP_CONTROL0; // Reg.39
> -	buf[1]= 0x00;
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_err(i2c_client_s,"i2c i/o error FFR: rc == %d (should be 2)\n",rc);
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -#endif
> -
> -#if 1
> -	// for testing (even works when no camera attached)
> -	v4l_info(i2c_client_s,"*** Generate NTSC M Bars *****\n");
> -	buf[0]=BT832_VP_TESTCONTROL0; // Reg. 42
> -	buf[1]=3; // Generate NTSC System M bars, Generate Frame timing internally
> -	if (2 != (rc = i2c_master_send(i2c_client_s,buf,2)))
> -		v4l_info(i2c_client_s,"i2c i/o error MBAR: rc == %d (should be 2)\n",rc);
> -#endif
> -
> -	v4l_info(i2c_client_s,"Camera Present: %s\n",
> -		(buf[1+BT832_CAM_STATUS] & BT832_56_CAMERA_PRESENT) ? "yes":"no");
> -
> -	bt832_hexdump(i2c_client_s,buf);
> -	kfree(buf);
> -	return 1;
> -}
> -
> -
> -
> -static int bt832_attach(struct i2c_adapter *adap, int addr, int kind)
> -{
> -	struct bt832 *t;
> -
> -	client_template.adapter = adap;
> -	client_template.addr    = addr;
> -
> -	if (NULL == (t = kzalloc(sizeof(*t), GFP_KERNEL)))
> -		return -ENOMEM;
> -	t->client = client_template;
> -	i2c_set_clientdata(&t->client, t);
> -	i2c_attach_client(&t->client);
> -
> -	v4l_info(&t->client,"chip found @ 0x%x\n", addr<<1);
> -
> -	if(! bt832_init(&t->client)) {
> -		bt832_detach(&t->client);
> -		return -1;
> -	}
> -
> -	return 0;
> -}
> -
> -static int bt832_probe(struct i2c_adapter *adap)
> -{
> -	if (adap->class & I2C_CLASS_TV_ANALOG)
> -		return i2c_probe(adap, &addr_data, bt832_attach);
> -	return 0;
> -}
> -
> -static int bt832_detach(struct i2c_client *client)
> -{
> -	struct bt832 *t = i2c_get_clientdata(client);
> -
> -	v4l_info(&t->client,"dettach\n");
> -	i2c_detach_client(client);
> -	kfree(t);
> -	return 0;
> -}
> -
> -static int
> -bt832_command(struct i2c_client *client, unsigned int cmd, void *arg)
> -{
> -	struct bt832 *t = i2c_get_clientdata(client);
> -
> -	if (debug>1)
> -		v4l_i2c_print_ioctl(&t->client,cmd);
> -
> -	switch (cmd) {
> -		case BT832_HEXDUMP: {
> -			unsigned char *buf;
> -			buf = kmalloc(65, GFP_KERNEL);
> -			if (!buf) {
> -				v4l_err(&t->client,
> -					"Unable to allocate memory\n");
> -				break;
> -			}
> -			bt832_hexdump(&t->client,buf);
> -			kfree(buf);
> -		}
> -		break;
> -		case BT832_REATTACH:
> -			v4l_info(&t->client,"re-attach\n");
> -			i2c_del_driver(&driver);
> -			i2c_add_driver(&driver);
> -		break;
> -	}
> -	return 0;
> -}
> -
> -/* ----------------------------------------------------------------------- */
> -
> -static struct i2c_driver driver = {
> -	.driver = {
> -		.name   = "bt832",
> -	},
> -	.id             = 0, /* FIXME */
> -	.attach_adapter = bt832_probe,
> -	.detach_client  = bt832_detach,
> -	.command        = bt832_command,
> -};
> -static struct i2c_client client_template =
> -{
> -	.name       = "bt832",
> -	.driver     = &driver,
> -};
> -
> -
> -static int __init bt832_init_module(void)
> -{
> -	return i2c_add_driver(&driver);
> -}
> -
> -static void __exit bt832_cleanup_module(void)
> -{
> -	i2c_del_driver(&driver);
> -}
> -
> -module_init(bt832_init_module);
> -module_exit(bt832_cleanup_module);
> -
> -/*
> - * Overrides for Emacs so that we follow Linus's tabbing style.
> - * ---------------------------------------------------------------------------
> - * Local variables:
> - * c-basic-offset: 8
> - * End:
> - */
> diff -r 02bfc69e3849 linux/drivers/media/video/bt8xx/bt832.h
> --- a/linux/drivers/media/video/bt8xx/bt832.h	Mon Jul 28 18:07:35 2008 -0300
> +++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
> @@ -1,305 +0,0 @@
> -/* Bt832 CMOS Camera Video Processor (VP)
> -
> - The Bt832 CMOS Camera Video Processor chip connects a Quartsight CMOS
> -  color digital camera directly to video capture devices via an 8-bit,
> -  4:2:2 YUV or YCrCb video interface.
> -
> - i2c addresses: 0x88 or 0x8a
> - */
> -
> -/* The 64 registers: */
> -
> -// Input Processor
> -#define BT832_OFFSET 0
> -#define BT832_RCOMP	1
> -#define BT832_G1COMP	2
> -#define BT832_G2COMP	3
> -#define BT832_BCOMP	4
> -// Exposures:
> -#define BT832_FINEH	5
> -#define BT832_FINEL	6
> -#define BT832_COARSEH	7
> -#define BT832_COARSEL   8
> -#define BT832_CAMGAIN	9
> -// Main Processor:
> -#define BT832_M00	10
> -#define BT832_M01	11
> -#define BT832_M02	12
> -#define BT832_M10	13
> -#define BT832_M11	14
> -#define BT832_M12	15
> -#define BT832_M20	16
> -#define BT832_M21	17
> -#define BT832_M22	18
> -#define BT832_APCOR	19
> -#define BT832_GAMCOR	20
> -// Level Accumulator Inputs
> -#define BT832_VPCONTROL2	21
> -#define BT832_ZONECODE0	22
> -#define BT832_ZONECODE1	23
> -#define BT832_ZONECODE2	24
> -#define BT832_ZONECODE3	25
> -// Level Accumulator Outputs:
> -#define BT832_RACC	26
> -#define BT832_GACC	27
> -#define BT832_BACC	28
> -#define BT832_BLACKACC	29
> -#define BT832_EXP_AGC	30
> -#define BT832_LACC0	31
> -#define BT832_LACC1	32
> -#define BT832_LACC2	33
> -#define BT832_LACC3	34
> -#define BT832_LACC4	35
> -#define BT832_LACC5	36
> -#define BT832_LACC6	37
> -#define BT832_LACC7	38
> -// System:
> -#define BT832_VP_CONTROL0	39
> -#define BT832_VP_CONTROL1	40
> -#define BT832_THRESH	41
> -#define BT832_VP_TESTCONTROL0	42
> -#define BT832_VP_DMCODE	43
> -#define BT832_ACB_CONFIG	44
> -#define BT832_ACB_GNBASE	45
> -#define BT832_ACB_MU	46
> -#define BT832_CAM_TEST0	47
> -#define BT832_AEC_CONFIG	48
> -#define BT832_AEC_TL	49
> -#define BT832_AEC_TC	50
> -#define BT832_AEC_TH	51
> -// Status:
> -#define BT832_VP_STATUS	52
> -#define BT832_VP_LINECOUNT	53
> -#define BT832_CAM_DEVICEL	54 // e.g. 0x19
> -#define BT832_CAM_DEVICEH	55 // e.g. 0x40  == 0x194 Mask0, 0x194 = 404 decimal (VVL-404 camera)
> -#define BT832_CAM_STATUS		56
> - #define BT832_56_CAMERA_PRESENT 0x20
> -//Camera Setups:
> -#define BT832_CAM_SETUP0	57
> -#define BT832_CAM_SETUP1	58
> -#define BT832_CAM_SETUP2	59
> -#define BT832_CAM_SETUP3	60
> -// System:
> -#define BT832_DEFCOR		61
> -#define BT832_VP_TESTCONTROL1	62
> -#define BT832_DEVICE_ID		63
> -# define BT832_DEVICE_ID__31		0x31 // Bt832 has ID 0x31
> -
> -/* STMicroelectronivcs VV5404 camera module
> -   i2c: 0x20: sensor address
> -   i2c: 0xa0: eeprom for ccd defect map
> - */
> -#define VV5404_device_h		0x00  // 0x19
> -#define VV5404_device_l		0x01  // 0x40
> -#define VV5404_status0		0x02
> -#define VV5404_linecountc	0x03 // current line counter
> -#define VV5404_linecountl	0x04
> -#define VV5404_setup0		0x10
> -#define VV5404_setup1		0x11
> -#define VV5404_setup2		0x12
> -#define VV5404_setup4		0x14
> -#define VV5404_setup5		0x15
> -#define VV5404_fine_h		0x20  // fine exposure
> -#define VV5404_fine_l		0x21
> -#define VV5404_coarse_h		0x22  //coarse exposure
> -#define VV5404_coarse_l		0x23
> -#define VV5404_gain		0x24 // ADC pre-amp gain setting
> -#define VV5404_clk_div		0x25
> -#define VV5404_cr		0x76 // control register
> -#define VV5404_as0		0x77 // ADC setup register
> -
> -
> -// IOCTL
> -#define BT832_HEXDUMP   _IOR('b',1,int)
> -#define BT832_REATTACH	_IOR('b',2,int)
> -
> -/* from BT8x8VXD/capdrv/dialogs.cpp */
> -
> -/*
> -typedef enum { SVI, Logitech, Rockwell } CAMERA;
> -
> -static COMBOBOX_ENTRY gwCameraOptions[] =
> -{
> -   { SVI,      "Silicon Vision 512N" },
> -   { Logitech, "Logitech VideoMan 1.3"  },
> -   { Rockwell, "Rockwell QuartzSight PCI 1.0"   }
> -};
> -
> -// SRAM table values
> -//===========================================================================
> -typedef enum { TGB_NTSC624, TGB_NTSC780, TGB_NTSC858, TGB_NTSC392 } TimeGenByte;
> -
> -BYTE SRAMTable[][ 60 ] =
> -{
> -   // TGB_NTSC624
> -   {
> -      0x33, // size of table = 51
> -      0x0E, 0xC0, 0x00, 0x00, 0x90, 0x02, 0x03, 0x10, 0x03, 0x06,
> -      0x10, 0x04, 0x12, 0x12, 0x05, 0x02, 0x13, 0x04, 0x19, 0x00,
> -      0x04, 0x39, 0x00, 0x06, 0x59, 0x08, 0x03, 0x85, 0x08, 0x07,
> -      0x03, 0x50, 0x00, 0x91, 0x40, 0x00, 0x11, 0x01, 0x01, 0x4D,
> -      0x0D, 0x02, 0x03, 0x11, 0x01, 0x05, 0x37, 0x00, 0x37, 0x21, 0x00
> -   },
> -   // TGB_NTSC780
> -   {
> -      0x33, // size of table = 51
> -      0x0e, 0xc0, 0x00, 0x00, 0x90, 0xe2, 0x03, 0x10, 0x03, 0x06,
> -      0x10, 0x34, 0x12, 0x12, 0x65, 0x02, 0x13, 0x24, 0x19, 0x00,
> -      0x24, 0x39, 0x00, 0x96, 0x59, 0x08, 0x93, 0x85, 0x08, 0x97,
> -      0x03, 0x50, 0x50, 0xaf, 0x40, 0x30, 0x5f, 0x01, 0xf1, 0x7f,
> -      0x0d, 0xf2, 0x03, 0x11, 0xf1, 0x05, 0x37, 0x30, 0x85, 0x21, 0x50
> -   },
> -   // TGB_NTSC858
> -   {
> -      0x33, // size of table = 51
> -      0x0c, 0xc0, 0x00, 0x00, 0x90, 0xc2, 0x03, 0x10, 0x03, 0x06,
> -      0x10, 0x34, 0x12, 0x12, 0x65, 0x02, 0x13, 0x24, 0x19, 0x00,
> -      0x24, 0x39, 0x00, 0x96, 0x59, 0x08, 0x93, 0x83, 0x08, 0x97,
> -      0x03, 0x50, 0x30, 0xc0, 0x40, 0x30, 0x86, 0x01, 0x01, 0xa6,
> -      0x0d, 0x62, 0x03, 0x11, 0x61, 0x05, 0x37, 0x30, 0xac, 0x21, 0x50
> -   },
> -   // TGB_NTSC392
> -   // This table has been modified to be used for Fusion Rev D
> -   {
> -      0x2A, // size of table = 42
> -      0x06, 0x08, 0x04, 0x0a, 0xc0, 0x00, 0x18, 0x08, 0x03, 0x24,
> -      0x08, 0x07, 0x02, 0x90, 0x02, 0x08, 0x10, 0x04, 0x0c, 0x10,
> -      0x05, 0x2c, 0x11, 0x04, 0x55, 0x48, 0x00, 0x05, 0x50, 0x00,
> -      0xbf, 0x0c, 0x02, 0x2f, 0x3d, 0x00, 0x2f, 0x3f, 0x00, 0xc3,
> -      0x20, 0x00
> -   }
> -};
> -
> -//===========================================================================
> -// This is the structure of the camera specifications
> -//===========================================================================
> -typedef struct tag_cameraSpec
> -{
> -   SignalFormat signal;       // which digital signal format the camera has
> -   VideoFormat  vidFormat;    // video standard
> -   SyncVideoRef syncRef;      // which sync video reference is used
> -   State        syncOutput;   // enable sync output for sync video input?
> -   DecInputClk  iClk;         // which input clock is used
> -   TimeGenByte  tgb;          // which timing generator byte does the camera use
> -   int          HReset;       // select 64, 48, 32, or 16 CLKx1 for HReset
> -   PLLFreq      pllFreq;      // what synthesized frequency to set PLL to
> -   VSIZEPARMS   vSize;        // video size the camera produces
> -   int          lineCount;    // expected total number of half-line per frame - 1
> -   BOOL         interlace;    // interlace signal?
> -} CameraSpec;
> -
> -//===========================================================================
> -// <UPDATE REQUIRED>
> -// Camera specifications database. Update this table whenever camera spec
> -// has been changed or added/deleted supported camera models
> -//===========================================================================
> -static CameraSpec dbCameraSpec[ N_CAMERAOPTIONS ] =
> -{  // Silicon Vision 512N
> -   { Signal_CCIR656, VFormat_NTSC, VRef_alignedCb, Off, DecClk_GPCLK, TGB_NTSC624, 64, KHz19636,
> -      // Clkx1_HACTIVE, Clkx1_HDELAY, VActive, VDelay, linesPerField; lineCount, Interlace
> -   {         512,           0x64,       480,    0x13,      240 },         0,       TRUE
> -   },
> -   // Logitech VideoMan 1.3
> -   { Signal_CCIR656, VFormat_NTSC, VRef_alignedCb, Off, DecClk_GPCLK, TGB_NTSC780, 64, KHz24545,
> -      // Clkx1_HACTIVE, Clkx1_HDELAY, VActive, VDelay, linesPerField; lineCount, Interlace
> -      {      640,           0x80,       480,    0x1A,      240 },         0,       TRUE
> -   },
> -   // Rockwell QuartzSight
> -   // Note: Fusion Rev D (rev ID 0x02) and later supports 16 pixels for HReset which is preferable.
> -   //       Use 32 for earlier version of hardware. Clkx1_HDELAY also changed from 0x27 to 0x20.
> -   { Signal_CCIR656, VFormat_NTSC, VRef_alignedCb, Off, DecClk_GPCLK, TGB_NTSC392, 16, KHz28636,
> -      // Clkx1_HACTIVE, Clkx1_HDELAY, VActive, VDelay, linesPerField; lineCount, Interlace
> -      {      352,           0x20,       576,    0x08,      288 },       607,       FALSE
> -   }
> -};
> -*/
> -
> -/*
> -The corresponding APIs required to be invoked are:
> -SetConnector( ConCamera, TRUE/FALSE );
> -SetSignalFormat( spec.signal );
> -SetVideoFormat( spec.vidFormat );
> -SetSyncVideoRef( spec.syncRef );
> -SetEnableSyncOutput( spec.syncOutput );
> -SetTimGenByte( SRAMTable[ spec.tgb ], SRAMTableSize[ spec.tgb ] );
> -SetHReset( spec.HReset );
> -SetPLL( spec.pllFreq );
> -SetDecInputClock( spec.iClk );
> -SetVideoInfo( spec.vSize );
> -SetTotalLineCount( spec.lineCount );
> -SetInterlaceMode( spec.interlace );
> -*/
> -
> -/* from web:
> - Video Sampling
> -Digital video is a sampled form of analog video. The most common sampling schemes in use today are:
> -		  Pixel Clock   Horiz    Horiz    Vert
> -		   Rate         Total    Active
> -NTSC square pixel  12.27 MHz    780      640      525
> -NTSC CCIR-601      13.5  MHz    858      720      525
> -NTSC 4FSc          14.32 MHz    910      768      525
> -PAL  square pixel  14.75 MHz    944      768      625
> -PAL  CCIR-601      13.5  MHz    864      720      625
> -PAL  4FSc          17.72 MHz   1135      948      625
> -
> -For the CCIR-601 standards, the sampling is based on a static orthogonal sampling grid. The luminance component (Y) is sampled at 13.5 MHz, while the two color difference signals, Cr and Cb are sampled at half that, or 6.75 MHz. The Cr and Cb samples are colocated with alternate Y samples, and they are taken at the same position on each line, such that one sample is coincident with the 50% point of the falling edge of analog sync. The samples are coded to either 8 or 10 bits per component.
> -*/
> -
> -/* from DScaler:*/
> -/*
> -//===========================================================================
> -// CCIR656 Digital Input Support: The tables were taken from DScaler proyect
> -//
> -// 13 Dec 2000 - Michael Eskin, Conexant Systems - Initial version
> -//
> -
> -//===========================================================================
> -// Timing generator SRAM table values for CCIR601 720x480 NTSC
> -//===========================================================================
> -// For NTSC CCIR656
> -BYTE BtCard::SRAMTable_NTSC[] =
> -{
> -    // SRAM Timing Table for NTSC
> -    0x0c, 0xc0, 0x00,
> -    0x00, 0x90, 0xc2,
> -    0x03, 0x10, 0x03,
> -    0x06, 0x10, 0x34,
> -    0x12, 0x12, 0x65,
> -    0x02, 0x13, 0x24,
> -    0x19, 0x00, 0x24,
> -    0x39, 0x00, 0x96,
> -    0x59, 0x08, 0x93,
> -    0x83, 0x08, 0x97,
> -    0x03, 0x50, 0x30,
> -    0xc0, 0x40, 0x30,
> -    0x86, 0x01, 0x01,
> -    0xa6, 0x0d, 0x62,
> -    0x03, 0x11, 0x61,
> -    0x05, 0x37, 0x30,
> -    0xac, 0x21, 0x50
> -};
> -
> -//===========================================================================
> -// Timing generator SRAM table values for CCIR601 720x576 NTSC
> -//===========================================================================
> -// For PAL CCIR656
> -BYTE BtCard::SRAMTable_PAL[] =
> -{
> -    // SRAM Timing Table for PAL
> -    0x36, 0x11, 0x01,
> -    0x00, 0x90, 0x02,
> -    0x05, 0x10, 0x04,
> -    0x16, 0x14, 0x05,
> -    0x11, 0x00, 0x04,
> -    0x12, 0xc0, 0x00,
> -    0x31, 0x00, 0x06,
> -    0x51, 0x08, 0x03,
> -    0x89, 0x08, 0x07,
> -    0xc0, 0x44, 0x00,
> -    0x81, 0x01, 0x01,
> -    0xa9, 0x0d, 0x02,
> -    0x02, 0x50, 0x03,
> -    0x37, 0x3d, 0x00,
> -    0xaf, 0x21, 0x00,
> -};
> -*/
> diff -r 02bfc69e3849 linux/drivers/media/video/bt8xx/bttv-cards.c
> --- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Mon Jul 28 18:07:35 2008 -0300
> +++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Tue Jul 29 12:16:22 2008 -0300
> @@ -41,14 +41,10 @@
>  #include "bttvp.h"
>  #include <media/v4l2-common.h>
>  #include <media/tvaudio.h>
> -#if 0 /* not working yet */
> -#include "bt832.h"
> -#endif
>  #include "bttv-audio-hook.h"
>  
>  /* fwd decl */
>  static void boot_msp34xx(struct bttv *btv, int pin);
> -static void boot_bt832(struct bttv *btv);
>  static void hauppauge_eeprom(struct bttv *btv);
>  static void avermedia_eeprom(struct bttv *btv);
>  static void osprey_eeprom(struct bttv *btv, const u8 ee[256]);
> @@ -3679,13 +3675,6 @@
>  	if (bttv_tvcards[btv->c.type].audio_mode_gpio)
>  		btv->audio_mode_gpio=bttv_tvcards[btv->c.type].audio_mode_gpio;
>  
> -	if (bttv_tvcards[btv->c.type].digital_mode == DIGITAL_MODE_CAMERA) {
> -		/* detect Bt832 chip for quartzsight digital camera */
> -		if ((bttv_I2CRead(btv, I2C_ADDR_BT832_ALT1, "Bt832") >=0) ||
> -		    (bttv_I2CRead(btv, I2C_ADDR_BT832_ALT2, "Bt832") >=0))
> -			boot_bt832(btv);
> -	}
> -
>  	if (!autoload)
>  		return;
>  
> @@ -4086,40 +4075,6 @@
>  	if (bttv_verbose)
>  		printk(KERN_INFO "bttv%d: Hauppauge/Voodoo msp34xx: reset line "
>  		       "init [%d]\n", btv->c.nr, pin);
> -}
> -
> -static void __devinit boot_bt832(struct bttv *btv)
> -{
> -#if 0 /* not working yet */
> -	int resetbit=0;
> -
> -	switch (btv->c.type) {
> -	case BTTV_BOARD_PXELVWPLTVPAK:
> -		resetbit = 0x400000;
> -		break;
> -	case BTTV_BOARD_MODTEC_205:
> -		resetbit = 1<<9;
> -		break;
> -	default:
> -		BUG();
> -	}
> -
> -	request_module("bt832");
> -	bttv_call_i2c_clients(btv, BT832_HEXDUMP, NULL);
> -
> -	printk("bttv%d: Reset Bt832 [line=0x%x]\n",btv->c.nr,resetbit);
> -	gpio_write(0);
> -	gpio_inout(resetbit, resetbit);
> -	udelay(5);
> -	gpio_bits(resetbit, resetbit);
> -	udelay(5);
> -	gpio_bits(resetbit, 0);
> -	udelay(5);
> -
> -	/* bt832 on pixelview changes from i2c 0x8a to 0x88 after
> -	 * being reset as above. So we must follow by this: */
> -	bttv_call_i2c_clients(btv, BT832_REATTACH, NULL);
> -#endif
>  }
>  
>  /* ----------------------------------------------------------------------- */
> diff -r 02bfc69e3849 linux/include/media/i2c-addr.h
> --- a/linux/include/media/i2c-addr.h	Mon Jul 28 18:07:35 2008 -0300
> +++ b/linux/include/media/i2c-addr.h	Tue Jul 29 12:16:22 2008 -0300
> @@ -12,8 +12,6 @@
>  /* bttv address list */
>  #define I2C_ADDR_TSA5522	0xc2
>  #define I2C_ADDR_TDA7432	0x8a
> -#define I2C_ADDR_BT832_ALT1	0x88
> -#define I2C_ADDR_BT832_ALT2	0x8a // alternate setting
>  #define I2C_ADDR_TDA8425	0x82
>  #define I2C_ADDR_TDA9840	0x84
>  #define I2C_ADDR_TDA9850	0xb6 /* also used by 9855,9873 */
> 
> 
> 
> Cheers,
> Mauro
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
