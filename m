Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43734 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3KCKui (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 05:50:38 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO00316OSEVN20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 05:50:38 -0500 (EST)
Date: Sun, 03 Nov 2013 08:50:33 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maik Broemme <mbroemme@parallels.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 11/12] ddbridge: Update ddbridge header for 0.9.10 changes
Message-id: <20131103085033.539941c9@samsung.com>
In-reply-to: <20131103004531.GO7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103004531.GO7956@parallels.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 01:45:31 +0100
Maik Broemme <mbroemme@parallels.com> escreveu:

> Updated ddbridge header for 0.9.10 changes.

Those changes should not be on a separate patch, as it will for sure
break compilation.

> 
> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> ---
>  drivers/media/pci/ddbridge/ddbridge.h | 408 ++++++++++++++++++++++++++++------
>  1 file changed, 343 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
> index 8b1b41d..f35a5b4 100644
> --- a/drivers/media/pci/ddbridge/ddbridge.h
> +++ b/drivers/media/pci/ddbridge/ddbridge.h
> @@ -1,38 +1,69 @@
>  /*
> - * ddbridge.h: Digital Devices PCIe bridge driver
> + *  ddbridge.h: Digital Devices PCIe bridge driver
>   *
> - * Copyright (C) 2010-2011 Digital Devices GmbH
> + *  Copyright (C) 2010-2013 Digital Devices GmbH
> + *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
>   *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * version 2 only, as published by the Free Software Foundation.
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  version 2 only, as published by the Free Software Foundation.
>   *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
>   *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA
> - * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + *  02110-1301, USA
>   */
>  
>  #ifndef _DDBRIDGE_H_
>  #define _DDBRIDGE_H_
>  
> +#include <linux/version.h>
> +
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,8,0))
> +#define __devexit
> +#define __devinit
> +#endif
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/poll.h>
> +#include <linux/io.h>
> +#include <linux/pci.h>
> +#include <linux/pci_ids.h>
> +#include <linux/timer.h>
> +#include <linux/i2c.h>
> +#include <linux/swab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
> +#include <linux/kthread.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/spi/spi.h>
> +#include <linux/gpio.h>
> +#include <linux/completion.h>
> +
>  #include <linux/types.h>
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  #include <asm/dma.h>
> -#include <linux/dvb/frontend.h>
> +#include <asm/io.h>
> +#include <asm/irq.h>
> +#include <asm/uaccess.h>
> +
>  #include <linux/dvb/ca.h>
>  #include <linux/socket.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
>  
>  #include "dmxdev.h"
>  #include "dvbdev.h"
> @@ -44,51 +75,83 @@
>  #include "cxd2099.h"
>  
>  #define DDB_MAX_I2C     4
> -#define DDB_MAX_PORT    4
> +#define DDB_MAX_PORT   10
>  #define DDB_MAX_INPUT   8
> -#define DDB_MAX_OUTPUT  4
> +#define DDB_MAX_OUTPUT 10
> +
> +struct ddb_regset {
> +	uint32_t base;
> +	uint32_t num;
> +	uint32_t size;
> +};
> +
> +struct ddb_regmap {
> +	struct ddb_regset i2c;
> +	struct ddb_regset i2c_buf;
> +	struct ddb_regset dma;
> +	struct ddb_regset dma_buf;
> +	struct ddb_regset input;
> +	struct ddb_regset output;
> +	struct ddb_regset channel;
> +	struct ddb_regset ci;
> +	struct ddb_regset pid_filter;
> +};
>  
>  struct ddb_info {
>  	int   type;
>  #define DDB_NONE         0
>  #define DDB_OCTOPUS      1
> +#define DDB_OCTOPUS_CI   2
> +#define DDB_MOD          3
> +#define DDB_OCTONET      4
>  	char *name;
>  	int   port_num;
> -	u32   port_type[DDB_MAX_PORT];
> +	int   i2c_num;
> +	int   led_num;
> +	int   fan_num;
> +	int   temp_num;
> +	int   temp_bus;
> +	struct ddb_regmap regmap;
>  };
>  
> -/* DMA_SIZE MUST be divisible by 188 and 128 !!! */
> +/* DMA_SIZE MUST be smaller than 256k and 
> +   MUST be divisible by 188 and 128 !!! */
> +
> +#define DMA_MAX_BUFS 32      /* hardware table limit */
>  
> -#define INPUT_DMA_MAX_BUFS 32      /* hardware table limit */
>  #define INPUT_DMA_BUFS 8
>  #define INPUT_DMA_SIZE (128*47*21)
> +#define INPUT_DMA_IRQ_DIV 1
>  
> -#define OUTPUT_DMA_MAX_BUFS 32
>  #define OUTPUT_DMA_BUFS 8
>  #define OUTPUT_DMA_SIZE (128*47*21)
> +#define OUTPUT_DMA_IRQ_DIV 1
>  
>  struct ddb;
>  struct ddb_port;
>  
> -struct ddb_input {
> -	struct ddb_port       *port;
> +struct ddb_dma {
> +	void                  *io;
>  	u32                    nr;
> -	int                    attached;
> -
> -	dma_addr_t             pbuf[INPUT_DMA_MAX_BUFS];
> -	u8                    *vbuf[INPUT_DMA_MAX_BUFS];
> -	u32                    dma_buf_num;
> -	u32                    dma_buf_size;
> -
> -	struct tasklet_struct  tasklet;
> +	dma_addr_t             pbuf[DMA_MAX_BUFS];
> +	u8                    *vbuf[DMA_MAX_BUFS];
> +	u32                    num;
> +	u32                    size;
> +	u32                    div;
> +	u32                    bufreg;
> +	struct work_struct     work;
>  	spinlock_t             lock;
>  	wait_queue_head_t      wq;
>  	int                    running;
>  	u32                    stat;
> +	u32                    ctrl;
>  	u32                    cbuf;
>  	u32                    coff;
> +};
>  
> -	struct dvb_adapter     adap;
> +struct ddb_dvb {
> +	struct dvb_adapter    *adap;
> +	int                    adap_registered;
>  	struct dvb_device     *dev;
>  	struct dvb_frontend   *fe;
>  	struct dvb_frontend   *fe2;
> @@ -99,37 +162,35 @@ struct ddb_input {
>  	struct dmx_frontend    mem_frontend;
>  	int                    users;
>  	int (*gate_ctrl)(struct dvb_frontend *, int);
> +	int                    attached;
>  };
>  
> -struct ddb_output {
> +struct ddb_ci {
> +	struct dvb_ca_en50221  en;
>  	struct ddb_port       *port;
>  	u32                    nr;
> -	dma_addr_t             pbuf[OUTPUT_DMA_MAX_BUFS];
> -	u8                    *vbuf[OUTPUT_DMA_MAX_BUFS];
> -	u32                    dma_buf_num;
> -	u32                    dma_buf_size;
> -	struct tasklet_struct  tasklet;
> -	spinlock_t             lock;
> -	wait_queue_head_t      wq;
> -	int                    running;
> -	u32                    stat;
> -	u32                    cbuf;
> -	u32                    coff;
> +	struct mutex           lock;
> +};
>  
> -	struct dvb_adapter     adap;
> -	struct dvb_device     *dev;
> +struct ddb_io {
> +	struct ddb_port       *port;
> +	u32                    nr;
> +	struct ddb_dma        *dma;
> +	struct ddb_io         *redo;
> +	struct ddb_io         *redi;
>  };
>  
> +#define ddb_output ddb_io
> +#define ddb_input ddb_io
> +
>  struct ddb_i2c {
>  	struct ddb            *dev;
>  	u32                    nr;
>  	struct i2c_adapter     adap;
> -	struct i2c_adapter     adap2;
>  	u32                    regs;
>  	u32                    rbuf;
>  	u32                    wbuf;
> -	int                    done;
> -	wait_queue_head_t      wq;
> +	struct completion      completion;
>  };
>  
>  struct ddb_port {
> @@ -141,45 +202,262 @@ struct ddb_port {
>  #define DDB_PORT_NONE           0
>  #define DDB_PORT_CI             1
>  #define DDB_PORT_TUNER          2
> +#define DDB_PORT_LOOP           3
> +#define DDB_PORT_MOD            4
>  	u32                    type;
>  #define DDB_TUNER_NONE          0
>  #define DDB_TUNER_DVBS_ST       1
>  #define DDB_TUNER_DVBS_ST_AA    2
> -#define DDB_TUNER_DVBCT_TR     16
> -#define DDB_TUNER_DVBCT_ST     17
> +#define DDB_TUNER_DVBCT_TR      3
> +#define DDB_TUNER_DVBCT_ST      4
> +#define DDB_CI_INTERNAL         5
> +#define DDB_CI_EXTERNAL_SONY    6
> +#define DDB_TUNER_XO2           16
> +#define DDB_TUNER_DVBS          16
> +#define DDB_TUNER_DVBCT2_SONY   17
> +#define DDB_TUNER_ISDBT_SONY    18
> +#define DDB_TUNER_DVBC2T2_SONY  19
> +#define DDB_TUNER_ATSC_ST       20
> +#define DDB_TUNER_DVBC2T2_ST    21
> +
>  	u32                    adr;
>  
>  	struct ddb_input      *input[2];
>  	struct ddb_output     *output;
>  	struct dvb_ca_en50221 *en;
> +	struct ddb_dvb         dvb[2];
> +	u32                    gap;
> +	u32                    obr;
> +};
> +
> +struct mod_base {
> +	u32                    frequency;
> +
> +	u32                    flat_start;
> +	u32                    flat_end;
> +};
> +
> +struct mod_state {
> +	u32                    modulation;
> +
> +	u32                    do_handle;
> +
> +	u32                    rate_inc;
> +	u32                    Control;
> +	u32                    State;
> +	u32                    StateCounter;
> +	s32                    LastPCRAdjust;
> +	s32                    PCRAdjustSum;
> +	s32                    InPacketsSum;
> +	s32                    OutPacketsSum;
> +	s64                    PCRIncrement;
> +	s64                    PCRDecrement;
> +	s32                    PCRRunningCorr;
> +	u32                    OutOverflowPacketCount;
> +	u32                    InOverflowPacketCount;
> +	u32                    LastOutPacketCount;
> +	u32                    LastInPacketCount;
> +	u64                    LastOutPackets;
> +	u64                    LastInPackets;
> +	u32                    MinInputPackets;
> +};
> +
> +#define CM_STARTUP_DELAY 2
> +#define CM_AVERAGE  20
> +#define CM_GAIN     10
> +
> +#define HW_LSB_SHIFT    12
> +#define HW_LSB_MASK     0x1000
> +
> +#define CM_IDLE    0
> +#define CM_STARTUP 1
> +#define CM_ADJUST  2
> +
> +#define TS_CAPTURE_LEN  (21*188)
> +
> +/* net streaming hardware block */
> +#define DDB_NS_MAX 15
> +
> +struct ddb_ns {
> +	struct ddb_input      *input; 
> +	int                    nr;
> +	int                    fe;
> +	u32                    rtcp_udplen;
> +	u32                    rtcp_len;
> +	u32                    ts_offset;
> +	u32                    udplen;
> +	u8                     p[512];
>  };
>  
>  struct ddb {
>  	struct pci_dev        *pdev;
> +	struct platform_device *pfdev;
> +	struct device         *dev;
> +	const struct pci_device_id *id;
> +	struct ddb_info       *info;
> +	int                    msi;
> +	struct workqueue_struct *wq;
> +	u32                    has_dma;
> +	u32                    has_ns;
> +
> +	struct ddb_regmap      regmap;
>  	unsigned char         *regs;
> +	u32                    regs_len;
>  	struct ddb_port        port[DDB_MAX_PORT];
>  	struct ddb_i2c         i2c[DDB_MAX_I2C];
>  	struct ddb_input       input[DDB_MAX_INPUT];
>  	struct ddb_output      output[DDB_MAX_OUTPUT];
> +	struct dvb_adapter     adap[DDB_MAX_INPUT];
> +	struct ddb_dma         dma[DDB_MAX_INPUT + DDB_MAX_OUTPUT];
> +
> +	void                   (*handler[32])(unsigned long);
> +	unsigned long          handler_data[32];
>  
>  	struct device         *ddb_dev;
> -	int                    nr;
> +	u32                    ddb_dev_users;
> +	u32                    nr;
>  	u8                     iobuf[1028];
>  
> -	struct ddb_info       *info;
> -	int                    msi;
> +	u8                     leds;
> +	u32                    ts_irq;
> +	u32                    i2c_irq;
> +
> +	u32                    hwid;
> +	u32                    regmapid;
> +	u32                    mac;
> +	u32                    devid;
> +
> +	int                    ns_num;
> +	struct ddb_ns          ns[DDB_NS_MAX];
> +	struct mutex           mutex;
> +
> +	struct dvb_device     *nsd_dev;
> +	u8                     tsbuf[TS_CAPTURE_LEN];
> +
> +	struct mod_base        mod_base;
> +	struct mod_state       mod[10];
> +};
> +
> +static inline void ddbwriteb(struct ddb *dev, u32 val, u32 adr)
> +{
> +	writeb(val, (char *) (dev->regs+(adr)));
> +}
> +
> +static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
> +{
> +	writel(val, (char *) (dev->regs+(adr)));
> +}
> +
> +static inline void ddbwritew(struct ddb *dev, u16 val, u32 adr)
> +{
> +	writew(val, (char *) (dev->regs+(adr)));
> +}
> +
> +static inline u32 ddbreadl(struct ddb *dev, u32 adr)
> +{
> +	return readl((char *) (dev->regs+(adr)));
> +}
> +
> +static inline u32 ddbreadb(struct ddb *dev, u32 adr)
> +{
> +	return readb((char *) (dev->regs+(adr)));
> +}
> +
> +#define ddbcpyto(_dev, _adr, _src, _count) \
> +	memcpy_toio((char *) (_dev->regs + (_adr)), (_src), (_count))
> +
> +#define ddbcpyfrom(_dev, _dst, _adr, _count) \
> +	memcpy_fromio((_dst), (char *) (_dev->regs + (_adr)), (_count))
> +
> +#define ddbmemset(_dev, _adr, _val, _count) \
> +	memset_io((char *) (_dev->regs + (_adr)), (_val), (_count))
> +
> +#define dd_uint8    u8
> +#define dd_uint16   u16
> +#define dd_int16    s16
> +#define dd_uint32   u32
> +#define dd_int32    s32
> +#define dd_uint64   u64
> +#define dd_int64    s64
> +
> +#define DDMOD_FLASH_START  0x1000
> +
> +struct DDMOD_FLASH_DS {
> +	dd_uint32   Symbolrate;             /* kSymbols/s */
> +	dd_uint32   DACFrequency;           /* kHz        */
> +	dd_uint16   FrequencyResolution;    /* kHz        */
> +	dd_uint16   IQTableLength;
> +	dd_uint16   FrequencyFactor;
> +	dd_int16    PhaseCorr;              /* TBD        */
> +	dd_uint32   Control2;
> +	dd_uint16   PostScaleI;   
> +	dd_uint16   PostScaleQ;
> +	dd_uint16   PreScale;
> +	dd_int16    EQTap[11];
> +	dd_uint16   FlatStart;   
> +	dd_uint16   FlatEnd;
> +	dd_uint32   FlashOffsetPrecalculatedIQTables;       /* 0 = none */
> +	dd_uint8    Reserved[28];
> +
> +};
> +
> +struct DDMOD_FLASH {
> +	dd_uint32   Magic;
> +	dd_uint16   Version;
> +	dd_uint16   DataSets;
> +	
> +	dd_uint16   VCORefFrequency;    /* MHz */
> +	dd_uint16   VCO1Frequency;      /* MHz */
> +	dd_uint16   VCO2Frequency;      /* MHz */
> +	
> +	dd_uint16   DACAux1;    /* TBD */
> +	dd_uint16   DACAux2;    /* TBD */
> +	
> +	dd_uint8    Reserved1[238];
> +	
> +	struct DDMOD_FLASH_DS DataSet[1];
> +};
> +
> +#define DDMOD_FLASH_MAGIC   0x5F564d5F
> +
> +struct dvb_mod_params {
> +	__u32 base_frequency;
> +	__u32 attenuator;
>  };
>  
> -/****************************************************************************/
> +struct dvb_mod_channel_params {
> +	enum fe_modulation modulation;
> +	__u32 rate_increment;
> +};
> +
> +#define DVB_MOD_SET		_IOW('o', 208, struct dvb_mod_params)
> +#define DVB_MOD_CHANNEL_SET	_IOW('o', 209, struct dvb_mod_channel_params)
> +
> +/* DDBridge flash functions (ddbridge-core.c) */
> +int ddbridge_flashread(struct ddb *dev, u8 *buf, u32 addr, u32 len);
>  
> -#define ddbwritel(_val, _adr)        writel((_val), \
> -				     (char *) (dev->regs+(_adr)))
> -#define ddbreadl(_adr)               readl((char *) (dev->regs+(_adr)))
> -#define ddbcpyto(_adr, _src, _count) memcpy_toio((char *)	\
> -				     (dev->regs+(_adr)), (_src), (_count))
> -#define ddbcpyfrom(_dst, _adr, _count) memcpy_fromio((_dst), (char *) \
> -				       (dev->regs+(_adr)), (_count))
> +/* DDBridge DVB-C modulator functions (ddbridge-mod.c) */
> +int ddbridge_mod_do_ioctl(struct file *file, unsigned int cmd, void *parg);
> +int ddbridge_mod_init(struct ddb *dev);
> +void ddbridge_mod_output_stop(struct ddb_output *output);
> +void ddbridge_mod_output_start(struct ddb_output *output);
> +void ddbridge_mod_rate_handler(unsigned long data);
>  
> -/****************************************************************************/
> +/* DDBrigde I2C functions (ddbridge-i2c.c) */
> +int ddb_i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len);
> +int ddb_i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val);
> +int ddb_i2c_read_regs(struct i2c_adapter *adapter,
> + 		 u8 adr, u8 reg, u8 *val, u8 len);
> +int ddb_i2c_read_regs16(struct i2c_adapter *adapter, 
> + 		   u8 adr, u16 reg, u8 *val, u8 len);
> +int ddb_i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val);
> +int ddb_i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
> + 		  u16 reg, u8 *val);
> +int ddb_i2c_write_reg16(struct i2c_adapter *adap, u8 adr,
> + 		   u16 reg, u8 val);
> +int ddb_i2c_write_reg(struct i2c_adapter *adap, u8 adr,
> + 		  u8 reg, u8 val);
> +void ddb_i2c_release(struct ddb *dev);
> +int ddb_i2c_init(struct ddb *dev);
>  
>  #endif


-- 

Cheers,
Mauro
