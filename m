Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:35378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1APPwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 10:52:49 -0500
Message-ID: <4D333066.3020203@infradead.org>
Date: Sun, 16 Jan 2011 15:52:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9 v2] Altera FPGA based CI driver module.
References: <4d20723d.cc7e0e0a.6f59.3762@mx.google.com>
In-Reply-To: <4d20723d.cc7e0e0a.6f59.3762@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-01-2011 10:01, Igor M. Liplianin escreveu:
> An Altera FPGA CI module for NetUP Dual DVB-T/C RF CI card.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>

Igor,

There's something wrong with this patch. I got lots of error after applying it:

drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_read_attribute_mem':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:304: multiple definition of `netup_ci_read_attribute_mem'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:241: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_op_cam':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:269: multiple definition of `netup_ci_op_cam'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:171: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_slot_shutdown':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:364: multiple definition of `netup_ci_slot_shutdown'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:293: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_slot_ts_ctl':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:370: multiple definition of `netup_ci_slot_ts_ctl'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:320: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_write_cam_ctl':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:322: multiple definition of `netup_ci_write_cam_ctl'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:259: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_read_cam_ctl':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:315: multiple definition of `netup_ci_read_cam_ctl'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:252: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_write_attribute_mem':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:310: multiple definition of `netup_ci_write_attribute_mem'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:247: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_poll_ci_slot_status':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:448: multiple definition of `netup_poll_ci_slot_status'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:403: first defined here
drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_slot_reset':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:327: multiple definition of `netup_ci_slot_reset'
drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cimax2.c:264: first defined here


Please fix it and submit a new version. The better is to replace all those new symbols to start
with altera_ci.

While here, please, on the first patch, move the Altera FPGA driver to staging, to give people
some time do discuss about it.

PS.: there are a few CodingStyle errors on this patch. Please always review your patches with
./scripts/checkpatch.pl.

Thanks!
Mauro

> ---
>  drivers/media/video/cx23885/Kconfig     |    9 +
>  drivers/media/video/cx23885/Makefile    |    1 +
>  drivers/media/video/cx23885/altera-ci.c |  837 +++++++++++++++++++++++++++++++
>  drivers/media/video/cx23885/altera-ci.h |  102 ++++
>  4 files changed, 949 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/cx23885/altera-ci.c
>  create mode 100644 drivers/media/video/cx23885/altera-ci.h
> 
> diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
> index 6b4a516..5e5faad 100644
> --- a/drivers/media/video/cx23885/Kconfig
> +++ b/drivers/media/video/cx23885/Kconfig
> @@ -33,3 +33,12 @@ config VIDEO_CX23885
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called cx23885
>  
> +config MEDIA_ALTERA_CI
> +	tristate "Altera FPGA based CI module"
> +	depends on VIDEO_CX23885 && DVB_CORE
> +	select STAPL_ALTERA
> +	---help---
> +	  An Altera FPGA CI module for NetUP Dual DVB-T/C RF CI card.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called altera-ci
> diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
> index e2ee95f..23293c7 100644
> --- a/drivers/media/video/cx23885/Makefile
> +++ b/drivers/media/video/cx23885/Makefile
> @@ -5,6 +5,7 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
>  		    cx23885-f300.o
>  
>  obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
> +obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
>  
>  EXTRA_CFLAGS += -Idrivers/media/video
>  EXTRA_CFLAGS += -Idrivers/media/common/tuners
> diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/video/cx23885/altera-ci.c
> new file mode 100644
> index 0000000..019797b
> --- /dev/null
> +++ b/drivers/media/video/cx23885/altera-ci.c
> @@ -0,0 +1,837 @@
> +/*
> + * altera-ci.c
> + *
> + *  CI driver in conjunction with NetUp Dual DVB-T/C RF CI card
> + *
> + * Copyright (C) 2010 NetUP Inc.
> + * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/*
> + * currently cx23885 GPIO's used.
> + * GPIO-0 ~INT in
> + * GPIO-1 TMS out
> + * GPIO-2 ~reset chips out
> + * GPIO-3 to GPIO-10 data/addr for CA in/out
> + * GPIO-11 ~CS out
> + * GPIO-12 AD_RG out
> + * GPIO-13 ~WR out
> + * GPIO-14 ~RD out
> + * GPIO-15 ~RDY in
> + * GPIO-16 TCK out
> + * GPIO-17 TDO in
> + * GPIO-18 TDI out
> + */
> +/*
> + *  Bit definitions for MC417_RWD and MC417_OEN registers
> + * bits 31-16
> + * +-----------+
> + * | Reserved  |
> + * +-----------+
> + *   bit 15  bit 14  bit 13 bit 12  bit 11  bit 10  bit 9   bit 8
> + * +-------+-------+-------+-------+-------+-------+-------+-------+
> + * |  TDI  |  TDO  |  TCK  |  RDY# |  #RD  |  #WR  | AD_RG |  #CS  |
> + * +-------+-------+-------+-------+-------+-------+-------+-------+
> + *  bit 7   bit 6   bit 5   bit 4   bit 3   bit 2   bit 1   bit 0
> + * +-------+-------+-------+-------+-------+-------+-------+-------+
> + * |  DATA7|  DATA6|  DATA5|  DATA4|  DATA3|  DATA2|  DATA1|  DATA0|
> + * +-------+-------+-------+-------+-------+-------+-------+-------+
> + */
> +#include <linux/version.h>
> +#include <media/videobuf-dma-sg.h>
> +#include <media/videobuf-dvb.h>
> +#include "altera-ci.h"
> +#include "dvb_ca_en50221.h"
> +
> +/* FPGA regs */
> +#define NETUP_CI_INT_CTRL	0x00
> +#define NETUP_CI_BUSCTRL2	0x01
> +#define NETUP_CI_ADDR0		0x04
> +#define NETUP_CI_ADDR1		0x05
> +#define NETUP_CI_DATA		0x06
> +#define NETUP_CI_BUSCTRL	0x07
> +#define NETUP_CI_PID_ADDR0	0x08
> +#define NETUP_CI_PID_ADDR1	0x09
> +#define NETUP_CI_PID_DATA	0x0a
> +#define NETUP_CI_TSA_DIV	0x0c
> +#define NETUP_CI_TSB_DIV	0x0d
> +#define NETUP_CI_REVISION	0x0f
> +
> +/* const for ci op */
> +#define NETUP_CI_FLG_CTL	1
> +#define NETUP_CI_FLG_RD		1
> +#define NETUP_CI_FLG_AD		1
> +
> +static unsigned int ci_dbg;
> +module_param(ci_dbg, int, 0644);
> +MODULE_PARM_DESC(ci_dbg, "Enable CI debugging");
> +
> +static unsigned int pid_dbg;
> +module_param(pid_dbg, int, 0644);
> +MODULE_PARM_DESC(pid_dbg, "Enable PID filtering debugging");
> +
> +MODULE_DESCRIPTION("altera FPGA CI module");
> +MODULE_AUTHOR("Igor M. Liplianin  <liplianin@netup.ru>");
> +MODULE_LICENSE("GPL");
> +
> +#define ci_dbg_print(args...) \
> +	do { \
> +		if (ci_dbg) \
> +			printk(KERN_DEBUG args); \
> +	} while (0)
> +
> +#define pid_dbg_print(args...) \
> +	do { \
> +		if (pid_dbg) \
> +			printk(KERN_DEBUG args); \
> +	} while (0)
> +
> +struct netup_ci_state;
> +struct netup_hw_pid_filter;
> +
> +struct fpga_internal {
> +	void *dev;
> +	struct mutex fpga_mutex;/* two CI's on the same fpga */
> +	struct netup_hw_pid_filter *pid_filt[2];
> +	struct netup_ci_state *state[2];
> +	struct work_struct work;
> +	int (*fpga_rw) (void *dev, int flag, int data, int rw);
> +	int cis_used;
> +	int filts_used;
> +	int strt_wrk;
> +};
> +
> +/* stores all private variables for communication with CI */
> +struct netup_ci_state {
> +	struct fpga_internal *internal;
> +	struct dvb_ca_en50221 ca;
> +	int status;
> +	int nr;
> +};
> +
> +/* stores all private variables for hardware pid filtering */
> +struct netup_hw_pid_filter {
> +	struct fpga_internal *internal;
> +	struct dvb_demux *demux;
> +	/* save old functions */
> +	int (*start_feed)(struct dvb_demux_feed *feed);
> +	int (*stop_feed)(struct dvb_demux_feed *feed);
> +
> +	int status;
> +	int nr;
> +};
> +
> +/* internal params node */
> +struct fpga_inode {
> +	/* pointer for internal params, one for each pair of CI's */
> +	struct fpga_internal		*internal;
> +	struct fpga_inode		*next_inode;
> +};
> +
> +/* first internal params */
> +static struct fpga_inode *fpga_first_inode;
> +
> +/* find chip by dev */
> +static struct fpga_inode *find_inode(void *dev)
> +{
> +	struct fpga_inode *temp_chip = fpga_first_inode;
> +
> +	if (temp_chip == NULL)
> +		return temp_chip;
> +
> +	/*
> +	 Search for the last fpga CI chip or
> +	 find it by dev */
> +	while ((temp_chip != NULL) &&
> +				(temp_chip->internal->dev != dev))
> +		temp_chip = temp_chip->next_inode;
> +
> +	return temp_chip;
> +}
> +/* check demux */
> +static struct fpga_internal *check_filter(struct fpga_internal *temp_int,
> +						void *demux_dev, int filt_nr)
> +{
> +	if (temp_int == NULL)
> +		return NULL;
> +
> +	if ((temp_int->pid_filt[filt_nr]) == NULL)
> +		return NULL;
> +
> +	if (temp_int->pid_filt[filt_nr]->demux == demux_dev)
> +		return temp_int;
> +
> +	return NULL;
> +}
> +
> +/* find chip by demux */
> +static struct fpga_inode *find_dinode(void *demux_dev)
> +{
> +	struct fpga_inode *temp_chip = fpga_first_inode;
> +	struct fpga_internal *temp_int;
> +
> +	/*
> +	 * Search of the last fpga CI chip or
> +	 * find it by demux
> +	 */
> +	while (temp_chip != NULL) {
> +		if (temp_chip->internal != NULL) {
> +			temp_int = temp_chip->internal;
> +			if (check_filter(temp_int, demux_dev,0))
> +				break;
> +			if (check_filter(temp_int, demux_dev,1))
> +				break;
> +		}
> +
> +		temp_chip = temp_chip->next_inode;
> +	}
> +
> +	return temp_chip;
> +}
> +
> +/* deallocating chip */
> +static void remove_inode(struct fpga_internal *internal)
> +{
> +	struct fpga_inode *prev_node = fpga_first_inode;
> +	struct fpga_inode *del_node = find_inode(internal->dev);
> +
> +	if (del_node != NULL) {
> +		if (del_node == fpga_first_inode) {
> +			fpga_first_inode = del_node->next_inode;
> +		} else {
> +			while (prev_node->next_inode != del_node)
> +				prev_node = prev_node->next_inode;
> +
> +			if (del_node->next_inode == NULL)
> +				prev_node->next_inode = NULL;
> +			else
> +				prev_node->next_inode =
> +					prev_node->next_inode->next_inode;
> +		}
> +
> +		kfree(del_node);
> +	}
> +}
> +
> +/* allocating new chip */
> +static struct fpga_inode *append_internal(struct fpga_internal *internal)
> +{
> +	struct fpga_inode *new_node = fpga_first_inode;
> +
> +	if (new_node == NULL) {
> +		new_node = kmalloc(sizeof(struct fpga_inode), GFP_KERNEL);
> +		fpga_first_inode = new_node;
> +	} else {
> +		while (new_node->next_inode != NULL)
> +			new_node = new_node->next_inode;
> +
> +		new_node->next_inode =
> +				kmalloc(sizeof(struct fpga_inode), GFP_KERNEL);
> +		if (new_node->next_inode != NULL)
> +			new_node = new_node->next_inode;
> +		else
> +			new_node = NULL;
> +	}
> +
> +	if (new_node != NULL) {
> +		new_node->internal = internal;
> +		new_node->next_inode = NULL;
> +	}
> +
> +	return new_node;
> +}
> +
> +static int netup_fpga_op_rw(struct fpga_internal *inter, int addr,
> +							u8 val, u8 read)
> +{
> +	inter->fpga_rw(inter->dev, NETUP_CI_FLG_AD, addr, 0);
> +	return (inter->fpga_rw(inter->dev, 0, val, read));
> +}
> +
> +/* flag - mem/io, read - read/write */
> +int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
> +				u8 flag, u8 read, int addr, u8 val)
> +{
> +
> +	struct netup_ci_state *state = en50221->data;
> +	struct fpga_internal *inter = state->internal;
> +
> +	u8 store;
> +	int mem = 0;
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	netup_fpga_op_rw(inter, NETUP_CI_ADDR0, ((addr << 1) & 0xfe), 0);
> +	netup_fpga_op_rw(inter, NETUP_CI_ADDR1, ((addr >> 7) & 0x7f), 0);
> +	store = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
> +
> +	store &= 0x3f;
> +	store |= ((state->nr << 7) | (flag << 6));
> +
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, store, 0);
> +	mem = netup_fpga_op_rw(inter, NETUP_CI_DATA, val, read);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	ci_dbg_print("%s: %s: addr=[0x%02x], %s=%x\n", __func__,
> +			(read) ? "read" : "write", addr,
> +			(flag == NETUP_CI_FLG_CTL) ? "ctl" : "mem",
> +			(read) ? mem : val);
> +
> +	return mem;
> +}
> +
> +int netup_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
> +						int slot, int addr)
> +{
> +	return netup_ci_op_cam(en50221, slot, 0, NETUP_CI_FLG_RD, addr, 0);
> +}
> +
> +int netup_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
> +						int slot, int addr, u8 data)
> +{
> +	return netup_ci_op_cam(en50221, slot, 0, 0, addr, data);
> +}
> +
> +int netup_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221, int slot, u8 addr)
> +{
> +	return netup_ci_op_cam(en50221, slot, NETUP_CI_FLG_CTL,
> +						NETUP_CI_FLG_RD, addr, 0);
> +}
> +
> +int netup_ci_write_cam_ctl(struct dvb_ca_en50221 *en50221, int slot,
> +						u8 addr, u8 data)
> +{
> +	return netup_ci_op_cam(en50221, slot, NETUP_CI_FLG_CTL, 0, addr, data);
> +}
> +
> +int netup_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	struct netup_ci_state *state = en50221->data;
> +	struct fpga_internal *inter = state->internal;
> +	/* reasonable timeout for CI reset is 10 seconds */
> +	unsigned long t_out = jiffies + msecs_to_jiffies(9999);
> +	int ret;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
> +				ret | (1 << (5 - state->nr)), 0);
> +
> +	for (;;) {
> +		mdelay(50);
> +		ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
> +						0, NETUP_CI_FLG_RD);
> +		if ((ret & (1 << (5 - state->nr))) == 0)
> +			break;
> +		if (time_after(jiffies, t_out))
> +			break;
> +	}
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	printk("%s: %d msecs\n", __func__,
> +		jiffies_to_msecs(jiffies + msecs_to_jiffies(9999) - t_out));
> +
> +	return 0;
> +}
> +
> +int netup_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	/* not implemented */
> +	return 0;
> +}
> +
> +int netup_ci_slot_ts_ctl(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	struct netup_ci_state *state = en50221->data;
> +	struct fpga_internal *inter = state->internal;
> +	int ret;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL,
> +				ret | (1 << (3 - state->nr)), 0);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	return 0;
> +}
> +
> +/* work handler */
> +static void netup_read_ci_status(struct work_struct *work)
> +{
> +	struct fpga_internal *inter =
> +			container_of(work, struct fpga_internal, work);
> +	int ret;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	mutex_lock(&inter->fpga_mutex);
> +	/* ack' irq */
> +	ret = netup_fpga_op_rw(inter, NETUP_CI_INT_CTRL, 0, NETUP_CI_FLG_RD);
> +	ret = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL, 0, NETUP_CI_FLG_RD);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	if (inter->state[1] != NULL){
> +		inter->state[1]->status =
> +				((ret & 1) == 0 ?
> +				DVB_CA_EN50221_POLL_CAM_PRESENT |
> +				DVB_CA_EN50221_POLL_CAM_READY : 0);
> +		ci_dbg_print("%s: setting CI[1] status = 0x%x \n",
> +				__func__, inter->state[1]->status);
> +	};
> +
> +	if (inter->state[0] != NULL){
> +		inter->state[0]->status =
> +				((ret & 2) == 0 ?
> +				DVB_CA_EN50221_POLL_CAM_PRESENT |
> +				DVB_CA_EN50221_POLL_CAM_READY : 0);
> +		ci_dbg_print("%s: setting CI[0] status = 0x%x \n",
> +				__func__, inter->state[0]->status);
> +	};
> +}
> +
> +/* CI irq handler */
> +int altera_ci_irq(void *dev)
> +{
> +	struct fpga_inode *temp_int = NULL;
> +	struct fpga_internal *inter = NULL;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (dev != NULL) {
> +		temp_int = find_inode(dev);
> +		if (temp_int != NULL) {
> +			inter = temp_int->internal;
> +			schedule_work(&inter->work);
> +		}
> +	}
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(altera_ci_irq);
> +
> +int netup_poll_ci_slot_status(struct dvb_ca_en50221 *en50221, int slot,
> +								int open)
> +{
> +	struct netup_ci_state *state = en50221->data;
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	return state->status;
> +}
> +
> +int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr);
> +
> +int altera_ci_init(struct altera_ci_config *config, int ci_nr)
> +{
> +	struct netup_ci_state *state;
> +	struct fpga_inode *temp_int = find_inode(config->dev);
> +	struct fpga_internal *inter = NULL;
> +	int ret = 0;
> +	u8 store = 0;
> +
> +	state = kzalloc(sizeof(struct netup_ci_state), GFP_KERNEL);
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (!state) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	if (temp_int != NULL) {
> +		inter = temp_int->internal;
> +		(inter->cis_used)++;
> +		printk("%s: Find Internal Structure!\n", __func__);
> +	} else {
> +		inter = kzalloc(sizeof(struct fpga_internal), GFP_KERNEL);
> +		if (!inter) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		temp_int = append_internal(inter);
> +		inter->cis_used = 1;
> +		inter->dev = config->dev;
> +		inter->fpga_rw = config->fpga_rw;
> +		mutex_init(&inter->fpga_mutex);
> +		inter->strt_wrk = 1;
> +		printk("%s: Create New Internal Structure!\n", __func__);
> +	}
> +
> +	printk("%s: setting state = 0x%x for ci = %d\n", __func__,
> +						(int)state, ci_nr - 1);
> +	inter->state[ci_nr - 1] = state;
> +	state->internal = inter;
> +	state->nr = ci_nr - 1;
> +
> +	state->ca.owner = THIS_MODULE;
> +	state->ca.read_attribute_mem = netup_ci_read_attribute_mem;
> +	state->ca.write_attribute_mem = netup_ci_write_attribute_mem;
> +	state->ca.read_cam_control = netup_ci_read_cam_ctl;
> +	state->ca.write_cam_control = netup_ci_write_cam_ctl;
> +	state->ca.slot_reset = netup_ci_slot_reset;
> +	state->ca.slot_shutdown = netup_ci_slot_shutdown;
> +	state->ca.slot_ts_enable = netup_ci_slot_ts_ctl;
> +	state->ca.poll_slot_status = netup_poll_ci_slot_status;
> +	state->ca.data = state;
> +
> +	ret = dvb_ca_en50221_init(config->adapter,
> +				   &state->ca,
> +				   /* flags */ 0,
> +				   /* n_slots */ 1);
> +	if (0 != ret)
> +		goto err;
> +
> +	altera_hw_filt_init(config, ci_nr);
> +
> +	if (inter->strt_wrk) {
> +		INIT_WORK(&inter->work, netup_read_ci_status);
> +		inter->strt_wrk = 0;
> +	}
> +
> +	printk("%s: CI initialized!\n", __func__);
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	/* Enable div */
> +	netup_fpga_op_rw(inter, NETUP_CI_TSA_DIV, 0x0, 0);
> +	netup_fpga_op_rw(inter, NETUP_CI_TSB_DIV, 0x0, 0);
> +
> +	/* enable TS out */
> +	store = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL2, 0, NETUP_CI_FLG_RD);
> +	store |= (3 << 4);
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL2, store, 0);
> +
> +	ret = netup_fpga_op_rw(inter, NETUP_CI_REVISION, 0, NETUP_CI_FLG_RD);
> +	/* enable irq */
> +	netup_fpga_op_rw(inter, NETUP_CI_INT_CTRL, 0x44, 0);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	printk("%s: NetUP CI Revision = 0x%x\n", __func__, ret);
> +
> +	schedule_work(&inter->work);
> +
> +	return 0;
> +err:
> +	printk("%s: Cannot initialize CI: Error %d.\n", __func__, ret);
> +	if (state)
> +		kfree(state);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(altera_ci_init);
> +
> +void altera_hw_filt_release(void *main_dev, int filt_nr)
> +{
> +	struct fpga_inode *temp_int = find_inode(main_dev);
> +	struct netup_hw_pid_filter *pid_filt = NULL;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (temp_int != NULL) {
> +		pid_filt = temp_int->internal->pid_filt[filt_nr - 1];
> +		/* stored old feed controls */
> +		pid_filt->demux->start_feed = pid_filt->start_feed;
> +		pid_filt->demux->stop_feed = pid_filt->stop_feed;
> +
> +		if (((--(temp_int->internal->filts_used)) <= 0) &&
> +			 ((temp_int->internal->cis_used) <= 0)) {
> +
> +			printk("%s: Actually removing\n", __func__);
> +
> +			remove_inode(temp_int->internal);
> +			kfree(pid_filt->internal);
> +		}
> +
> +		if (pid_filt != NULL)
> +			kfree(pid_filt);
> +
> +	}
> +
> +}
> +EXPORT_SYMBOL(altera_hw_filt_release);
> +
> +void altera_ci_release(void *dev, int ci_nr)
> +{
> +	struct fpga_inode *temp_int = find_inode(dev);
> +	struct netup_ci_state *state = NULL;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (temp_int != NULL) {
> +		state = temp_int->internal->state[ci_nr - 1];
> +		altera_hw_filt_release(dev, ci_nr);
> +
> +
> +		if (((temp_int->internal->filts_used) <= 0) &&
> +				((--(temp_int->internal->cis_used)) <= 0)) {
> +
> +			printk("%s: Actually removing\n", __func__);
> +
> +			remove_inode(temp_int->internal);
> +			kfree(state->internal);
> +		}
> +
> +		if (state != NULL) {
> +			if (state->ca.data != NULL)
> +				dvb_ca_en50221_release(&state->ca);
> +
> +			kfree(state);
> +		}
> +	}
> +
> +}
> +EXPORT_SYMBOL(altera_ci_release);
> +
> +int altera_ci_start_feed_1(struct dvb_demux_feed *feed);
> +int altera_ci_stop_feed_1(struct dvb_demux_feed *feed);
> +int altera_ci_start_feed_2(struct dvb_demux_feed *feed);
> +int altera_ci_stop_feed_2(struct dvb_demux_feed *feed);
> +
> +static void altera_toggle_fullts_streaming(struct netup_hw_pid_filter *pid_filt,
> +					int filt_nr, int onoff)
> +{
> +	struct fpga_internal *inter = pid_filt->internal;
> +	u8 store = 0;
> +	int i;
> +
> +	pid_dbg_print("%s: pid_filt->nr[%d]  now %s\n", __func__, pid_filt->nr,
> +			onoff ? "off" : "on");
> +
> +	if (onoff)/* 0 - on, 1 - off */
> +		store = 0xff;/* ignore pid */
> +	else
> +		store = 0;/* enable pid */
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	for (i = 0; i < 1024; i++) {
> +		netup_fpga_op_rw(inter, NETUP_CI_PID_ADDR0, i & 0xff, 0);
> +
> +		netup_fpga_op_rw(inter, NETUP_CI_PID_ADDR1,
> +				((i >> 8) & 0x03) | (pid_filt->nr << 2), 0);
> +
> +		netup_fpga_op_rw(inter, NETUP_CI_PID_DATA, store, 0);
> +	}
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +}
> +
> +int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr)
> +{
> +	struct netup_hw_pid_filter *pid_filt = NULL;
> +	struct fpga_inode *temp_int = find_inode(config->dev);
> +	struct fpga_internal *inter = NULL;
> +	int ret = 0;
> +
> +	pid_filt = kzalloc(sizeof(struct netup_hw_pid_filter), GFP_KERNEL);
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (!pid_filt) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	if (temp_int != NULL) {
> +		inter = temp_int->internal;
> +		(inter->filts_used)++;
> +		printk("%s: Find Internal Structure!\n", __func__);
> +	} else {
> +		inter = kzalloc(sizeof(struct fpga_internal), GFP_KERNEL);
> +		if (!inter) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		temp_int = append_internal(inter);
> +		inter->filts_used = 1;
> +		inter->dev = config->dev;
> +		inter->fpga_rw = config->fpga_rw;
> +		mutex_init(&inter->fpga_mutex);
> +		inter->strt_wrk = 1;
> +		printk("%s: Create New Internal Structure!\n", __func__);
> +	}
> +
> +	printk("%s: setting hw pid filter = 0x%x for ci = %d\n", __func__,
> +						(int)pid_filt, hw_filt_nr - 1);
> +	inter->pid_filt[hw_filt_nr - 1] = pid_filt;
> +	pid_filt->demux = config->demux;
> +	pid_filt->internal = inter;
> +	pid_filt->nr = hw_filt_nr - 1;
> +	/* store old feed controls */
> +	pid_filt->start_feed = config->demux->start_feed;
> +	pid_filt->stop_feed = config->demux->stop_feed;
> +	/* replace with new feed controls */
> +	if (hw_filt_nr == 1) {
> +		pid_filt->demux->start_feed = altera_ci_start_feed_1;
> +		pid_filt->demux->stop_feed = altera_ci_stop_feed_1;
> +	} else if (hw_filt_nr == 2) {
> +		pid_filt->demux->start_feed = altera_ci_start_feed_2;
> +		pid_filt->demux->stop_feed = altera_ci_stop_feed_2;
> +	}
> +
> +	altera_toggle_fullts_streaming(pid_filt, 0, 1);
> +
> +	return 0;
> +err:
> +	printk("%s: Can't init hardware filter: Error %d\n", __func__, ret);
> +	if (pid_filt)
> +		kfree(pid_filt);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(altera_hw_filt_init);
> +
> +static void altera_pid_control(struct netup_hw_pid_filter *pid_filt,
> +		u16 pid, int onoff)
> +{
> +	struct fpga_internal *inter = pid_filt->internal;
> +	u8 store = 0;
> +
> +	if (pid == 0x2000)
> +		return;
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	netup_fpga_op_rw(inter, NETUP_CI_PID_ADDR0, (pid >> 3) & 0xff, 0);
> +	netup_fpga_op_rw(inter, NETUP_CI_PID_ADDR1,
> +			((pid >> 11) & 0x03) | (pid_filt->nr << 2), 0);
> +
> +	store = netup_fpga_op_rw(inter, NETUP_CI_PID_DATA, 0, NETUP_CI_FLG_RD);
> +
> +	if (onoff)/* 0 - on, 1 - off */
> +		store |= (1 << (pid & 7));
> +	else
> +		store &= ~(1 << (pid & 7));
> +
> +	netup_fpga_op_rw(inter, NETUP_CI_PID_DATA, store, 0);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	pid_dbg_print("%s: (%d) set pid: %5d 0x%04x '%s'\n", __func__,
> +		pid_filt->nr, pid, pid, onoff ? "off" : "on");
> +}
> +
> +int altera_pid_feed_control(void *demux_dev, int filt_nr,
> +		struct dvb_demux_feed *feed, int onoff)
> +{
> +	struct fpga_inode *temp_int = find_dinode(demux_dev);
> +	struct fpga_internal *inter = temp_int->internal;
> +	struct netup_hw_pid_filter *pid_filt = inter->pid_filt[filt_nr - 1];
> +
> +	altera_pid_control(pid_filt, feed->pid, onoff ? 0 : 1);
> +	/* call old feed proc's */
> +	if (onoff)
> +		pid_filt->start_feed(feed);
> +	else
> +		pid_filt->stop_feed(feed);
> +
> +	if (feed->pid == 0x2000)
> +		altera_toggle_fullts_streaming(pid_filt, filt_nr,
> +						onoff ? 0 : 1);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(altera_pid_feed_control);
> +
> +int altera_ci_start_feed(struct dvb_demux_feed *feed, int num)
> +{
> +	altera_pid_feed_control(feed->demux, num, feed, 1);
> +
> +	return 0;
> +}
> +
> +int altera_ci_stop_feed(struct dvb_demux_feed *feed, int num)
> +{
> +	altera_pid_feed_control(feed->demux, num, feed, 0);
> +
> +	return 0;
> +}
> +
> +int altera_ci_start_feed_1(struct dvb_demux_feed *feed)
> +{
> +	return altera_ci_start_feed(feed, 1);
> +}
> +
> +int altera_ci_stop_feed_1(struct dvb_demux_feed *feed)
> +{
> +	return altera_ci_stop_feed(feed, 1);
> +}
> +
> +int altera_ci_start_feed_2(struct dvb_demux_feed *feed)
> +{
> +	return altera_ci_start_feed(feed, 2);
> +}
> +
> +int altera_ci_stop_feed_2(struct dvb_demux_feed *feed)
> +{
> +	return altera_ci_stop_feed(feed, 2);
> +}
> +
> +int altera_ci_tuner_reset(void *dev, int ci_nr)
> +{
> +	struct fpga_inode *temp_int = find_inode(dev);
> +	struct fpga_internal *inter = NULL;
> +	u8 store;
> +
> +	ci_dbg_print("%s\n", __func__);
> +
> +	if (temp_int == NULL)
> +		return -1;
> +
> +	if (temp_int->internal == NULL)
> +		return -1;
> +
> +	inter = temp_int->internal;
> +
> +	mutex_lock(&inter->fpga_mutex);
> +
> +	store = netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL2, 0, NETUP_CI_FLG_RD);
> +	store &= ~(4 << (2 - ci_nr));
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL2, store, 0);
> +	msleep(100);
> +	store |= (4 << (2 - ci_nr));
> +	netup_fpga_op_rw(inter, NETUP_CI_BUSCTRL2, store, 0);
> +
> +	mutex_unlock(&inter->fpga_mutex);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(altera_ci_tuner_reset);
> diff --git a/drivers/media/video/cx23885/altera-ci.h b/drivers/media/video/cx23885/altera-ci.h
> new file mode 100644
> index 0000000..ba0c6c0
> --- /dev/null
> +++ b/drivers/media/video/cx23885/altera-ci.h
> @@ -0,0 +1,102 @@
> +/*
> + * altera-ci.c
> + *
> + *  CI driver in conjunction with NetUp Dual DVB-T/C RF CI card
> + *
> + * Copyright (C) 2010 NetUP Inc.
> + * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +#ifndef __ALTERA_CI_H
> +#define __ALTERA_CI_H
> +
> +#define ALT_DATA	0x000000ff
> +#define ALT_TDI		0x00008000
> +#define ALT_TDO		0x00004000
> +#define ALT_TCK		0x00002000
> +#define ALT_RDY		0x00001000
> +#define ALT_RD		0x00000800
> +#define ALT_WR		0x00000400
> +#define ALT_AD_RG	0x00000200
> +#define ALT_CS		0x00000100
> +
> +struct altera_ci_config {
> +	void *dev;/* main dev, for example cx23885_dev */
> +	void *adapter;/* for CI to connect to */
> +	struct dvb_demux *demux;/* for hardware PID filter to connect to */
> +	int (*fpga_rw) (void *dev, int ad_rg, int val, int rw);
> +};
> +
> +#if defined(CONFIG_MEDIA_ALTERA_CI) || (defined(CONFIG_MEDIA_ALTERA_CI_MODULE) \
> +							&& defined(MODULE))
> +
> +extern int altera_ci_init(struct altera_ci_config *config, int ci_nr);
> +extern void altera_ci_release(void *dev, int ci_nr);
> +extern int altera_ci_irq(void *dev);
> +extern int altera_ci_tuner_reset(void *dev, int ci_nr);
> +
> +#else
> +
> +static inline int altera_ci_init(struct altera_ci_config *config, int ci_nr)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +static inline void altera_ci_release(void *dev, int ci_nr)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +static inline int altera_ci_irq(void *dev)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +static int altera_ci_tuner_reset(void *dev, int ci_nr)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +#endif
> +#if 0
> +static inline int altera_hw_filt_init(struct altera_ci_config *config,
> +							int hw_filt_nr)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +static inline void altera_hw_filt_release(void *dev, int filt_nr)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +static inline int altera_pid_feed_control(void *dev, int filt_nr,
> +		struct dvb_demux_feed *dvbdmxfeed, int onoff)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return 0;
> +}
> +
> +#endif /* CONFIG_MEDIA_ALTERA_CI */
> +
> +#endif /* __ALTERA_CI_H */

