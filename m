Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@me.by>) id 1Jd93W-0007Ih-RY
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 20:07:03 +0100
Received: by ug-out-1314.google.com with SMTP id o29so2717782ugd.20
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 12:06:55 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 21:07:35 +0200
References: <477E3CBF.30504@gmail.com>
In-Reply-To: <477E3CBF.30504@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3jV5HnnelMyi60d"
Message-Id: <200803222107.35700.liplianin@me.by>
Subject: Re: [linux-dvb] DM713S / Is it possible to run under Linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_3jV5HnnelMyi60d
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 4 January 2008 16:03:43 dooooo =CE=
=C1=D0=C9=D3=C1=CC(=C1):
> hi
> I bought a dvb-s pci card last year . It's Brand is Orange
> (orangetek.org <http://orangetek.org>) which is a Dubai based company .
> I installed the drivers
> provided by LinuxTV but the device is still not recognised as a dvb
> device (still /dev/vbi0) .
> running lspci :
> 02:05.0 Ethernet controller: Unknown device 195d:1105 (rev 10)
>
> The device name is DM713S .
>
> Windows Driver Files :<attached>
> DM1105Cap.inf
> DM1105Cap.sys
>
> I hope that I'll be able to use this device under Linux .
>
> Thanks in advance .

=46eel free to try it/ modify it and do not forget
to e-mail results.
=2D-=20
Igor M. Liplianin

--Boundary-00=_3jV5HnnelMyi60d
Content-Type: text/x-diff;
  charset="koi8-r";
  name="dvb-igorlipl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dvb-igorlipl.diff"

diff -crN linux-2.6.23.12.orig/drivers/media/dvb/Kconfig linux-2.6.23.12.new/drivers/media/dvb/Kconfig
*** linux-2.6.23.12.orig/drivers/media/dvb/Kconfig	2008-01-10 22:13:17.000000000 +0200
--- linux-2.6.23.12.new/drivers/media/dvb/Kconfig	2007-12-21 00:11:48.000000000 +0200
***************
*** 36,41 ****
--- 36,45 ----
  	depends on DVB_CORE && PCI && I2C
  source "drivers/media/dvb/pluto2/Kconfig"
  
+ comment "Supported DM1105 Adapters"
+ 	depends on DVB_CORE && PCI && I2C
+ source "drivers/media/dvb/dm1105/Kconfig"
+ 
  comment "Supported DVB Frontends"
  	depends on DVB_CORE
  source "drivers/media/dvb/frontends/Kconfig"
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/Makefile linux-2.6.23.12.new/drivers/media/dvb/Makefile
*** linux-2.6.23.12.orig/drivers/media/dvb/Makefile	2008-01-10 22:13:17.000000000 +0200
--- linux-2.6.23.12.new/drivers/media/dvb/Makefile	2007-12-21 00:11:48.000000000 +0200
***************
*** 2,5 ****
  # Makefile for the kernel multimedia device drivers.
  #
  
! obj-y        := dvb-core/ frontends/ ttpci/ ttusb-dec/ ttusb-budget/ b2c2/ bt8xx/ cinergyT2/ dvb-usb/ pluto2/
--- 2,5 ----
  # Makefile for the kernel multimedia device drivers.
  #
  
! obj-y        := dvb-core/ frontends/ ttpci/ ttusb-dec/ ttusb-budget/ b2c2/ bt8xx/ cinergyT2/ dvb-usb/ pluto2/ dm1105/
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dm1105/Kconfig linux-2.6.23.12.new/drivers/media/dvb/dm1105/Kconfig
*** linux-2.6.23.12.orig/drivers/media/dvb/dm1105/Kconfig	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/dm1105/Kconfig	2007-12-21 00:11:48.000000000 +0200
***************
*** 0 ****
--- 1,15 ----
+ config DVB_DM1105
+ 	tristate "DM1105 based cards"
+ 	depends on DVB_CORE && PCI && I2C
+ 	select DVB_PLL if !DVB_FE_CUSTOMISE
+ 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+ 	help
+ 	  Support for PCI cards based on the DM1105 like the Acorp 
+ 	  DS110.
+ 
+ 	  Since these cards have no MPEG decoder onboard, they transmit
+ 	  only compressed MPEG data over the PCI bus, so you need
+ 	  an external software decoder to watch TV on your computer.
+ 
+ 	  Say Y or M if you own such a device and want to use it.
+ 
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dm1105/Makefile linux-2.6.23.12.new/drivers/media/dvb/dm1105/Makefile
*** linux-2.6.23.12.orig/drivers/media/dvb/dm1105/Makefile	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/dm1105/Makefile	2008-03-19 19:01:31.000000000 +0200
***************
*** 0 ****
--- 1,3 ----
+ obj-$(CONFIG_DVB_DM1105) += dm1105.o
+ 
+ EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dm1105/dm1105.c linux-2.6.23.12.new/drivers/media/dvb/dm1105/dm1105.c
*** linux-2.6.23.12.orig/drivers/media/dvb/dm1105/dm1105.c	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/dm1105/dm1105.c	2008-03-19 19:54:48.000000000 +0200
***************
*** 0 ****
--- 1,849 ----
+ /*
+  * dm1105.c - DVBWorld  PCI2002 [DVB-S]
+  *
+  * Copyright (C) 2007 Igor M. Liplianin <liplianin@me.by>
+  *
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License as published by
+  * the Free Software Foundation; either version 2 of the License, or
+  * (at your option) any later version.
+  *
+  * This program is distributed in the hope that it will be useful,
+  * but WITHOUT ANY WARRANTY; without even the implied warranty of
+  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  * GNU General Public License for more details.
+  *
+  * You should have received a copy of the GNU General Public License
+  * along with this program; if not, write to the Free Software
+  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  *
+  */
+ 
+ #include <linux/i2c.h>
+ #include <linux/init.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/proc_fs.h>
+ #include <linux/pci.h>
+ #include <linux/dma-mapping.h>
+ #include <linux/input.h>
+ #include <media/ir-common.h>
+ 
+ #include "demux.h"
+ #include "dmxdev.h"
+ #include "dvb_demux.h"
+ #include "dvb_frontend.h"
+ #include "dvb_net.h"
+ #include "dvbdev.h"
+ #include "dvb-pll.h"
+ 
+ #include "stv0299.h"
+ #include "z0194a.h"
+ 
+ /* ----------------------------------------------- */
+ /*
+  * PCI ID's
+  */
+ #ifndef PCI_VENDOR_ID_TRIGEM
+ #define PCI_VENDOR_ID_TRIGEM	0x109f
+ #endif
+ #ifndef PCI_VENDOR_ID_AXESS
+ #define PCI_VENDOR_ID_AXESS	0x195d
+ #endif
+ #ifndef PCI_DEVICE_ID_DM1105
+ #define PCI_DEVICE_ID_DM1105	0x036f
+ #endif
+ #ifndef PCI_DEVICE_ID_DM1105S
+ #define PCI_DEVICE_ID_DM1105S	0x1105
+ #endif
+ #ifndef PCI_DEVICE_ID_DW2002
+ #define PCI_DEVICE_ID_DW2002	0x2002
+ #endif
+ #ifndef PCI_DEVICE_ID_DM05
+ #define PCI_DEVICE_ID_DM05	0x1105
+ #endif
+ /* ----------------------------------------------- */
+ /* sdmc dm1105 registers */
+ 
+ /* TS Control */
+ #define DM1105_TSCTR				0x00
+ #define DM1105_DTALENTH				0x04
+ 
+ /* GPIO Interface */
+ #define DM1105_GPIOVAL				0x08
+ #define DM1105_GPIOCTR				0x0c
+ 
+ /* PID serial number */
+ #define DM1105_PIDN				0x10
+ 
+ /* Odd-even secret key select */
+ #define DM1105_CWSEL				0x14
+ 
+ /* Host Command Interface */
+ #define DM1105_HOST_CTR				0x18
+ #define DM1105_HOST_AD				0x1c
+ 
+ /* PCI Interface */
+ #define DM1105_CR				0x30
+ #define DM1105_RST				0x34
+ #define DM1105_STADR				0x38
+ #define DM1105_RLEN				0x3c
+ #define DM1105_WRP				0x40
+ #define DM1105_INTCNT				0x44
+ #define DM1105_INTMAK				0x48
+ #define DM1105_INTSTS				0x4c
+ 
+ /* CW Value */
+ #define DM1105_ODD				0x50
+ #define DM1105_EVEN				0x58
+ 
+ /* PID Value */
+ #define DM1105_PID				0x60
+ 
+ /* IR Control */
+ #define DM1105_IRCTR				0x64
+ #define DM1105_IRMODE				0x68
+ #define DM1105_SYSTEMCODE			0x6c
+ #define DM1105_IRCODE				0x70
+ 
+ /* Unknown Values */
+ #define DM1105_ENCRYPT				0x74
+ #define DM1105_VER				0x7c
+ 
+ /* I2C Interface */
+ #define DM1105_I2CCTR				0x80
+ #define DM1105_I2CSTS				0x81
+ #define DM1105_I2CDAT				0x82
+ #define DM1105_I2C_RA				0x83
+ /* ----------------------------------------------- */
+ /* Interrupt Mask Bits */
+ 
+ #define INTMAK_TSIRQM				0x01
+ #define INTMAK_HIRQM				0x04
+ #define INTMAK_IRM				0x08
+ #define INTMAK_ALLMASK				(INTMAK_TSIRQM | INTMAK_HIRQM | INTMAK_IRM)
+ #define INTMAK_NONEMASK				0x00
+ 
+ /* Interrupt Status Bits */
+ #define INTSTS_TSIRQ				0x01
+ #define INTSTS_HIRQ				0x04
+ #define INTSTS_IR				0x08
+ 
+ /* IR Control Bits */
+ #define DM1105_IR_EN				0x01
+ #define DM1105_SYS_CHK				0x02
+ #define DM1105_REP_FLG				0x08
+ 
+ /* EEPROM addr */
+ #define IIC_24C01_addr				0xa0
+ /* Max board count */
+ #define DM1105_MAX				0x04
+ 
+ #define DRIVER_NAME				"dm1105"
+ 
+ #define DM1105_DMA_PACKETS			47
+ #define DM1105_DMA_PACKET_LENGTH		(128*4)
+ #define DM1105_DMA_BYTES			(128 * 4 * DM1105_DMA_PACKETS)
+ 
+ /* GPIO's for LNB power control for Dvbworld DW2002 */
+ #define DW2002_LNB_MASK				0x00000000 //0xfffcffff
+ #define DW2002_LNB_13V				0x00010100 //0x1ffff
+ #define DW2002_LNB_18V				0x00000100 //0x0ffff
+ 
+ /* GPIO's for LNB power control for Axess DM05 - EXPERIMENTAL!*/
+ #define DM05_LNB_MASK				0xfffffffc
+ #define DM05_LNB_13V				0x3fffd
+ #define DM05_LNB_18V				0x3fffc
+ 
+ static int ir_debug = 0;
+ module_param(ir_debug, int, 0644);
+ MODULE_PARM_DESC(ir_debug, "enable debugging information for IR decoding");
+ 
+ static u16 ir_codes_dm1105_nec[128] = {
+ 	[ 0x0a ] = KEY_Q,		/*power*/
+ 	[ 0x0c ] = KEY_M,		/*mute*/
+ 	[ 0x11 ] = KEY_1,
+ 	[ 0x12 ] = KEY_2,
+ 	[ 0x13 ] = KEY_3,
+ 	[ 0x14 ] = KEY_4,
+ 	[ 0x15 ] = KEY_5,
+ 	[ 0x16 ] = KEY_6,
+ 	[ 0x17 ] = KEY_7,
+ 	[ 0x18 ] = KEY_8,
+ 	[ 0x19 ] = KEY_9,
+ 	[ 0x10 ] = KEY_0,
+ 	[ 0x1c ] = KEY_PAGEUP,		/*ch+*/
+ 	[ 0x0f ] = KEY_PAGEDOWN,	/*ch-*/
+ 	[ 0x1a ] = KEY_O,		/*vol+*/
+ 	[ 0x0e ] = KEY_Z,		/*vol-*/
+ 	[ 0x04 ] = KEY_R,		/*rec*/
+ 	[ 0x09 ] = KEY_D,		/*fav*/
+ 	[ 0x08 ] = KEY_BACKSPACE,	/*rewind*/
+ 	[ 0x07 ] = KEY_A,		/*fast*/
+ 	[ 0x0b ] = KEY_P,		/*pause*/
+ 	[ 0x02 ] = KEY_ESC,		/*cancel*/
+ 	[ 0x03 ] = KEY_G,		/*tab*/
+ 	[ 0x00 ] = KEY_UP,		/*up*/
+ 	[ 0x1f ] = KEY_ENTER,		/*ok*/
+ 	[ 0x01 ] = KEY_DOWN,		/*down*/
+ 	[ 0x05 ] = KEY_C,		/*cap*/
+ 	[ 0x06 ] = KEY_S,		/*stop*/
+ 	[ 0x40 ] = KEY_F,		/*full*/
+ 	[ 0x1e ] = KEY_W,		/*tvmode*/
+ 	[ 0x1b ] = KEY_B,		/*recall*/
+ };
+ 
+ /* infrared remote control */
+ struct infrared {
+ 	u16	key_map[128];
+ 	struct input_dev	*input_dev;
+ 	char			input_phys[32];
+ 	struct tasklet_struct	ir_tasklet;
+ 	u32			ir_command;
+ };
+ 
+ struct dm1105dvb {
+ 	/* pci */
+ 	struct pci_dev *pdev;
+ 	u8 __iomem *io_mem;
+ 	
+ 	/* ir */
+ 	struct infrared ir;
+ 
+ 	/* dvb */
+ 	struct dmx_frontend hw_frontend;
+ 	struct dmx_frontend mem_frontend;
+ 	struct dmxdev dmxdev;
+ 	struct dvb_adapter dvb_adapter;
+ 	struct dvb_demux demux;
+ 	struct dvb_frontend *fe;
+ 	struct dvb_net dvbnet;
+ 	unsigned int full_ts_users;
+ 	
+ 	/* i2c */
+ 	struct i2c_adapter i2c_adap;
+ 
+ 	/* dma */
+ 	dma_addr_t dma_addr;
+ 	unsigned char *ts_buf;
+ 	u32 wrp;
+ 	u32 buffer_size;
+ 	unsigned int	PacketErrorCount;
+ 	unsigned int dmarst;
+ 	spinlock_t lock;
+ 
+ };
+ 
+ static struct dm1105dvb *dm1105dvb_local;
+ 
+ static int dm1105_i2c_xfer(struct i2c_adapter *i2c_adap,
+ 			    struct i2c_msg *msgs, int num)
+ {
+ 	struct dm1105dvb *dm1105dvb ;
+ 
+ 	int addr,rc,i,j,byte,data;
+ 	void	*ioaddr;
+ 	u8 status;
+ 	
+ 	dm1105dvb = i2c_adap->algo_data;
+ 	ioaddr = dm1105dvb->io_mem;
+ 	for (i = 0; i < num; i++) {
+ 		outb(0x00, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CCTR]));
+ 		if (msgs[i].flags & I2C_M_RD) {
+ 			/* read bytes */
+ 			addr  = msgs[i].addr << 1;
+ 			addr |= 1;
+ 			outb(addr, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CDAT]));
+ 			for (byte = 0; byte < msgs[i].len; byte++) {
+ 				outb(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CDAT+byte+1]));
+ 			}
+ 			outb(0x81 + msgs[i].len, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CCTR]));
+ 			for (j = 0; j < 55; i++){
+ 				mdelay (10);  // 10ms
+ 				status = inb((unsigned long)&dm1105dvb->io_mem[DM1105_I2CSTS]);
+ 				if ((status & 0xc0) == 0x40)
+ 					break;
+ 			}
+ 			if (j >= 55){
+ 				return -1;
+ 			}
+ 			for (byte = 0; byte < msgs[i].len; byte++) {
+ 				
+ 				rc = inb((unsigned long)(&dm1105dvb->io_mem[DM1105_I2CDAT+byte+1]));
+ 				if (rc < 0)
+ 					goto err;
+ 				msgs[i].buf[byte] = rc;
+ 			
+ 			}
+ 		} else {
+ 			/* write bytes */
+ 			outb(msgs[i].addr<<1, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CDAT]));
+ 			for (byte = 0; byte < msgs[i].len; byte++) {
+ 				data = msgs[i].buf[byte];
+ 				outb(data, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CDAT+byte+1]));
+ 			}
+ 			outb(0x81 + msgs[i].len, (unsigned long)(&dm1105dvb->io_mem[DM1105_I2CCTR]));
+ 			for (j = 0; j < 25; i++){
+ 				mdelay (10);  // 10ms
+ 				status = inb((unsigned long)(&dm1105dvb->io_mem[DM1105_I2CSTS]));
+ 				if ((status & 0xc0) == 0x40)
+ 					break;
+ 			}
+ 	
+ 			if (j >= 25){
+ 				return -1;
+ 			}
+ 		}
+ 	}
+ 	return num;
+  err:
+ 	return rc;
+ }
+ 
+ static u32 functionality(struct i2c_adapter *adap)
+ {
+ 	return I2C_FUNC_I2C;
+ }
+ 
+ static struct i2c_algorithm dm1105_algo = {
+ 	.master_xfer   = dm1105_i2c_xfer,
+ 	.functionality = functionality,
+ };
+ 
+ static inline struct dm1105dvb *feed_to_dm1105dvb(struct dvb_demux_feed *feed)
+ {
+ 	return container_of(feed->demux, struct dm1105dvb, demux);
+ }
+ 
+ static inline struct dm1105dvb *frontend_to_dm1105dvb(struct dvb_frontend *fe)
+ {
+ 	return container_of(fe->dvb, struct dm1105dvb, dvb_adapter);
+ }
+ 
+ static int dm1105dvb_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+ {
+ 	struct dm1105dvb *dm1105dvb = frontend_to_dm1105dvb(fe);
+ 
+ 	switch (dm1105dvb->pdev->subsystem_device){
+ 	case PCI_DEVICE_ID_DW2002:
+ 		if (voltage == SEC_VOLTAGE_18) {
+ 		outl(DW2002_LNB_MASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOCTR]));
+ 		outl(DW2002_LNB_18V, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOVAL]));
+ 		}else	{
+ 		/*LNB ON-13V by default!*/
+ 		outl(DW2002_LNB_MASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOCTR]));
+ 		outl(DW2002_LNB_13V, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOVAL]));
+ 		}
+ 		break;
+ 	case PCI_DEVICE_ID_DM05:
+ 		if (voltage == SEC_VOLTAGE_18) {
+ 		outl(DM05_LNB_MASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOCTR]));
+ 		outl(DM05_LNB_18V, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOVAL]));
+ 		}else	{
+ 		/*LNB ON-13V by default!*/
+ 		outl(DM05_LNB_MASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOCTR]));
+ 		outl(DM05_LNB_13V, (unsigned long)(&dm1105dvb->io_mem[DM1105_GPIOVAL]));
+ 		}
+ 		break;
+ 	}
+ 
+ 	return 0;
+ }
+ 
+ static void dm1105dvb_set_dma_addr(struct dm1105dvb *dm1105dvb)
+ {
+ 	outl(cpu_to_le32(dm1105dvb->dma_addr), (unsigned long)(&dm1105dvb->io_mem[DM1105_STADR]));
+ }
+ 
+ static int __devinit dm1105dvb_dma_map(struct dm1105dvb *dm1105dvb)
+ {
+ 	dm1105dvb->ts_buf = pci_alloc_consistent(dm1105dvb->pdev, 6*DM1105_DMA_BYTES, &dm1105dvb->dma_addr);
+ 
+ 	return pci_dma_mapping_error(dm1105dvb->dma_addr);
+ }
+ 
+ static void dm1105dvb_dma_unmap(struct dm1105dvb *dm1105dvb)
+ {
+ 	pci_free_consistent(dm1105dvb->pdev, 6*DM1105_DMA_BYTES, dm1105dvb->ts_buf, dm1105dvb->dma_addr);
+ }
+ 
+ static void __devinit dm1105dvb_enable_irqs(struct dm1105dvb *dm1105dvb)
+ {
+ 	outb(INTMAK_ALLMASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_INTMAK]));
+ 	outb(1, (unsigned long)(&dm1105dvb->io_mem[DM1105_CR]));
+ }
+ 
+ static void dm1105dvb_disable_irqs(struct dm1105dvb *dm1105dvb)
+ {
+ 	outb(INTMAK_IRM, (unsigned long)(&dm1105dvb->io_mem[DM1105_INTMAK]));
+ 	outb(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_CR]));
+ }
+ 
+ static int dm1105dvb_start_feed(struct dvb_demux_feed *f)
+ {
+ 	struct dm1105dvb *dm1105dvb = feed_to_dm1105dvb(f);
+ 
+ 	if (dm1105dvb->full_ts_users++ == 0){
+ 		dm1105dvb_enable_irqs(dm1105dvb);
+ 	}
+ 	return 0;
+ }
+ 
+ static int dm1105dvb_stop_feed(struct dvb_demux_feed *f)
+ {
+ 	struct dm1105dvb *dm1105dvb = feed_to_dm1105dvb(f);
+ 
+ 	if (--dm1105dvb->full_ts_users == 0){
+ 		dm1105dvb_disable_irqs(dm1105dvb);
+ 	}
+ 	return 0;
+ }
+ 
+ /* ir tasklet */
+ static void dm1105_emit_key(unsigned long parm)
+ {
+ 	struct infrared *ir = (struct infrared *) parm;
+ 	u32 ircom = ir->ir_command;
+ 	u8 data;
+ 	u16 keycode;
+ 
+ 	data = (ircom >> 8) & 0x7f;
+ 
+ 	input_event(ir->input_dev, EV_MSC, MSC_RAW, (0x0000f8 << 16) | data);
+ 	input_event(ir->input_dev, EV_MSC, MSC_SCAN, data);
+ 	keycode = ir->key_map[data];
+ 
+ 	if (!keycode) {
+ 		return;
+ 	}
+ 	input_event(ir->input_dev, EV_KEY, keycode, 1);
+ 	input_sync(ir->input_dev);
+ 	input_event(ir->input_dev, EV_KEY, keycode, 0);
+ 	input_sync(ir->input_dev);
+ 
+ }
+ 
+ static irqreturn_t dm1105dvb_irq(int irq, void *dev_id)
+ {
+  	struct dm1105dvb *dm1105dvb = dev_id;
+  	unsigned int piece;
+ 	unsigned int nbpackets;
+ 	u32 command;
+ 	u32 nextwrp;
+ 	u32 oldwrp;
+ 
+ 	/* Read-Write INSTS Ack's Interrupt for DM1105 chip 16.03.2008 */
+ 	unsigned int intsts = inb((unsigned long)(&dm1105dvb->io_mem[DM1105_INTSTS]));
+ 	outb(intsts, (unsigned long)(&dm1105dvb->io_mem[DM1105_INTSTS]));
+ 		
+ 	switch (intsts){
+ 	case INTSTS_TSIRQ:
+ 	case (INTSTS_TSIRQ | INTSTS_IR):
+ 		nextwrp = inl((unsigned long)(&dm1105dvb->io_mem[DM1105_WRP])) - 
+ 			inl((unsigned long)(&dm1105dvb->io_mem[DM1105_STADR])) ;
+ 		oldwrp = dm1105dvb->wrp;
+ 		spin_lock(&dm1105dvb->lock);
+ 		if (!((dm1105dvb->ts_buf[oldwrp] == 0x47 ) && (dm1105dvb->ts_buf[oldwrp + 188]== 0x47 )	
+ 		&& (dm1105dvb->ts_buf[oldwrp + 188*2] == 0x47))) {
+ 			dm1105dvb->PacketErrorCount++;
+ 			/*printk("Bad Packet Found! DM1105 Device Reset !  ----%06x ----%06x\n",oldwrp,nextwrp);*/
+ 			if((dm1105dvb->PacketErrorCount >= 2)&&(dm1105dvb->dmarst == 0)){
+ 				outb(1, (unsigned long)(&dm1105dvb->io_mem[DM1105_RST]));
+ 				dm1105dvb->wrp = 0;
+ 				dm1105dvb->PacketErrorCount = 0;
+ 				dm1105dvb->dmarst = 0;
+ 				spin_unlock(&dm1105dvb->lock);
+ 				return IRQ_HANDLED;
+ 			}
+ 		}
+ 		if (nextwrp < oldwrp){
+ 			piece = dm1105dvb->buffer_size - oldwrp;
+ 			memcpy(dm1105dvb->ts_buf + dm1105dvb->buffer_size, dm1105dvb->ts_buf, nextwrp);
+ 			nbpackets = (piece + nextwrp)/188;
+ 		}else	{
+ 			nbpackets = (nextwrp - oldwrp)/188;
+ 		}
+ 		dvb_dmx_swfilter_packets(&dm1105dvb->demux, &dm1105dvb->ts_buf[oldwrp], nbpackets);
+ 		dm1105dvb->wrp = nextwrp;
+ 		spin_unlock(&dm1105dvb->lock);
+ 		break;
+ 	case INTSTS_IR:
+ 		command = inl((unsigned long)(&dm1105dvb->io_mem[DM1105_IRCODE]));
+ 		if (ir_debug){
+ 		    printk("dm1105: received byte 0x%04x\n", command);
+ 		}
+ 		dm1105dvb->ir.ir_command = command;// >> 8) & 0x7f;
+ 		tasklet_schedule(&dm1105dvb->ir.ir_tasklet);
+ 		break;
+ 	}
+ 	return IRQ_HANDLED;
+ 
+ 
+ }
+ 
+ /* register with input layer */
+ static void input_register_keys(struct infrared *ir)
+ {
+ 	int i;
+ 
+ 	memset(ir->input_dev->keybit, 0, sizeof(ir->input_dev->keybit));
+ 
+ 	for (i = 0; i < ARRAY_SIZE(ir->key_map); i++) {
+ 			set_bit(ir->key_map[i], ir->input_dev->keybit);
+ 	}
+ 
+ 	ir->input_dev->keycode = ir->key_map;
+ 	ir->input_dev->keycodesize = sizeof(ir->key_map[0]);
+ 	ir->input_dev->keycodemax = ARRAY_SIZE(ir->key_map);
+ }
+ 
+ int __devinit dm1105_ir_init(struct dm1105dvb *dm1105)
+ {
+ 	struct input_dev *input_dev;
+ 	int err;
+ 
+ 	dm1105dvb_local = dm1105;
+ 
+ 	input_dev = input_allocate_device();
+ 	if (!input_dev)
+ 		return -ENOMEM;
+ 
+ 	dm1105->ir.input_dev = input_dev;
+ 	snprintf(dm1105->ir.input_phys, sizeof(dm1105->ir.input_phys),
+ 		"pci-%s/ir0", pci_name(dm1105->pdev));
+ 	
+ 	input_dev->evbit[0] = BIT(EV_KEY);
+ 	input_dev->name = "DVB on-card IR receiver";
+ 
+ 	input_dev->phys = dm1105->ir.input_phys;
+ 	input_dev->id.bustype = BUS_PCI;
+ 	input_dev->id.version = 2;
+ 	if (dm1105->pdev->subsystem_vendor) {
+ 		input_dev->id.vendor = dm1105->pdev->subsystem_vendor;
+ 		input_dev->id.product = dm1105->pdev->subsystem_device;
+ 	} else {
+ 		input_dev->id.vendor = dm1105->pdev->vendor;
+ 		input_dev->id.product = dm1105->pdev->device;
+ 	}
+ 	input_dev->dev.parent = &dm1105->pdev->dev;
+ 	/* initial keymap */
+ 	memcpy(dm1105->ir.key_map, ir_codes_dm1105_nec, sizeof dm1105->ir.key_map);
+ 	input_register_keys(&dm1105->ir);
+ 	err = input_register_device(input_dev);
+ 	if (err) {
+ 		input_free_device(input_dev);
+ 		return err;
+ 	}
+ 
+ 	tasklet_init(&dm1105->ir.ir_tasklet, dm1105_emit_key, (unsigned long) &dm1105->ir);
+ 
+ 	return 0;
+ }
+ 
+ 
+ void __devexit dm1105_ir_exit(struct dm1105dvb *dm1105)
+ {
+ 	tasklet_kill(&dm1105->ir.ir_tasklet);
+ 	input_unregister_device(dm1105->ir.input_dev);
+ 
+ }
+ 
+ static int __devinit dm1105dvb_hw_init(struct dm1105dvb *dm1105dvb)
+ {
+ 	dm1105dvb_disable_irqs(dm1105dvb);
+ 	
+ 	outb(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_HOST_CTR]));
+ 	
+ 	/*DATALEN 188,*/ 
+ 	outb(188, (unsigned long)(&dm1105dvb->io_mem[DM1105_DTALENTH]));	
+ 	/*TS_STRT TS_VALP MSBFIRST TS_MODE ALPAS TSPES*/
+ 	outw(0xc10a, (unsigned long)(&dm1105dvb->io_mem[DM1105_TSCTR]));
+ 	
+ 	/* map DMA and set address */
+ 	dm1105dvb_dma_map(dm1105dvb);
+ 	dm1105dvb_set_dma_addr(dm1105dvb);
+ 	/* big buffer */
+ 	outl(5*DM1105_DMA_BYTES, (unsigned long)(&dm1105dvb->io_mem[DM1105_RLEN]));
+ 	outb(47, (unsigned long)(&dm1105dvb->io_mem[DM1105_INTCNT]));
+ 	
+ 	/* IR NEC mode enable */
+ 	outb((DM1105_IR_EN | DM1105_SYS_CHK), (unsigned long)(&dm1105dvb->io_mem[DM1105_IRCTR]));
+ 	outb(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_IRMODE]));
+ 	outw(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_SYSTEMCODE]));
+ 	
+ 	return 0;
+ }
+ 	
+ static void dm1105dvb_hw_exit(struct dm1105dvb *dm1105dvb)
+ {
+ 	dm1105dvb_disable_irqs(dm1105dvb);
+ 
+ 	/* IR disable */
+ 	outb(0, (unsigned long)(&dm1105dvb->io_mem[DM1105_IRCTR]));
+ 	outb(INTMAK_NONEMASK, (unsigned long)(&dm1105dvb->io_mem[DM1105_INTMAK]));
+ 
+ 	dm1105dvb_dma_unmap(dm1105dvb);
+ }
+ 
+ static int __devinit frontend_init(struct dm1105dvb *dm1105dvb)
+ {
+ 	int ret;
+ 
+ 	dm1105dvb->fe = dvb_attach(
+ 		stv0299_attach, &sharp_z0194a_config,
+ 		&dm1105dvb->i2c_adap);
+ 	
+ 	if (!dm1105dvb->fe) {
+ 		dev_err(&dm1105dvb->pdev->dev, "could not attach frontend\n");
+ 		return -ENODEV;
+ 	}
+ 	dm1105dvb->fe->ops.set_voltage = dm1105dvb_set_voltage;
+ 
+ 	dvb_attach(
+ 		dvb_pll_attach, dm1105dvb->fe, 0x60,
+ 		&dm1105dvb->i2c_adap, DVB_PLL_OPERA1);
+ 
+ 
+ 	ret = dvb_register_frontend(&dm1105dvb->dvb_adapter, dm1105dvb->fe);
+ 	if (ret < 0) {
+ 		if (dm1105dvb->fe->ops.release)
+ 			dm1105dvb->fe->ops.release(dm1105dvb->fe);
+ 		dm1105dvb->fe = NULL;
+ 		return ret;
+ 	}
+ 
+ 	return 0;
+ }
+ 
+ static void __devinit dm1105dvb_read_mac(struct dm1105dvb *dm1105dvb, u8 *mac)
+ {
+ 	static u8 command[1]={0x28};
+ 
+ 	struct i2c_msg msg[] = {
+ 		{.addr = IIC_24C01_addr>>1, .flags = 0, .buf = command, .len = 1},
+ 		{.addr = IIC_24C01_addr>>1, .flags = I2C_M_RD, .buf = mac, .len = 6},
+ 	};
+ 
+ 	dm1105_i2c_xfer(&dm1105dvb->i2c_adap, msg , 2);
+ 	dev_info(&dm1105dvb->pdev->dev, "MAC %02x:%02x:%02x:%02x:%02x:%02x\n",
+ 			mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+ }
+ 
+ static int __devinit dm1105_probe(struct pci_dev *pdev,
+ 				  const struct pci_device_id *ent)
+ {
+ 	struct dm1105dvb *dm1105dvb;
+ 	struct dvb_adapter *dvb_adapter;
+ 	struct dvb_demux *dvbdemux;
+ 	struct dmx_demux *dmx;
+ 	int ret = -ENOMEM;
+ 	
+ 	dm1105dvb = kzalloc(sizeof(struct dm1105dvb), GFP_KERNEL);
+ 	if (!dm1105dvb)
+ 		goto out;
+ 
+ 	dm1105dvb->pdev = pdev;
+ 	dm1105dvb->buffer_size = 5*DM1105_DMA_BYTES;
+ 	dm1105dvb->PacketErrorCount = 0;
+ 	dm1105dvb->dmarst = 0;
+ 		
+ 	ret = pci_enable_device(pdev);
+ 	if (ret < 0)
+ 		goto err_kfree;
+ 
+ 	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+ 	if (ret < 0)
+ 		goto err_pci_disable_device;
+ 
+ 	pci_set_master(pdev);
+ 
+ 	ret = pci_request_regions(pdev, DRIVER_NAME);
+ 	if (ret < 0)
+ 		goto err_pci_disable_device;
+ 
+ 	dm1105dvb->io_mem = pci_iomap(pdev, 0, pci_resource_len (pdev, 0));
+ 	if (!dm1105dvb->io_mem) {
+ 		ret = -EIO;
+ 		goto err_pci_release_regions;
+ 	}
+ 	
+ 	spin_lock_init (&dm1105dvb->lock);
+ 	pci_set_drvdata(pdev, dm1105dvb);
+ 
+ 	ret = request_irq(pdev->irq, dm1105dvb_irq, IRQF_SHARED, DRIVER_NAME, dm1105dvb);
+ 	if (ret < 0)
+ 		goto err_pci_iounmap;
+ 
+ 	ret = dm1105dvb_hw_init(dm1105dvb);
+ 	if (ret < 0)
+ 		goto err_free_irq;
+ 
+ 	/* i2c */
+ 	i2c_set_adapdata(&dm1105dvb->i2c_adap, dm1105dvb);
+ 	strcpy(dm1105dvb->i2c_adap.name, DRIVER_NAME);
+ 	dm1105dvb->i2c_adap.owner = THIS_MODULE;
+ 	dm1105dvb->i2c_adap.class = I2C_CLASS_TV_DIGITAL;
+ 	dm1105dvb->i2c_adap.dev.parent = &pdev->dev;
+ 	dm1105dvb->i2c_adap.algo = &dm1105_algo;
+ 	dm1105dvb->i2c_adap.algo_data = dm1105dvb;
+ 	ret = i2c_add_adapter(&dm1105dvb->i2c_adap);
+ 
+ 	if (ret < 0)
+ 		goto err_dm1105dvb_hw_exit;
+ 
+ 	/* dvb */
+ 	ret = dvb_register_adapter(&dm1105dvb->dvb_adapter, DRIVER_NAME, THIS_MODULE, &pdev->dev);
+ 	if (ret < 0)
+ 		goto err_i2c_del_adapter;
+ 
+ 	dvb_adapter = &dm1105dvb->dvb_adapter;
+ 
+ 	dm1105dvb_read_mac(dm1105dvb, dvb_adapter->proposed_mac);
+ 	
+ 	dvbdemux = &dm1105dvb->demux;
+ 	dvbdemux->filternum = 256;
+ 	dvbdemux->feednum = 256;
+ 	dvbdemux->start_feed = dm1105dvb_start_feed;
+ 	dvbdemux->stop_feed = dm1105dvb_stop_feed;
+ 	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
+ 			DMX_SECTION_FILTERING | DMX_MEMORY_BASED_FILTERING);
+ 	ret = dvb_dmx_init(dvbdemux);
+ 	if (ret < 0)
+ 		goto err_dvb_unregister_adapter;
+ 
+ 	dmx = &dvbdemux->dmx;
+ 	dm1105dvb->dmxdev.filternum = 256;
+ 	dm1105dvb->dmxdev.demux = dmx;
+ 	dm1105dvb->dmxdev.capabilities = 0;
+ 
+ 	ret = dvb_dmxdev_init(&dm1105dvb->dmxdev, dvb_adapter);
+ 	if (ret < 0)
+ 		goto err_dvb_dmx_release;
+ 	
+ 	dm1105dvb->hw_frontend.source = DMX_FRONTEND_0;
+ 	
+ 	ret = dmx->add_frontend(dmx, &dm1105dvb->hw_frontend);
+ 	if (ret < 0)
+ 		goto err_dvb_dmxdev_release;
+ 
+ 	dm1105dvb->mem_frontend.source = DMX_MEMORY_FE;
+ 	
+ 	ret = dmx->add_frontend(dmx, &dm1105dvb->mem_frontend);
+ 	if (ret < 0)
+ 		goto err_remove_hw_frontend;
+ 
+ 	ret = dmx->connect_frontend(dmx, &dm1105dvb->hw_frontend);
+ 	if (ret < 0)
+ 		goto err_remove_mem_frontend;
+ 
+ 	ret = frontend_init(dm1105dvb);
+ 	if (ret < 0)
+ 		goto err_disconnect_frontend;
+ 
+ 	dvb_net_init(dvb_adapter, &dm1105dvb->dvbnet, dmx);
+ 	dm1105_ir_init(dm1105dvb);
+ out:
+ 	return ret;
+ 
+ err_disconnect_frontend:
+ 	dmx->disconnect_frontend(dmx);
+ err_remove_mem_frontend:
+ 	dmx->remove_frontend(dmx, &dm1105dvb->mem_frontend);
+ err_remove_hw_frontend:
+ 	dmx->remove_frontend(dmx, &dm1105dvb->hw_frontend);
+ err_dvb_dmxdev_release:
+ 	dvb_dmxdev_release(&dm1105dvb->dmxdev);
+ err_dvb_dmx_release:
+ 	dvb_dmx_release(dvbdemux);
+ err_dvb_unregister_adapter:
+ 	dvb_unregister_adapter(dvb_adapter);
+ err_i2c_del_adapter:
+ 	i2c_del_adapter(&dm1105dvb->i2c_adap);
+ err_dm1105dvb_hw_exit:
+ 	dm1105dvb_hw_exit(dm1105dvb);
+ err_free_irq:
+ 	free_irq(pdev->irq, dm1105dvb);
+ err_pci_iounmap:
+ 	pci_iounmap(pdev, dm1105dvb->io_mem);
+ err_pci_release_regions:
+ 	pci_release_regions(pdev);
+ err_pci_disable_device:
+ 	pci_disable_device(pdev);
+ err_kfree:
+ 	pci_set_drvdata(pdev, NULL);
+ 	kfree(dm1105dvb);
+ 	goto out;
+ }
+ 
+ static void __devexit dm1105_remove(struct pci_dev *pdev)
+ {
+ 	struct dm1105dvb *dm1105dvb = pci_get_drvdata(pdev);
+ 	struct dvb_adapter *dvb_adapter = &dm1105dvb->dvb_adapter;
+ 	struct dvb_demux *dvbdemux = &dm1105dvb->demux;
+ 	struct dmx_demux *dmx = &dvbdemux->dmx;
+ 	
+ 	dm1105_ir_exit(dm1105dvb);
+ 	dmx->close(dmx);
+ 	dvb_net_release(&dm1105dvb->dvbnet);
+ 	if (dm1105dvb->fe)
+ 		dvb_unregister_frontend(dm1105dvb->fe);
+ 
+ 	dmx->disconnect_frontend(dmx);
+ 	dmx->remove_frontend(dmx, &dm1105dvb->mem_frontend);
+ 	dmx->remove_frontend(dmx, &dm1105dvb->hw_frontend);
+ 	dvb_dmxdev_release(&dm1105dvb->dmxdev);
+ 	dvb_dmx_release(dvbdemux);
+ 	dvb_unregister_adapter(dvb_adapter);
+ 	if (&dm1105dvb->i2c_adap) 
+ 		i2c_del_adapter(&dm1105dvb->i2c_adap);
+ 	
+ 	dm1105dvb_hw_exit(dm1105dvb);
+ 	synchronize_irq (pdev->irq);
+ 	free_irq(pdev->irq, dm1105dvb);
+ 	pci_iounmap(pdev, dm1105dvb->io_mem);
+ 	pci_release_regions(pdev);
+ 	pci_disable_device(pdev);
+ 	pci_set_drvdata(pdev, NULL);
+ 	kfree(dm1105dvb);
+ }
+ 
+ static struct pci_device_id dm1105_id_table[] __devinitdata = {
+ 	{
+ 		.vendor = PCI_VENDOR_ID_TRIGEM,
+ 		.device = PCI_DEVICE_ID_DM1105,
+ 		.subvendor = PCI_ANY_ID,
+ 		.subdevice = PCI_DEVICE_ID_DW2002,
+ 	},{	.vendor = PCI_VENDOR_ID_AXESS, 
+                 .device = PCI_DEVICE_ID_DM1105S, 
+                 .subvendor = PCI_ANY_ID, 
+                 .subdevice = PCI_DEVICE_ID_DM05, 
+         },{
+ 		/* empty */
+ 	},
+ };
+ 
+ MODULE_DEVICE_TABLE(pci, dm1105_id_table);
+ 
+ static struct pci_driver dm1105_driver = {
+ 	.name = DRIVER_NAME,
+ 	.id_table = dm1105_id_table,
+ 	.probe = dm1105_probe,
+ 	.remove = __devexit_p(dm1105_remove),
+ };
+ 
+ static int __init dm1105_init(void)
+ {
+ 	return pci_register_driver(&dm1105_driver);
+ }
+ 
+ static void __exit dm1105_exit(void)
+ {
+ 	pci_unregister_driver(&dm1105_driver);
+ }
+ 
+ module_init(dm1105_init);
+ module_exit(dm1105_exit);
+ 
+ MODULE_AUTHOR("Igor M. Liplianin <liplianin@me.by>");
+ MODULE_DESCRIPTION("DM1105 driver");
+ MODULE_LICENSE("GPL");
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/Kconfig linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/Kconfig
*** linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/Kconfig	2008-01-10 22:13:17.000000000 +0200
--- linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/Kconfig	2007-12-21 00:11:48.000000000 +0200
***************
*** 237,239 ****
--- 237,246 ----
  	  Say Y here to support the default remote control decoding for the
  	  Afatech AF9005 based receiver.
  
+ config DVB_USB_DW2102
+ 	tristate "DvbWorld 2102 DVB-S USB2.0 receiver"
+ 	depends on DVB_USB
+ 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+ 	select DVB_PLL if !DVB_FE_CUSTOMISE
+ 	help
+ 	  Say Y here to support the DvbWorld 2102 DVB-S USB2.0 receiver.
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/Makefile linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/Makefile
*** linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/Makefile	2008-01-10 22:13:17.000000000 +0200
--- linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/Makefile	2007-12-21 00:11:48.000000000 +0200
***************
*** 61,64 ****
--- 61,67 ----
  dvb-usb-af9005-remote-objs = af9005-remote.o
  obj-$(CONFIG_DVB_USB_AF9005_REMOTE) += dvb-usb-af9005-remote.o
  
+ dvb-usb-dw2102-objs = dw2102.o
+ obj-$(CONFIG_DVB_USB_DW2102) += dvb-usb-dw2102.o
+ 
  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
*** linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-01-10 22:13:17.000000000 +0200
--- linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2007-12-21 00:13:20.000000000 +0200
***************
*** 156,161 ****
--- 156,162 ----
  #define USB_PID_OPERA1_WARM				0x3829
  #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_COLD		0x0514
  #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_WARM		0x0513
+ #define USB_PID_DW2102					0x2102
  
  
  #endif
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dw2102.c linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dw2102.c
*** linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dw2102.c	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dw2102.c	2008-03-19 19:53:35.000000000 +0200
***************
*** 0 ****
--- 1,375 ----
+ /* DVB USB framework compliant Linux driver for the DVBWorld DVB-S 2102 USB2 Card
+ *
+ * Copyright (C) 2007 Igor M. Liplianin (liplianin@me.by)
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License as published by the Free
+ *	Software Foundation, version 2.
+ *
+ * see Documentation/dvb/README.dvb-usb for more information
+ */
+ 
+ #include "dw2102.h"
+ #include "stv0299.h"
+ #include "z0194a.h"
+ 
+ #define DW2102_READ_MSG 0
+ #define DW2102_WRITE_MSG 1
+ 
+ #define REG_1F_SYMBOLRATE_BYTE0 0x1f
+ #define REG_20_SYMBOLRATE_BYTE1 0x20
+ #define REG_21_SYMBOLRATE_BYTE2 0x21
+ 
+ #define DW2102_VOLTAGE_CTRL (0x1800)
+ #define DW2102_RC_QUERY (0x1a00)
+ 
+ struct dw2102_state {
+ u32 last_key_pressed;
+ };
+ struct dw2102_rc_keys {
+ u32 keycode;
+ u32 event;
+ };
+ 
+ static int dw2102_op_rw(struct usb_device *dev, u8 request, u16 value,
+ 		   u8 * data, u16 len, int flags)
+ {
+ int ret;
+ u8 u8buf[len];
+ 
+ unsigned int pipe = (flags == DW2102_READ_MSG) ?
+ 	usb_rcvctrlpipe(dev,0) : usb_sndctrlpipe(dev, 0);
+ u8 request_type = (flags == DW2102_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
+ 
+ if (flags == DW2102_WRITE_MSG)
+ 	memcpy(u8buf, data, len);
+ ret = usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
+ 	value, 0 , u8buf, len, 2000);
+ 
+ if (flags == DW2102_READ_MSG)
+ 	memcpy(data, u8buf, len);
+ return ret;
+ }
+ 
+ /* I2C */
+ 
+ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+ 		   int num)
+ {
+ struct dvb_usb_device *d = i2c_get_adapdata(adap);
+ int i = 0, ret = 0;
+ u8 buf6[] = {0x2c,0x05,0xc0,0,0,0,0};
+ u8 request;
+ u16 value;
+ 
+ if (!d)
+ 	return -ENODEV;
+ if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+ 	return -EAGAIN;
+ 
+ switch (num) {
+ 	case 2:
+ 		request=0xb5;
+ 		value = msg[0].buf[0];
+ 		for (i=0; i<msg[1].len; i++){
+ 			value = value + i;
+ 			ret = dw2102_op_rw(d->udev, 0xb5,
+ 				value, buf6, 2, DW2102_READ_MSG);
+ 			msg[1].buf[i] = buf6[0];
+ 
+ 		}
+ 		break;
+ 	case 1:
+ 		switch (msg[0].addr) {
+ 			case 0x68:
+ 				buf6[0] = 0x2a;
+ 				buf6[1] = msg[0].buf[0];
+ 				buf6[2] = msg[0].buf[1];
+ 				ret = dw2102_op_rw(d->udev, 0xb2,
+ 					0, buf6, 3, DW2102_WRITE_MSG);
+ 				break;
+ 			case 0x60:
+ 				if (msg[0].flags == 0) { 
+ 					buf6[0] = 0x2c;
+ 					buf6[1] = 5;
+ 					buf6[2] = 0xc0;
+ 					buf6[3] = msg[0].buf[0];
+ 					buf6[4] = msg[0].buf[1];
+ 					buf6[5] = msg[0].buf[2];
+ 					buf6[6] = msg[0].buf[3];
+ 					ret = dw2102_op_rw(d->udev, 0xb2,
+ 					0, buf6, 7, DW2102_WRITE_MSG);
+ 				} else {
+ 					ret = dw2102_op_rw(d->udev, 0xb5,
+ 					0, buf6, 1, DW2102_READ_MSG);
+ 					msg[0].buf[0] = buf6[0];
+ 				}
+ 				break;
+ 			case (DW2102_RC_QUERY):
+ 				ret  = dw2102_op_rw(d->udev, 0xb8,
+ 					0, buf6, 2, DW2102_READ_MSG);
+ 				msg[0].buf[0] = buf6[0];
+ 				msg[0].buf[1] = buf6[1];
+ 				break;
+ 			case (DW2102_VOLTAGE_CTRL):
+ 				buf6[0] = 0x30;
+ 				buf6[1] = msg[0].buf[0];
+ 				ret = dw2102_op_rw(d->udev, 0xb2,
+ 					0, buf6, 2, DW2102_WRITE_MSG);
+ 				break;
+ 		}
+ 		
+ 	break;	
+ }
+ 
+ mutex_unlock(&d->i2c_mutex);
+ return num;
+ }
+ 
+ static u32 dw2102_i2c_func(struct i2c_adapter *adapter)
+ {
+ return I2C_FUNC_I2C;
+ }
+ 
+ static struct i2c_algorithm dw2102_i2c_algo = {
+ .master_xfer = dw2102_i2c_transfer,
+ .functionality = dw2102_i2c_func,
+ };
+ 
+ static int dw2102_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+ {
+ static u8 command_13v[1]={0x00};
+ static u8 command_18v[1]={0x01};
+ struct i2c_msg msg[] = {
+ 	{.addr = DW2102_VOLTAGE_CTRL, .flags = 0, .buf = command_13v, .len = 1},
+ };
+ struct dvb_usb_adapter *udev_adap =
+     (struct dvb_usb_adapter *)(fe->dvb->priv);
+ if (voltage == SEC_VOLTAGE_18) {
+ 	msg[0].buf = command_18v;
+ }
+ i2c_transfer(&udev_adap->dev->i2c_adap, msg, 1);
+ return 0;
+ }
+ 
+ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
+ {
+ if ((d->fe =
+      dvb_attach(stv0299_attach, &sharp_z0194a_config,
+ 		&d->dev->i2c_adap)) != NULL) {
+ 	d->fe->ops.set_voltage = dw2102_set_voltage;
+ 	info("Attached stv0299!\n");
+ 	return 0;
+ }
+ return -EIO;
+ }
+ 
+ static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
+ {
+ dvb_attach(
+ 	dvb_pll_attach, adap->fe, 0x60,
+ 	&adap->dev->i2c_adap, DVB_PLL_OPERA1
+ );
+ return 0;
+ }
+ 
+ static struct dvb_usb_rc_key dw2102_rc_keys[] = {
+ { 0xf8, 0x0a, KEY_Q },		/*power*/
+ { 0xf8, 0x0c, KEY_M },		/*mute*/
+ { 0xf8, 0x11, KEY_1 },
+ { 0xf8, 0x12, KEY_2 },
+ { 0xf8, 0x13, KEY_3 },
+ { 0xf8, 0x14, KEY_4 },
+ { 0xf8, 0x15, KEY_5 },
+ { 0xf8, 0x16, KEY_6 },
+ { 0xf8, 0x17, KEY_7 },
+ { 0xf8, 0x18, KEY_8 },
+ { 0xf8, 0x19, KEY_9 },
+ { 0xf8, 0x10, KEY_0 },
+ { 0xf8, 0x1c, KEY_PAGEUP },	/*ch+*/
+ { 0xf8, 0x0f, KEY_PAGEDOWN },	/*ch-*/
+ { 0xf8, 0x1a, KEY_O },		/*vol+*/
+ { 0xf8, 0x0e, KEY_Z },		/*vol-*/
+ { 0xf8, 0x04, KEY_R },		/*rec*/
+ { 0xf8, 0x09, KEY_D },		/*fav*/
+ { 0xf8, 0x08, KEY_BACKSPACE },	/*rewind*/
+ { 0xf8, 0x07, KEY_A },		/*fast*/
+ { 0xf8, 0x0b, KEY_P },		/*pause*/
+ { 0xf8, 0x02, KEY_ESC },	/*cancel*/
+ { 0xf8, 0x03, KEY_G },		/*tab*/
+ { 0xf8, 0x00, KEY_UP },		/*up*/
+ { 0xf8, 0x1f, KEY_ENTER },	/*ok*/
+ { 0xf8, 0x01, KEY_DOWN },	/*down*/
+ { 0xf8, 0x05, KEY_C },		/*cap*/
+ { 0xf8, 0x06, KEY_S },		/*stop*/
+ { 0xf8, 0x40, KEY_F },		/*full*/
+ { 0xf8, 0x1e, KEY_W },		/*tvmode*/
+ { 0xf8, 0x1b, KEY_B },		/*recall*/
+ 
+ };
+ 
+ 
+ 
+ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+ {
+ struct dw2102_state *st = d->priv;
+ u8 key[2];
+ struct i2c_msg msg[] = {
+ 	{.addr = DW2102_RC_QUERY, .flags = I2C_M_RD, .buf = key, .len = 2},
+ };
+ int i = 0;
+ 
+ *state = REMOTE_NO_KEY_PRESSED;
+ if (dw2102_i2c_transfer(&d->i2c_adap, msg, 1)==1) {
+ 	for (i = 0; i < ARRAY_SIZE(dw2102_rc_keys); i++) {
+ 		if (dw2102_rc_keys[i].data == msg[0].buf[0]) {
+ 			*state = REMOTE_KEY_PRESSED;
+ 			*event = dw2102_rc_keys[i].event;
+ 			st->last_key_pressed =
+ 				dw2102_rc_keys[i].event;
+ 			break;
+ 		}
+ 		st->last_key_pressed = 0;
+ 	}
+ }	
+ /* info("key: %x %x\n",key[0],key[1]); */
+ return 0;
+ }
+ 
+ static struct usb_device_id dw2102_table[] = {
+ {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
+ {0}
+ };
+ 
+ MODULE_DEVICE_TABLE(usb, dw2102_table);
+ 
+ static int dw2102_load_firmware(struct usb_device *dev,
+ 			       const struct firmware *fw)
+ {
+ u8 *b, *p;
+ int ret = 0, i;
+ u8 reset;
+ u8 reset16 [] = {0,0};
+ info("start downloading DW2102 firmware");
+ p = kmalloc(fw->size, GFP_KERNEL);
+ reset = 1;
+ /*stop the CPU*/
+ dw2102_op_rw(dev, 0xa0, 0x7f92, &reset, 1, DW2102_WRITE_MSG);
+ dw2102_op_rw(dev, 0xa0, 0xe600, &reset, 1, DW2102_WRITE_MSG);
+ 
+ if (p != NULL) {
+ 	memcpy(p, fw->data, fw->size);
+ 	for (i = 0; i < fw->size; i += 0x40) {
+ 		b = (u8 *) p + i;	
+ 		if (dw2102_op_rw
+ 			(dev, 0xa0, i, b , 0x40,
+ 				DW2102_WRITE_MSG) != 0x40
+ 			) {
+ 			err("error while transferring firmware");
+ 			ret = -EINVAL;
+ 			break;
+ 		}
+ 	}
+ 	/* restart the CPU */
+ 	reset = 0;
+ 	if (ret || dw2102_op_rw
+ 			(dev, 0xa0, 0x7f92, &reset, 1,
+ 			DW2102_WRITE_MSG) != 1) {
+ 		err("could not restart the USB controller CPU.");
+ 		ret = -EINVAL;
+ 	}
+ 		if (ret || dw2102_op_rw
+ 			(dev, 0xa0, 0xe600, &reset, 1,
+ 			DW2102_WRITE_MSG) != 1) {
+ 		err("could not restart the USB controller CPU.");
+ 		ret = -EINVAL;
+ 	}
+ 		dw2102_op_rw
+ 			(dev, 0xbf, 0x0040, &reset, 0,
+ 			DW2102_WRITE_MSG);
+ 		dw2102_op_rw
+ 			(dev, 0xb9, 0x0000, &reset16[0], 2,
+ 			DW2102_READ_MSG);
+ 		
+ 	kfree(p);
+ }
+ return ret;
+ }
+ 													
+ static struct dvb_usb_device_properties dw2102_properties = {
+ .caps = DVB_USB_IS_AN_I2C_ADAPTER,
+ .usb_ctrl = DEVICE_SPECIFIC,
+ .firmware = "dvb-usb-dw2102.fw",
+ .size_of_priv = sizeof(struct dw2102_state),
+ .no_reconnect = 1,
+ 
+ .i2c_algo = &dw2102_i2c_algo,
+ .rc_key_map = dw2102_rc_keys,
+ .rc_key_map_size = ARRAY_SIZE(dw2102_rc_keys),
+ .rc_interval = 150,
+ .rc_query = dw2102_rc_query,
+ 
+ .generic_bulk_ctrl_endpoint = 0x81,
+ /* parameter for the MPEG2-data transfer */
+ .num_adapters = 1,
+ .download_firmware = dw2102_load_firmware,
+ .adapter = {
+ 	{
+ 		.frontend_attach = dw2102_frontend_attach,
+ 		.streaming_ctrl = NULL,
+ 		.tuner_attach = dw2102_tuner_attach,
+ 		.stream = {
+ 			.type = USB_BULK,
+ 			.count = 8,
+ 			.endpoint = 0x82,
+ 			.u = {
+ 				.bulk = {
+ 					.buffersize = 4096,
+ 				}
+ 			}
+ 		},
+ 	}
+ },
+ .num_device_descs = 1,
+ .devices = {
+ 	{"DVBWorld DVB-S 2102 USB2.0",
+ 		{&dw2102_table[0], NULL},
+ 	},
+ 	{NULL},
+ }
+ };
+ 
+ static int dw2102_probe(struct usb_interface *intf,
+ 		const struct usb_device_id *id)
+ {
+ return dvb_usb_device_init(intf, &dw2102_properties, THIS_MODULE, NULL);
+ }
+ 
+ static struct usb_driver dw2102_driver = {
+ .name = "dw2102",
+ .probe = dw2102_probe,
+ .disconnect = dvb_usb_device_exit,
+ .id_table = dw2102_table,
+ };
+ 
+ static int __init dw2102_module_init(void)
+ {
+ int result = 0;
+ if ((result = usb_register(&dw2102_driver))) {
+ 	err("usb_register failed. Error number %d", result);
+ }
+ return result;
+ }
+ 
+ static void __exit dw2102_module_exit(void)
+ {
+ usb_deregister(&dw2102_driver);
+ }
+ 
+ module_init(dw2102_module_init);
+ module_exit(dw2102_module_exit);
+ 
+ MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
+ MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2102 USB2.0 device");
+ MODULE_VERSION("0.1");
+ MODULE_LICENSE("GPL");
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dw2102.h linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dw2102.h
*** linux-2.6.23.12.orig/drivers/media/dvb/dvb-usb/dw2102.h	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/dvb-usb/dw2102.h	2008-03-19 19:35:50.000000000 +0200
***************
*** 0 ****
--- 1,7 ----
+ #ifndef _DW2102_H_
+ #define _DW2102_H_
+ 
+ #define DVB_USB_LOG_PREFIX "dw2102"
+ #include "dvb-usb.h"
+ 
+ #endif
diff -crN linux-2.6.23.12.orig/drivers/media/dvb/frontends/z0194a.h linux-2.6.23.12.new/drivers/media/dvb/frontends/z0194a.h
*** linux-2.6.23.12.orig/drivers/media/dvb/frontends/z0194a.h	1970-01-01 03:00:00.000000000 +0300
--- linux-2.6.23.12.new/drivers/media/dvb/frontends/z0194a.h	2008-03-19 23:03:39.000000000 +0200
***************
*** 0 ****
--- 1,93 ----
+ /* z0194a.h Sharp z0194a tuner support
+ *
+ * Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License as published by the Free
+ *	Software Foundation, version 2.
+ *
+ * see Documentation/dvb/README.dvb-usb for more information
+ */
+ 
+ #ifndef Z0194A
+ #define Z0194A
+ 
+ static int sharp_z0194a__set_symbol_rate(struct dvb_frontend* fe, u32 srate, u32 ratio)
+ {
+         u8 aclk = 0;
+         u8 bclk = 0;
+ 
+         if (srate < 1500000) { aclk = 0xb7; bclk = 0x47; }
+         else if (srate < 3000000) { aclk = 0xb7; bclk = 0x4b; }
+         else if (srate < 7000000) { aclk = 0xb7; bclk = 0x4f; }
+         else if (srate < 14000000) { aclk = 0xb7; bclk = 0x53; }
+         else if (srate < 30000000) { aclk = 0xb6; bclk = 0x53; }
+         else if (srate < 45000000) { aclk = 0xb4; bclk = 0x51; }
+ 
+         stv0299_writereg (fe, 0x13, aclk);
+         stv0299_writereg (fe, 0x14, bclk);
+         stv0299_writereg (fe, 0x1f, (ratio >> 16) & 0xff);
+         stv0299_writereg (fe, 0x20, (ratio >>  8) & 0xff);
+         stv0299_writereg (fe, 0x21, (ratio      ) & 0xf0);
+ 
+         return 0;
+ }
+ 
+ static u8 sharp_z0194a__inittab[] = {
+              0x01, 0x15,
+              0x02, 0x30,
+              0x03, 0x00,
+              0x04, 0x7D,
+              0x05, 0x35,
+              0x06, 0x02,
+              0x07, 0x00,
+              0x08, 0xC3,
+              0x0C, 0x00,
+              0x0D, 0x81,
+              0x0E, 0x23,
+              0x0F, 0x12,
+              0x10, 0x7E,
+              0x11, 0x84,
+              0x12, 0xB9,
+              0x13, 0x88,
+              0x14, 0x89,
+              0x15, 0xC9,
+              0x16, 0x00,
+              0x17, 0x5C,
+              0x18, 0x00,
+              0x19, 0x00,
+              0x1A, 0x00,
+              0x1C, 0x00,
+              0x1D, 0x00,
+              0x1E, 0x00,
+              0x1F, 0x3A,
+              0x20, 0x2E,
+              0x21, 0x80,
+              0x22, 0xFF,
+              0x23, 0xC1,
+              0x28, 0x00,
+              0x29, 0x1E,
+              0x2A, 0x14,
+              0x2B, 0x0F,
+              0x2C, 0x09,
+              0x2D, 0x05,
+              0x31, 0x1F,
+              0x32, 0x19,
+              0x33, 0xFE,
+              0x34, 0x93,
+              0xff, 0xff,
+ };
+ 
+ static struct stv0299_config sharp_z0194a_config = {
+         .demod_address = 0x68,
+         .inittab = sharp_z0194a__inittab,
+         .mclk = 88000000UL,
+         .invert = 0,
+         .skip_reinit = 0,
+         .lock_output = STV0229_LOCKOUTPUT_LK,
+         .volt13_op0_op1 = STV0299_VOLT13_OP1,
+         .min_delay_ms = 100,
+         .set_symbol_rate = sharp_z0194a__set_symbol_rate,
+ };
+ 
+ #endif

--Boundary-00=_3jV5HnnelMyi60d
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_3jV5HnnelMyi60d--
