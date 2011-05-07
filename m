Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:44471 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1EGPp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2011 11:45:29 -0400
Message-ID: <4DC5622A.9040403@usa.net>
Date: Sat, 07 May 2011 17:15:54 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>, Ralph Metzler <rjkm@metzlerbros.de>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>
In-Reply-To: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>
Content-Type: multipart/mixed;
 boundary="------------080708060503090406070008"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------080708060503090406070008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 03/05/11 12:59, Sébastien RAILLARD (COEXSI) wrote:
> Dear all,
>
> I'm doing some tests with the CI interface of the "Linux4Media cineS2 DVB-S2
> Twin Tuner (v5)" card.
> I notice some TS discontinuities during my tests.
>
> My setup:
> - Aston Viaccess Pro CAM
> - Linux4Media cineS2 DVB-S2 Twin Tuner (v5) card
> - Latest git media_build source with DF_SWAP32 patch
> - DVB-S source from ASTRA 19.2E / 12285.00-V-27500
>
> Test #1: (idle)
> Reading from sec0 (without CI init or sec0 input stream) using "dd" give me
> a stream of NULL TS packets of roughly 62mbps or 7.8MB/s (seems normal
> behavior)
> Command line: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts bs=18800
> count=10000
>
> Test #2: (CAM removal)
> After CAM initialization and some tests, if CAM is removed, the output sec0
> bandwidth isn't anymore 62mbps of NULL TS packets
> Same command line as Test #1 is used.
> It seems that the CI is badly reacting after hot remove of CAM.
> After rebooting, everything is fine again.
>
> Test #3: (Test dvr0 stream)
> - Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
> -out dvr CHAINE
> - Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
> - Dumping the dvr0 output: dd if=/dev/dvb/adapter14/dvr0 of=/root/test.ts
> bs=1880 count=1000
> => The dvr0 output bandwidth is roughly 300kB/s (normal for one filtered
> channel)
> => The resulting TS file is correct (no sync missing, no continuity error)
>
> Test #4: (Loop mode - No CAM inserted)
> - Sending all TS packets from dvr0 to sec0: dd if=/dev/dvb/adapter14/dvr0
> of=/dev/dvb/adapter14/sec0 bs=1880
> - Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
> -out dvr CHAINE
> - Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
> - Dumping the sec0 output: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts
> bs=18800 count=10000
> => The sec0 output bandwidth is roughly 7.8MB/s (normal as the CI output is
> always 62mbps)
> => The resulting TS file is filled at 96% by NULL TS packets (normal,
> regarding the input stream bandwidth of 300kB/S)
> => All the input PID seem to present in the output file
> => But, there are some discontinuities in the TS packets (a lot and for all
> the PID)
>
> Test #5: (Trough CAM - CAM is inserted)
> - Sending all TS packets from dvr0 to sec0: dd if=/dev/dvb/adapter14/dvr0
> of=/dev/dvb/adapter14/sec0 bs=1880
> - Setting up the DVB-S reception: gnutv -adapter 14 -channels channels.conf
> -out dvr CHAINE
> - Channel configuration: CHAINE:12285:v:0:27500:170:120:17030
> - Waiting for CAM initialization (the CAM is correctly initialized and the
> PMT packet is send to the CAM)
> - Dumping the sec0 output: dd if=/dev/dvb/adapter14/sec0 of=/root/test.ts
> bs=18800 count=10000
> => The sec0 output bandwidth is roughly 7.8MB/s (normal as the CI output is
> always 62mbps)
> => The resulting TS file is filled at 96% by NULL TS packets (normal,
> regarding the input stream bandwidth of 300kB/S)
> => All the input PID seem to present in the output file
> => The stream isn't decoded (normal as the CAT table isn't outputted by
> gnutv)
> => But, there are some discontinuities in the TS packets (a lot and for all
> the PID)
>
> So, in summary, I'm observing discontinues when stream is going through the
> sec0 device, if CAM is present or not.
> Also, the CI adapter doesn't seem to react correctly when the CAM is hot
> removed.
> I can provide the TS files (from dvr0, from sec0 with CAM and without CAM)
> if someone is interested.
>
> Does someone has a setup that show no discontinuities when a TS stream is
> going through sec0? (with an input TS file)
> I would like to test it as for me the CI interface doesn't seem to work for
> the nGene cards.
>
> Best regards,
> Sebastien.
Ralph,

Could you please take a look at the cxd2099 issues ?

I have attached a version with my changes. I have tested a lot of
different settings with the help of the chip datasheet.

Scrambled programs are not handled correctly. I don't know if it is the
TICLK/MCLKI which is too high or something, or the sync detector ? Also,
as we have to set the TOCLK to max of 72MHz, there are way too much null
packets added. Is there a way to solve this ?

Thx
--
Issa

--------------080708060503090406070008
Content-Type: text/x-csrc;
 name="cxd2099.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cxd2099.c"

/*
 * cxd2099.c: Driver for the CXD2099AR Common Interface Controller
 *
 * Copyright (C) 2010 DigitalDevices UG
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 only, as published by the Free Software Foundation.
 *
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
 */

#include <linux/version.h>
#include <linux/slab.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/i2c.h>
#include <linux/wait.h>
#include <linux/delay.h>
#include <linux/mutex.h>
#include <linux/io.h>

#include "cxd2099.h"

static int debug;
module_param(debug, int, 0444);
MODULE_PARM_DESC(debug, "Print debugging information.");

#define dprintk if (debug) printk

struct cxd {
	struct dvb_ca_en50221 en;

	struct i2c_adapter *i2c;
	u8     adr;
//	u8     regs[0x23];
//	u8     lastaddress;
//	u8     clk_reg_f;
//	u8     clk_reg_b;
	int    mode;
//	u32    bitrate;
//	int    ready;
//	int    dr;
	int    slot_stat;

//	u8     amem[1024];
//	int    amem_read;

//	int    cammode;
	struct mutex lock;
};

static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
			 u8 reg, u8 data)
{
	u8 m[2] = {reg, data};
	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m, .len = 2};

	if (i2c_transfer(adapter, &msg, 1) != 1) {
		printk(KERN_ERR "cxd2099: Failed to write to I2C register %02x@%02x!\n",
		       reg, adr);
		return -1;
	}
	return 0;
}

static int i2c_write(struct i2c_adapter *adapter, u8 adr,
		     u8 *data, u8 len)
{
	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};

	if (i2c_transfer(adapter, &msg, 1) != 1) {
		printk(KERN_ERR "cxd2099: Failed to write to I2C!\n");
		return -1;
	}
	return 0;
}

static int i2c_read(struct i2c_adapter *adapter, u8 adr,
		    u8 reg, u8 *data, u8 n)
{
	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
				   .buf = &reg, .len = 1 },
				  {.addr = adr, .flags = I2C_M_RD,
				   .buf = data, .len = n } };

	if (i2c_transfer(adapter, msgs, 2) != 2) {
		printk(KERN_ERR "cxd2099: error in i2c_read\n");
		return -1;
	}
	return 0;
}

static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
			u8 reg, u8 *val)
{
	return i2c_read(adapter, adr, reg, val, 1);
}

static int read_block(struct cxd *ci, u8 reg, u8 *data, u8 n)
{
	int status;

	status = i2c_write_reg(ci->i2c, ci->adr, 0, reg);
	if (!status) {
//		ci->lastaddress = adr;
		status = i2c_read(ci->i2c, ci->adr, 1, data, n);
	}
	return status;
}

static int read_reg(struct cxd *ci, u8 reg, u8 *val)
{
	return read_block(ci, reg, val, 1);
}


static int read_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
{
	int status;
	u8 addr[3] = { 2, address&0xff, address>>8 };

	status = i2c_write(ci->i2c, ci->adr, addr, 3);
	if (!status)
		status = i2c_read(ci->i2c, ci->adr, 3, data, n);
	return status;
}

static int write_pccard(struct cxd *ci, u16 address, u8 *data, u8 n)
{
	int status;
	u8 addr[3] = { 2, address&0xff, address>>8 };

	status = i2c_write(ci->i2c, ci->adr, addr, 3);
	if (!status) {
		u8 buf[256] = {3};
		memcpy(buf+1, data, n);
		status = i2c_write(ci->i2c, ci->adr, buf, n+1);
	}
	return status;
}

static int read_io(struct cxd *ci, u16 address, u8 *val)
{
	int status;
	u8 addr[3] = { 2, address&0xff, address>>8 };

	status = i2c_write(ci->i2c, ci->adr, addr, 3);
	if (!status)
		status = i2c_read(ci->i2c, ci->adr, 3, val, 1);
	return status;
}

static int write_io(struct cxd *ci, u16 address, u8 val)
{
	int status;
	u8 addr[3] = { 2, address&0xff, address>>8 };
	u8 buf[2] = { 3, val };

	status = i2c_write(ci->i2c, ci->adr, addr, 3);
	if (!status)
		status = i2c_write(ci->i2c, ci->adr, buf, 2);

	return status;
}


static int write_regm(struct cxd *ci, u8 reg, u8 val, u8 mask)
{
	int status;
	u8 b;

	status = i2c_write_reg(ci->i2c, ci->adr, 0, reg);
	if (!status) {
		status = i2c_read_reg(ci->i2c, ci->adr, 1, &b);
		if (!status) {
			b = (b & (~mask)) | val;
			status = i2c_write_reg(ci->i2c, ci->adr, 1, b);
		}
	}
	return status;
}

static int write_reg(struct cxd *ci, u8 reg, u8 val)
{
	int status;

	status = i2c_write_reg(ci->i2c, ci->adr, 0, reg);
	if (!status)
		status = i2c_write_reg(ci->i2c, ci->adr, 1, val);
		
	return status;
}

/*
#ifdef BUFFER_MODE
static int write_block(struct cxd *ci, u8 adr, u8 *data, int n)
{
	int status;
	u8 buf[256] = {1};

	status = i2c_write_reg(ci->i2c, ci->adr, 0, adr);
	if (!status) {
		ci->lastaddress = adr;
		memcpy(buf+1, data, n);
		status = i2c_write(ci->i2c, ci->adr, buf, n+1);
	}
	return status;
}
#endif
*/


static void set_mode(struct cxd *ci, int mode)
{
	if (mode == ci->mode)
		return;

	switch (mode) {
	case 0x00: /* IO mem */
		write_regm(ci, 0x06, 0x00, 0x07);
		break;
	case 0x01: /* ATT mem */
		write_regm(ci, 0x06, 0x02, 0x07);
		break;
	default:
		break;
	}
	ci->mode = mode;
}

/*
static void cam_mode(struct cxd *ci, int mode)
{
	if (mode == ci->cammode)
		return;

	switch (mode) {
	case 0x00:
		write_regm(ci, 0x20, 0x80, 0x80);
		break;
	case 0x01:
		printk(KERN_INFO "enable cam buffer mode\n");
		// write_reg(ci, 0x0d, 0x00);
		// write_reg(ci, 0x0e, 0x01);
		write_regm(ci, 0x08, 0x40, 0x40);
		// read_reg(ci, 0x12, &dummy);
		write_regm(ci, 0x08, 0x80, 0x80);
		break;
	default:
		break;
	}
	ci->cammode = mode;
}
*/


#define CHK_ERROR(s) if ((status = s)) break

static int init(struct cxd *ci)
{
	int status;

	dprintk("cxd2099: %s\n", __func__);

	mutex_lock(&ci->lock);
	ci->mode = -1;
	do {
		CHK_ERROR(write_reg(ci, 0x00, 0x00));
//		CHK_ERROR(write_reg(ci, 0x01, 0x00));
//		CHK_ERROR(write_reg(ci, 0x02, 0x10));
//		CHK_ERROR(write_reg(ci, 0x03, 0x00));
//		CHK_ERROR(write_reg(ci, 0x05, 0xFF));
//		CHK_ERROR(write_reg(ci, 0x06, 0x1F));
//		CHK_ERROR(write_reg(ci, 0x07, 0x1F));
//		CHK_ERROR(write_reg(ci, 0x08, 0x28));
//		CHK_ERROR(write_reg(ci, 0x14, 0x20));

//		CHK_ERROR(write_reg(ci, 0x09, 0x4D)); /* Input Mode C, BYPass Serial, TIVAL = low, MSB */
//		CHK_ERROR(write_reg(ci, 0x0A, 0xA7)); /* TOSTRT = 8, Mode B (gated clock), falling Edge, Serial, POL=HIGH, MSB */

		/* Sync detector */
//		CHK_ERROR(write_reg(ci, 0x0B, 0x33));
//		CHK_ERROR(write_reg(ci, 0x0C, 0x33));

//		CHK_ERROR(write_regm(ci, 0x14, 0x00, 0x0F));
//		CHK_ERROR(write_reg(ci, 0x15, ci->clk_reg_b));
//		CHK_ERROR(write_regm(ci, 0x16, 0x00, 0x0F));
//		CHK_ERROR(write_reg(ci, 0x17, ci->clk_reg_f));

//		CHK_ERROR(write_reg(ci, 0x20, 0x28)); /* Integer Divider, Falling Edge, Internal Sync, */
//		CHK_ERROR(write_reg(ci, 0x21, 0x00)); /* MCLKI = TICLK/8 */
//		CHK_ERROR(write_reg(ci, 0x22, 0x07)); /* MCLKI = TICLK/8 */


//		CHK_ERROR(write_regm(ci, 0x20, 0x80, 0x80)); /* Reset CAM state machine */

//		CHK_ERROR(write_regm(ci, 0x03, 0x02, 02));  /* Enable IREQA Interrupt */
//		CHK_ERROR(write_reg(ci, 0x01, 0x04));  /* Enable CD Interrupt */
//		CHK_ERROR(write_reg(ci, 0x00, 0x31));  /* Enable TS1,Hot Swap,Slot A */
//		CHK_ERROR(write_regm(ci, 0x09, 0x08, 0x08));  /* Put TS in bypass */

		// Shutdown everything		
		CHK_ERROR(write_reg(ci, 0x00, 0x00));
		// Enable CDA interrupt
		CHK_ERROR(write_reg(ci, 0x01, 0x04));
		// DA from CAM has priority
		CHK_ERROR(write_reg(ci, 0x02, 0x10));
		// Enable IREQA interrupt, PCMCIA timout
		CHK_ERROR(write_reg(ci, 0x03, 0x42));
		// Clears interuption bits
		CHK_ERROR(write_reg(ci, 0x05, 0xFF));
		// Reset PCMCIA slot A
		CHK_ERROR(write_reg(ci, 0x06, 0x1F));
		// Disable vcc selection for slot b
		CHK_ERROR(write_reg(ci, 0x08, 0x2C));
		// TS input serial mode C, TIVAL active LOW, MSB first, Polarity High
		CHK_ERROR(write_reg(ci, 0x09, 0x45));
		// TS output serial mode B, falling edge, MSB first, TOSTART=8
		CHK_ERROR(write_reg(ci, 0x0A, 0x47));
		// Sync detector
		CHK_ERROR(write_reg(ci, 0x0B, 0x11));
		CHK_ERROR(write_reg(ci, 0x0C, 0x11));
		// TS output clock set to 72MHz
		CHK_ERROR(write_reg(ci, 0x14, 0x20));
		CHK_ERROR(write_reg(ci, 0x15, 0x08));
		CHK_ERROR(write_reg(ci, 0x16, 0x00));
		CHK_ERROR(write_reg(ci, 0x17, 0x03));
		// HC clear delay
		CHK_ERROR(write_reg(ci, 0x18, 0x00));
		CHK_ERROR(write_reg(ci, 0x19, 0x00));
		// Internal sync detector
		CHK_ERROR(write_reg(ci, 0x20, 0x80));
		CHK_ERROR(write_reg(ci, 0x21, 0x00));
		CHK_ERROR(write_reg(ci, 0x22, 0x00));
		// TS Hot swap, Global interface enable card A
		CHK_ERROR(write_reg(ci, 0x00, 0x31));
		
		
/*		ci->cammode = -1;
#ifdef BUFFER_MODE
		cam_mode(ci, 0);
#endif
*/
	} while (0);
	mutex_unlock(&ci->lock);

	return 0;
}


static int read_attribute_mem(struct dvb_ca_en50221 *ca,
			      int slot, int address)
{
	struct cxd *ci = ca->data;
	u8 val;

	mutex_lock(&ci->lock);
	set_mode(ci, 1);
	read_pccard(ci, address, &val, 1);
	mutex_unlock(&ci->lock);
	return val;
}


static int write_attribute_mem(struct dvb_ca_en50221 *ca, int slot,
			       int address, u8 value)
{
	struct cxd *ci = ca->data;

	mutex_lock(&ci->lock);
	set_mode(ci, 1);
	write_pccard(ci, address, &value, 1);
	mutex_unlock(&ci->lock);
	return 0;
}

static int read_cam_control(struct dvb_ca_en50221 *ca,
			    int slot, u8 address)
{
	struct cxd *ci = ca->data;
	u8 val;

	mutex_lock(&ci->lock);
	set_mode(ci, 0);
	read_io(ci, address, &val);
	mutex_unlock(&ci->lock);
	return val;
}

static int write_cam_control(struct dvb_ca_en50221 *ca, int slot,
			     u8 address, u8 value)
{
	struct cxd *ci = ca->data;

	mutex_lock(&ci->lock);
	set_mode(ci, 0);
	write_io(ci, address, value);
	mutex_unlock(&ci->lock);
	return 0;
}

static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
{
	struct cxd *ci = ca->data;

	dprintk("cxd2099: %s\n", __func__);

	mutex_lock(&ci->lock);
//	cam_mode(ci, 0);
//	write_reg(ci, 0x00, 0x21);
//	write_reg(ci, 0x06, 0x1F);
	write_reg(ci, 0x00, 0x31);
	write_regm(ci, 0x20, 0x80, 0x80);
//	write_reg(ci, 0x03, 0x02);
//	ci->ready = 0;
	ci->mode = -1;
	msleep(1000);
	mutex_unlock(&ci->lock);
	return 0;
}

static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
{
	struct cxd *ci = ca->data;

	printk(KERN_INFO "cxd2099: slot_shutdown\n");
	mutex_lock(&ci->lock);
	/* write_regm(ci, 0x09, 0x08, 0x08); */
	write_regm(ci, 0x20, 0x80, 0x80);
	write_reg(ci, 0x00, 0x00);
	ci->mode = -1;
	mutex_unlock(&ci->lock);
	return 0; /* shutdown(ci); */
}

static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
{
	struct cxd *ci = ca->data;

	dprintk("cxd2099: %s\n", __func__);

	mutex_lock(&ci->lock);
	// bypass CAM off
//	write_regm(ci, 0x09, 0x00, 0x08);
	
	
//	set_mode(ci, 0);
/*
#ifdef BUFFER_MODE
	cam_mode(ci, 1);
#endif
*/
	mutex_unlock(&ci->lock);
	return 0;
}


static int campoll(struct cxd *ci)
{
	u8 istat;

	read_reg(ci, 0x04, &istat);
	if (!istat)
		return 0;
	write_reg(ci, 0x05, istat);

	if (istat&0x40) {
//		ci->dr = 1;
		dprintk(KERN_INFO "cxd2099: read buffer INT\n");
	}
	if (istat&0x20)
		dprintk(KERN_INFO "cxd2099: write buffer INT\n");
	if (istat&0x80)
		dprintk(KERN_INFO "cxd2099: PCMCIA timeout\n");

	if (istat&2) {
		u8 slotstat;

		read_reg(ci, 0x01, &slotstat);
		if (!(2&slotstat)) {
			if (!ci->slot_stat) {
				ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
//				write_regm(ci, 0x03, 0x08, 0x08);
				dprintk(KERN_INFO "cxd2099: DVB_CA_EN50221_POLL_CAM_PRESENT\n");
			}

		} else {
			if (ci->slot_stat) {
				ci->slot_stat = 0;
//				write_regm(ci, 0x03, 0x00, 0x08);
				dprintk(KERN_INFO "cxd2099: NO CAM\n");
//				ci->ready = 0;
			}
		}
		if (istat&8 && ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT) {
//			ci->ready = 1;
			ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_READY;
			dprintk(KERN_INFO "cxd2099: READY\n");
		}
	}
	return 0;
}


static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
{
	struct cxd *ci = ca->data;
//	u8 slotstat;

	mutex_lock(&ci->lock);
	campoll(ci);
//	read_reg(ci, 0x01, &slotstat);
	mutex_unlock(&ci->lock);

	return ci->slot_stat;
}

/*
#ifdef BUFFER_MODE
static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
{
	struct cxd *ci = ca->data;
	u8 msb, lsb;
	u16 len;

	mutex_lock(&ci->lock);
	campoll(ci);
	mutex_unlock(&ci->lock);

	dprintk(KERN_INFO "read_data\n");
	if (!ci->dr)
		return 0;

	mutex_lock(&ci->lock);
	read_reg(ci, 0x0f, &msb);
	read_reg(ci, 0x10, &lsb);
	len = (msb<<8)|lsb;
	read_block(ci, 0x12, ebuf, len);
	ci->dr = 0;
	mutex_unlock(&ci->lock);

	return len;
}

static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
{
	struct cxd *ci = ca->data;

	mutex_lock(&ci->lock);
	dprintk(KERN_INFO "write_data %d\n", ecount);
	write_reg(ci, 0x0d, ecount>>8);
	write_reg(ci, 0x0e, ecount&0xff);
	write_block(ci, 0x11, ebuf, ecount);
	mutex_unlock(&ci->lock);
	return ecount;
}
#endif
*/

static struct dvb_ca_en50221 en_templ = {
	.read_attribute_mem  = read_attribute_mem,
	.write_attribute_mem = write_attribute_mem,
	.read_cam_control    = read_cam_control,
	.write_cam_control   = write_cam_control,
	.slot_reset          = slot_reset,
	.slot_shutdown       = slot_shutdown,
	.slot_ts_enable      = slot_ts_enable,
	.poll_slot_status    = poll_slot_status,
/*
#ifdef BUFFER_MODE
	.read_data           = read_data,
	.write_data          = write_data,
#endif
*/
};

struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv,
				      struct i2c_adapter *i2c)
{
	struct cxd *ci = 0;
//	u32 bitrate = 62000000;
	u8 val;

	if (i2c_read_reg(i2c, adr, 0, &val) < 0) {
		printk(KERN_ERR "No CXD2099AR detected at %02x\n", adr);
		return 0;
	}

	ci = kmalloc(sizeof(struct cxd), GFP_KERNEL);
	if (!ci)
		return 0;
	memset(ci, 0, sizeof(*ci));

	mutex_init(&ci->lock);
	ci->i2c = i2c;
	ci->adr = adr;
//	ci->lastaddress = 0xff;
//	ci->clk_reg_b = 0x4a;
//	ci->clk_reg_f = 0x1b;
//	ci->bitrate = bitrate;

	memcpy(&ci->en, &en_templ, sizeof(en_templ));
	ci->en.data = ci;
	init(ci);
	printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->adr);
	return &ci->en;
}
EXPORT_SYMBOL(cxd2099_attach);

MODULE_DESCRIPTION("cxd2099");
MODULE_AUTHOR("Ralph Metzler <rjkm@metzlerbros.de>");
MODULE_LICENSE("GPL");

--------------080708060503090406070008--
