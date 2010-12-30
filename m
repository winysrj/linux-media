Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3137 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab0L3PXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 10:23:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [RFC V8 1/7] drivers:media:radio: wl128x: fmdrv common header file
Date: Thu, 30 Dec 2010 16:23:03 +0100
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1293707507-3376-1-git-send-email-manjunatha_halli@ti.com> <1293707507-3376-2-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1293707507-3376-2-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301623.03376.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

Below I have some suggestions on how to improve some of the names in this header.

On Thursday, December 30, 2010 12:11:41 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are common headers used in FM submodules (FM V4L2,
> FM common, FM Rx,and FM TX).
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  drivers/media/radio/wl128x/fmdrv.h |  248 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 248 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/wl128x/fmdrv.h
> 
> diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
> new file mode 100644
> index 0000000..3d73f76
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/fmdrv.h
> @@ -0,0 +1,248 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *
> + *  Common header for all FM driver sub-modules.
> + *
> + *  Copyright (C) 2009 Texas Instruments
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#ifndef _FM_DRV_H
> +#define _FM_DRV_H
> +
> +#include <linux/skbuff.h>
> +#include <linux/interrupt.h>
> +#include <sound/core.h>
> +#include <sound/initval.h>
> +#include <linux/timer.h>
> +#include <linux/version.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +
> +#define FM_DRV_VERSION            "0.01"
> +/* Should match with FM_DRV_VERSION */
> +#define FM_DRV_RADIO_VERSION      KERNEL_VERSION(0, 0, 1)
> +#define FM_DRV_NAME               "ti_fmdrv"
> +#define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
> +#define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
> +
> +/* Flag info */
> +#define FM_INTTASK_RUNNING            0
> +#define FM_INTTASK_SCHEDULE_PENDING   1
> +#define FM_FIRMWARE_DW_INPROGRESS     2
> +#define FM_CORE_READY                 3
> +#define FM_CORE_TRANSPORT_READY       4
> +#define FM_AF_SWITCH_INPROGRESS	      5
> +#define FM_CORE_TX_XMITING	      6
> +
> +#define FM_TUNE_COMPLETE	      0x1
> +#define FM_BAND_LIMIT		      0x2
> +
> +#define FM_DRV_TX_TIMEOUT      (5*HZ)	/* 5 seconds */
> +#define FM_DRV_RX_SEEK_TIMEOUT (20*HZ)	/* 20 seconds */
> +
> +#define NO_OF_ENTRIES_IN_ARRAY(array) (sizeof(array) / sizeof(array[0]))
> +
> +enum {
> +	FM_MODE_OFF,
> +	FM_MODE_TX,
> +	FM_MODE_RX,
> +	FM_MODE_ENTRY_MAX
> +};
> +
> +#define FM_RX_RDS_INFO_FIELD_MAX	8	/* 4 Group * 2 Bytes */
> +
> +/*
> + * define private CIDs for V4L2
> + */
> +#define V4L2_CID_CHANNEL_SPACING (V4L2_CID_PRIVATE_BASE + 0)
> +
> +/* RX RDS data format */
> +struct fm_rdsdata_format {
> +	union {
> +		struct {
> +			unsigned char rdsbuff[FM_RX_RDS_INFO_FIELD_MAX];
> +		} groupdatabuff;
> +		struct {
> +			unsigned short pidata;
> +			unsigned char block_b_byte1;
> +			unsigned char block_b_byte2;
> +			unsigned char block_c_byte1;
> +			unsigned char block_c_byte2;
> +			unsigned char block_d_byte1;
> +			unsigned char block_d_byte2;

In general I prefer to use the kernel types u8, u16 and u32. The names of
these types are 1) much shorter and 2) mean the same on any CPU.

Personally I would also remove the "_byte" part of the name. It's rather
obvious that it is a byte after all. And perhaps (this may or may not make
sense) change it to an array: u8 block_b[2];.

> +		} groupgeneral;
> +		struct {
> +			unsigned short pidata;
> +			unsigned char block_b_byte1;
> +			unsigned char block_b_byte2;
> +			unsigned char firstaf;
> +			unsigned char secondaf;
> +			unsigned char firstpsbyte;
> +			unsigned char secondpsbyte;

Again, I'd probably use af1 and af2 or af[2]. Ditto ps1/ps2 or ps[2].

> +		} group0A;
> +
> +		struct {
> +			unsigned short pidata;
> +			unsigned char block_b_byte1;
> +			unsigned char block_b_byte2;
> +			unsigned short pidata2;
> +			unsigned char firstpsbyte;
> +			unsigned char secondpsbyte;
> +		} group0B;
> +	} rdsdata;
> +};
> +
> +/* FM region (Europe/US, Japan) info */
> +struct region_info {
> +	unsigned int channel_spacing;
> +	unsigned int bottom_frequency;
> +	unsigned int top_frequency;

Personally I'd shorten this to bottom_freq and top_freq.

> +	unsigned char region_index;

Confusing name. I'd probably name it something like 'fm_band'.

> +};
> +
> +typedef void (*int_handler_prototype) (void *);

As mentioned earlier, why not replace 'void *' with 'struct fmdrv_ops *'?

> +
> +/* FM Interrupt processing related info */
> +struct fm_irq {
> +	unsigned char stage_index;

I'd rename this to just 'stage' personally.

> +	unsigned short flag;	/* FM interrupt flag */
> +	unsigned short mask;	/* FM interrupt mask */
> +	/* Interrupt process timeout handler */
> +	struct timer_list int_timeout_timer;

I'd  name this just 'timer' although 'timeout_timer' is OK as well.

> +	unsigned char irq_service_timeout_retry;

'retry' (or 'timeout_retry')

> +	int_handler_prototype *fm_int_handlers;

'handlers'

We already know that these fields are related to interrupts since they are
in the fm_irq struct. So there is no need to repeat that information in the
name. While it may look nice in this header, the problem is that long names
also appear in the code. This makes the code harder to read because you
tend to end up with dense blocks of code with long lines just to get at the
correct field.

But 'fmdev->irq_info.retry' is just as understandable as
'fmdev->irq_info.irq_service_timeout_retry' but a heck of a lot shorter.

> +};
> +
> +/* RDS info */
> +struct fm_rds {
> +	unsigned char flag;	/* RX RDS on/off status */
> +	unsigned char last_block_index;	/* Last received RDS block */
> +
> +	/* RDS buffer */
> +	wait_queue_head_t read_queue;
> +	unsigned int buf_size;	/* Size is always multiple of 3 */
> +	unsigned int wr_index;
> +	unsigned int rd_index;
> +	unsigned char *buffer;
> +};
> +
> +#define FM_RDS_MAX_AF_LIST		25
> +
> +/*
> + * Current RX channel Alternate Frequency cache.
> + * This info is used to switch to other freq (AF)
> + * when current channel signal strengh is below RSSI threshold.
> + */
> +struct tuned_station_info {
> +	unsigned short picode;
> +	unsigned int af_cache[FM_RDS_MAX_AF_LIST];
> +	unsigned char no_of_items_in_afcache;

afcache_size?

> +	unsigned char af_list_max;
> +};
> +
> +/* FM RX mode info */
> +struct fm_rx {
> +	struct region_info region;	/* Current selected band */

Shouldn't this be a const struct region_info *region?

> +	unsigned int curr_freq;	/* Current RX frquency */
> +	unsigned char curr_mute_mode;	/* Current mute mode */
> +	unsigned char curr_deemphasis_mode; /* Current deemphasis mode */
> +	/* RF dependent soft mute mode */
> +	unsigned char curr_rf_depend_mute;
> +	unsigned short curr_volume;	/* Current volume level */
> +	short curr_rssi_threshold;	/* Current RSSI threshold level */
> +	/* Holds the index of the current AF jump */
> +	unsigned char cur_afjump_index;
> +	/* Will hold the frequency before the jump */
> +	unsigned int freq_before_jump;
> +	unsigned char rds_mode;	/* RDS operation mode (RDS/RDBS) */
> +	unsigned char af_mode;	/* Alternate frequency on/off */
> +	struct tuned_station_info cur_station_info;
> +	struct fm_rds rds;

I don't see any reason for all the 'cur_' prefixes. There isn't anything but
'current' values here.

> +};
> +
> +/*
> + * FM TX RDS data
> + *
> + * @ text_type: is the text following PS or RT
> + * @ text: radio text string which could either be PS or RT
> + * @ af_freq: alternate frequency for Tx
> + * TODO: to be declared in application
> + */
> +struct tx_rds {
> +	unsigned char text_type;
> +	unsigned char text[25];
> +	unsigned char flag;
> +	unsigned int af_freq;
> +};
> +/*
> + * FM TX global data
> + *
> + * @ pwr_lvl: Power Level of the Transmission from mixer control
> + * @ xmit_state: Transmission state = Updated locally upon Start/Stop
> + * @ audio_io: i2S/Analog
> + * @ tx_frq: Transmission frequency
> + */
> +struct fmtx_data {
> +	unsigned char pwr_lvl;
> +	unsigned char xmit_state;
> +	unsigned char audio_io;
> +	unsigned char region;
> +	unsigned short aud_mode;
> +	unsigned int preemph;
> +	unsigned long tx_frq;
> +	struct tx_rds rds;
> +};
> +
> +/* FM driver operation structure */
> +struct fmdrv_ops {

_ops is normally only used for lists of function pointers (e.g. struct file_operations).

That doesn't seem to be the case here, so a better name might be struct fmdev
since it is fmdev state information.

> +	struct video_device *radio_dev;	/* V4L2 video device pointer */
> +	struct snd_card *card;	/* Card which holds FM mixer controls */
> +	unsigned short asci_id;
> +	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
> +	spinlock_t resp_skb_lock; /* To protect access to received SKB */
> +
> +	long flag;		/*  FM driver state machine info */
> +	char streg_cbdata; /* status of ST registration */
> +
> +	struct sk_buff_head rx_q;	/* RX queue */
> +	struct tasklet_struct rx_task;	/* RX Tasklet */
> +
> +	struct sk_buff_head tx_q;	/* TX queue */
> +	struct tasklet_struct tx_task;	/* TX Tasklet */
> +	unsigned long last_tx_jiffies;	/* Timestamp of last pkt sent */
> +	atomic_t tx_cnt;	/* Number of packets can send at a time */
> +
> +	struct sk_buff *response_skb;	/* Response from the chip */
> +	/* Main task completion handler */
> +	struct completion maintask_completion;
> +	/* Opcode of last command sent to the chip */
> +	unsigned char last_sent_pkt_opcode;
> +	/* Handler used for wakeup when response packet is received */
> +	struct completion *response_completion;
> +	struct fm_irq irq_info;
> +	unsigned char curr_fmmode; /* Current FM chip mode (TX, RX, OFF) */
> +	struct fm_rx rx;	/* FM receiver info */
> +	struct fmtx_data tx_data;
> +
> +	/* V4L2 ctrl framwork handler*/
> +	struct v4l2_ctrl_handler ctrl_handler;
> +
> +	/* For core assisted locking */
> +	struct mutex mutex;
> +};
> +#endif
> 

In general the length of a name depends on 1) scope and 2) frequency of use.

If a variable is defined in the local scope, close to where it is used, then
short names are preferred. If it is a lot further away, then longer names are
better.

The same for how often a variable is used: if it is used frequently, then keep
it short. If it is used rarely, then names tend to be longer.

It's a bit of an art to get it right, but I hope this helps.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
