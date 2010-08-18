Return-path: <mchehab@pedra>
Received: from web94905.mail.in2.yahoo.com ([203.104.17.152]:28111 "HELO
	web94905.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753124Ab0HRSVR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Aug 2010 14:21:17 -0400
Message-ID: <295307.18968.qm@web94905.mail.in2.yahoo.com>
Date: Wed, 18 Aug 2010 23:44:32 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM radio.
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, pavan savoy <pavan_savoy@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


--- On Wed, 7/7/10, Pavan Savoy <pavan_savoy@ti.com> wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM radio.
> To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>, "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, eduardo.valentin@nokia.com, "pavan savoy" <pavan_savoy@yahoo.co.in>
> Date: Wednesday, 7 July, 2010, 10:51 AM
> 
> --- On Tue, 6/7/10, Mauro Carvalho Chehab <mchehab@redhat.com>
> wrote:
> 
> > From: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD
> driver for the FM radio.
> > To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
> > Cc: linux-media@vger.kernel.org,
> hverkuil@xs4all.nl,
> eduardo.valentin@nokia.com
> > Date: Tuesday, 6 July, 2010, 8:04 AM
> > Em 04-06-2010 07:34, Matti J.
> > Aaltonen escreveu:
> > > This is a parent driver for two child drivers:
> the
> > V4L2 driver and
> > > the ALSA codec driver. The MFD part provides the
> I2C
> > communication
> > > to the device and a couple of functions that are
> > called from both
> > > children.
> 
> Where can I have a look at the whole code ? As in some
> local tree, where all codes are put up ?
> Basically, we have a V4L2 driver for WL128x (using TTY as
> transport) and plan to push them soon ...
> 
> This would be a nice input ...

Anywhere I can have a look at the whole code?
We are trying to push out V4L2 drivers for FM on 128x, and intend to use several V4L2 new ioctls which you have defined (_BAND_) being one of them.

Also we plan to push FM Tx of it too.. TX_CLASS from V4L2 has most of the ioctls and plan to introduce the rest.

> 
> > > Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> > > ---
> > >  drivers/mfd/Kconfig       
> >      |    6 +
> > >  drivers/mfd/Makefile       
> >     |    2 +
> > >  drivers/mfd/wl1273-core.c   
> >    |  616
> > +++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mfd/wl1273-core.h |  326
> > +++++++++++++++++++++
> > >  4 files changed, 950 insertions(+), 0
> > deletions(-)
> > >  create mode 100644 drivers/mfd/wl1273-core.c
> > >  create mode 100644
> > include/linux/mfd/wl1273-core.h
> > > 
> > > diff --git a/drivers/mfd/Kconfig
> > b/drivers/mfd/Kconfig
> > > index 413576a..5998a94 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -135,6 +135,12 @@ config TWL4030_CODEC
> > >      select MFD_CORE
> > >      default n
> > >  
> > > +config WL1273_CORE
> > > +    bool
> > > +    depends on I2C
> > > +    select MFD_CORE
> > > +    default n
> > > +
> > >  config MFD_TMIO
> > >      bool
> > >      default n
> > > diff --git a/drivers/mfd/Makefile
> > b/drivers/mfd/Makefile
> > > index 78295d6..46e611d 100644
> > > --- a/drivers/mfd/Makefile
> > > +++ b/drivers/mfd/Makefile
> > > @@ -30,6 +30,8 @@
> > obj-$(CONFIG_TWL4030_CORE)    += twl-core.o
> > twl4030-irq.o twl6030-irq.o
> > >  obj-$(CONFIG_TWL4030_POWER)    +=
> > twl4030-power.o
> > >  obj-$(CONFIG_TWL4030_CODEC)    +=
> > twl4030-codec.o
> > >  
> > > +obj-$(CONFIG_WL1273_CORE)    +=
> > wl1273-core.o
> > > +
> > >  obj-$(CONFIG_MFD_MC13783)    +=
> > mc13783-core.o
> > >  
> > >  obj-$(CONFIG_MFD_CORE)   
> >     += mfd-core.o
> > > diff --git a/drivers/mfd/wl1273-core.c
> > b/drivers/mfd/wl1273-core.c
> > > new file mode 100644
> > > index 0000000..6c7dbba
> > > --- /dev/null
> > > +++ b/drivers/mfd/wl1273-core.c
> > > @@ -0,0 +1,616 @@
> > > +/*
> > > + * MFD driver for wl1273 FM radio and audio
> codec
> > submodules.
> > > + *
> > > + * Author:    Matti Aaltonen <matti.j.aaltonen@nokia.com>
> > > + *
> > > + * Copyright:   (C) 2010 Nokia
> > Corporation
> > > + *
> > > + * This program is free software; you can
> > redistribute it and/or modify
> > > + * it under the terms of the GNU General Public
> > License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that
> it
> > will be useful, but
> > > + * WITHOUT ANY WARRANTY; without even the
> implied
> > warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR
> > PURPOSE.  See the GNU
> > > + * General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU
> General
> > Public License
> > > + * along with this program; if not, write to the
> Free
> > Software
> > > + * Foundation, Inc., 51 Franklin St, Fifth
> Floor,
> > Boston, MA
> > > + * 02110-1301 USA
> > > + *
> > > + */
> > > +
> > > +#undef DEBUG
> > > +
> > > +#include <asm/unaligned.h>
> > > +#include <linux/completion.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/module.h>
> > > +#include <linux/types.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/fs.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/mfd/core.h>
> > > +#include <linux/mfd/wl1273-core.h>
> > > +#include <media/v4l2-common.h>
> > > +
> > > +#define DRIVER_DESC "WL1273 FM Radio Core"
> > > +
> > > +#define
> > WL1273_IRQ_MASK     (WL1273_FR_EVENT   
> >     |    \
> > > +       
> >       WL1273_POW_ENB_EVENT)
> > > +
> > > +static const struct band_info bands[] = {
> > > +    /* USA & Europe */
> > > +    {
> > > +       
> > .bottom_frequency    = 87500,
> > > +       
> > .top_frequency        =
> > 108000,
> > > +       
> > .band       
> >     = V4L2_FM_BAND_OTHER,
> > > +    },
> > > +    /* Japan */
> > > +    {
> > > +       
> > .bottom_frequency    = 76000,
> > > +       
> > .top_frequency        =
> > 90000,
> > > +       
> > .band       
> >     = V4L2_FM_BAND_JAPAN,
> > > +    },
> > > +};
> > > +
> > > +/*
> > > + * static unsigned char radio_band - Band
> > > + *
> > > + * The bands are 0=Japan, 1=USA-Europe.
> USA-Europe is
> > the default.
> > > + */
> > > +static unsigned char radio_band = 1;
> > > +module_param(radio_band, byte, 0);
> > > +MODULE_PARM_DESC(radio_band, "Band: 0=Japan,
> > 1=USA-Europe*");
> > > +
> > > +/*
> > > + * static unsigned int rds_buf - the number of
> RDS
> > buffer blocks used.
> > > + *
> > > + * The default number is 100.
> > > + */
> > > +static unsigned int rds_buf = 100;
> > > +module_param(rds_buf, uint, 0);
> > > +MODULE_PARM_DESC(rds_buf, "RDS buffer entries:
> > *100*");
> > > +
> > > +int wl1273_fm_read_reg(struct wl1273_core *core,
> u8
> > reg, u16 *value)
> > > +{
> > > +    struct i2c_client *client =
> > core->i2c_dev;
> > > +    u8 b[2];
> > > +    int r;
> > > +
> > > +    r =
> > i2c_smbus_read_i2c_block_data(client, reg, 2, b);
> > > +    if (r != 2) {
> > > +       
> > dev_err(&client->dev, "%s: Read: %d fails.\n",
> > __func__, reg);
> > > +        return
> > -EREMOTEIO;
> > > +    }
> > > +
> > > +    *value = (u16)b[0] << 8 |
> > b[1];
> > > +
> > > +    return 0;
> > > +}
> > > +EXPORT_SYMBOL(wl1273_fm_read_reg);
> > > +
> > > +int wl1273_fm_write_cmd(struct wl1273_core
> *core, u8
> > cmd, u16 param)
> > > +{
> > > +    struct i2c_client *client =
> > core->i2c_dev;
> > > +    u8 buf[] = { (param >> 8)
> > & 0xff, param & 0xff };
> > > +    int r;
> > > +
> > > +    r =
> > i2c_smbus_write_i2c_block_data(client, cmd, 2, buf);
> > > +    if (r) {
> > > +       
> > dev_err(&client->dev, "%s: Cmd: %d fails.\n",
> > __func__, cmd);
> > > +        return r;
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> > > +EXPORT_SYMBOL(wl1273_fm_write_cmd);
> > > +
> > > +int wl1273_fm_write_data(struct wl1273_core
> *core, u8
> > *data, u16 len)
> > > +{
> > > +    struct i2c_client *client =
> > core->i2c_dev;
> > > +    struct i2c_msg msg[1];
> > > +    int r;
> > > +
> > > +    msg[0].addr = client->addr;
> > > +    msg[0].flags = 0;
> > > +    msg[0].buf = data;
> > > +    msg[0].len = len;
> > > +
> > > +    r =
> > i2c_transfer(client->adapter, msg, 1);
> > > +
> > > +    if (r != 1) {
> > > +       
> > dev_err(&client->dev, "%s: write error.\n",
> > __func__);
> > > +        return
> > -EREMOTEIO;
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> > > +EXPORT_SYMBOL(wl1273_fm_write_data);
> > > +
> > > +/**
> > > + * wl1273_fm_set_audio() -    Set
> > audio mode.
> > > + * @core:       
> >     A pointer to the device struct.
> > > + * @new_mode:       
> >     The new audio mode.
> > > + *
> > > + * Audio modes are WL1273_AUDIO_DIGITAL and
> > WL1273_AUDIO_ANALOG.
> > > + */
> > > +int wl1273_fm_set_audio(struct wl1273_core
> *core,
> > unsigned int new_mode)
> > > +{
> > > +    int r = 0;
> > > +
> > > +    if (core->mode ==
> > WL1273_MODE_OFF ||
> > > +        core->mode ==
> > WL1273_MODE_SUSPENDED)
> > > +        return -EPERM;
> > > +
> > > +    if (core->mode ==
> > WL1273_MODE_RX && new_mode ==
> WL1273_AUDIO_DIGITAL)
> > {
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_PCM_MODE_SET,
> > > +       
> >            
> > WL1273_PCM_DEF_MODE);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
> > > +       
> >            
> > core->i2s_mode);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
> > > +       
> >            
> > WL1273_AUDIO_ENABLE_I2S);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +    } else if (core->mode ==
> > WL1273_MODE_RX &&
> > > +       
> >    new_mode == WL1273_AUDIO_ANALOG) {
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
> > > +       
> >            
> > WL1273_AUDIO_ENABLE_ANALOG);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +    } else if (core->mode ==
> > WL1273_MODE_TX &&
> > > +       
> >    new_mode == WL1273_AUDIO_DIGITAL) {
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
> > > +       
> >            
> > core->i2s_mode);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
> > > +       
> >            
> > WL1273_AUDIO_IO_SET_I2S);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +    } else if (core->mode ==
> > WL1273_MODE_TX &&
> > > +       
> >    new_mode == WL1273_AUDIO_ANALOG) {
> > > +        r =
> > wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
> > > +       
> >            
> > WL1273_AUDIO_IO_SET_ANALOG);
> > > +        if (r)
> > > +       
> >     goto out;
> > > +    }
> > > +
> > > +    core->audio_mode = new_mode;
> > > +
> > > +out:
> > > +    return r;
> > > +}
> > > +EXPORT_SYMBOL(wl1273_fm_set_audio);
> > > +
> > > +/**
> > > + * wl1273_fm_set_volume() -    Set
> > volume.
> > > + * @core:       
> >     A pointer to the device struct.
> > > + * @volume:       
> >     The new volume value.
> > > + */
> > > +int wl1273_fm_set_volume(struct wl1273_core
> *core,
> > unsigned int volume)
> > > +{
> > > +    u16 val;
> > > +    int r;
> > > +
> > > +    if (volume >
> > WL1273_MAX_VOLUME)
> > > +        return
> > -EINVAL;
> > > +
> > > +    if (core->volume == volume)
> > > +        return 0;
> > > +
> > > +    val = volume;
> > > +    r = wl1273_fm_read_reg(core,
> > WL1273_VOLUME_SET, &val);
> > > +    if (r)
> > > +        return r;
> > > +
> > > +    core->volume = volume;
> > > +    return 0;
> > > +}
> > > +EXPORT_SYMBOL(wl1273_fm_set_volume);
> > > +
> > > +#define
> > WL1273_RDS_FIFO_EMPTY(status)    (!(1
> > << 6 &  status))
> > > +
> > > +#define
> > WL1273_RDS_CORRECTABLE_ERROR    (1 <<
> > 3)
> > > +#define
> > WL1273_RDS_UNCORRECTABLE_ERROR    (1 <<
> > 4)
> > > +
> > > +static int wl1273_fm_rds(struct wl1273_core
> *core)
> > > +{
> > > +    struct i2c_client *client =
> > core->i2c_dev;
> > > +    struct device *dev =
> > &client->dev;
> > > +    struct v4l2_rds_data rds = { 0, 0,
> > 0 };
> > > +    struct i2c_msg msg[] = {
> > > +        {
> > > +       
> >     .addr = client->addr,
> > > +       
> >     .flags = 0,
> > > +       
> >     .buf = b0,
> > > +       
> >     .len = 1
> > > +        },
> > > +        {
> > > +       
> >     .addr = client->addr,
> > > +       
> >     .flags = I2C_M_RD,
> > > +       
> >     .buf = (u8 *) &rds,
> > > +       
> >     .len = 3
> > > +        }
> > > +    };
> > > +    u8 b0[] = { WL1273_RDS_DATA_GET },
> > status;
> > > +    u16 val;
> > > +    int r;
> > > +
> > > +    r = wl1273_fm_read_reg(core,
> > WL1273_RDS_SYNC_GET, &val);
> > > +    if (r)
> > > +        return r;
> > > +
> > > +    /* Is RDS decoder synchronized?
> > */
> > > +    if ((val & 0x01) == 0)
> > > +        return
> > -EAGAIN;
> > > +
> > > +    /* copy all four RDS blocks to
> > internal buffer */
> > > +    do {
> > > +        r =
> > i2c_transfer(client->adapter, msg, 2);
> > > +        if (r != 2) {
> > > +       
> >     dev_err(dev, WL1273_FM_DRIVER_NAME
> > > +       
> >         ": %s: read_rds error
> > r == %i)\n",
> > > +       
> >         __func__, r);
> > > +        }
> > > +
> > > +        status =
> > rds.block;
> > > +
> > > +        if
> > (WL1273_RDS_FIFO_EMPTY(status))
> > > +       
> >     break;
> > > +
> > > +        /* copy RDS
> > block to internal buffer */
> > > +       
> > memcpy(&core->buffer[core->wr_index],
> &rds,
> > 3);
> > > +       
> > core->wr_index += 3;
> > > +
> > > +        /* copy the
> > error bits to standard positions */
> > > +        if
> > (WL1273_RDS_UNCORRECTABLE_ERROR & status) {
> > > +       
> >     rds.block |= V4L2_RDS_BLOCK_ERROR;
> > > +       
> >     rds.block &=
> > ~V4L2_RDS_BLOCK_CORRECTED;
> > > +        } else if 
> > (WL1273_RDS_CORRECTABLE_ERROR & status) {
> > > +       
> >     rds.block &= ~V4L2_RDS_BLOCK_ERROR;
> > > +       
> >     rds.block |= V4L2_RDS_BLOCK_CORRECTED;
> > > +        } else {
> > > +       
> >     rds.block &= ~V4L2_RDS_BLOCK_ERROR;
> > > +       
> >     rds.block &=
> > ~V4L2_RDS_BLOCK_CORRECTED;
> > > +        }
> > > +
> > > +        /* wrap write
> > pointer */
> > > +        if
> > (core->wr_index >= core->buf_size)
> > > +       
> >     core->wr_index = 0;
> > > +
> > > +        /* check for
> > overflow & start over */
> > > +        if
> > (core->wr_index == core->rd_index) {
> > > +       
> >     dev_dbg(dev, "RDS OVERFLOW");
> > > +
> > > +       
> >     core->rd_index = 0;
> > > +       
> >     core->wr_index = 0;
> > > +       
> >     break;
> > > +        }
> > > +    } while
> > (!WL1273_RDS_FIFO_EMPTY(status));
> > > +
> > > +    /* wake up read queue */
> > > +    if (core->wr_index !=
> > core->rd_index)
> > > +       
> > wake_up_interruptible(&core->read_queue);
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +static void wl1273_fm_rds_work(struct
> wl1273_core
> > *core)
> > > +{
> > > +    wl1273_fm_rds(core);
> > > +}
> > > +
> > > +static irqreturn_t
> wl1273_fm_irq_thread_handler(int
> > irq, void *dev_id)
> > > +{
> > > +    int r;
> > > +    u16 flags;
> > > +    struct wl1273_core *core =
> > dev_id;
> > > +
> > > +    r = wl1273_fm_read_reg(core,
> > WL1273_FLAG_GET, &flags);
> > > +    if (r)
> > > +        goto out;
> > > +
> > > +    if (flags & WL1273_BL_EVENT)
> > {
> > > +       
> > core->irq_received = flags;
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ: BL\n");
> > > +    }
> > > +
> > > +    if (flags & WL1273_RDS_EVENT)
> > {
> > > +        msleep(200);
> > > +
> > > +       
> > wl1273_fm_rds_work(core);
> > > +    }
> > > +
> > > +    if (flags &
> > WL1273_BBLK_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> BBLK\n");
> > > +
> > > +    if (flags &
> > WL1273_LSYNC_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> LSYNC\n");
> > > +
> > > +    if (flags & WL1273_LEV_EVENT)
> > {
> > > +        u16 level;
> > > +
> > > +        r =
> > wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET,
> &level);
> > > +
> > > +        if (r)
> > > +       
> >     goto out;
> > > +
> > > +        if (level >
> > 14)
> > > +       
> >     dev_dbg(&core->i2c_dev->dev,
> > "IRQ: LEV: 0x%x04\n",
> > > +       
> >         level);
> > > +    }
> > > +
> > > +    if (flags &
> > WL1273_IFFR_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> IFFR\n");
> > > +
> > > +    if (flags & WL1273_PI_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ: PI\n");
> > > +
> > > +    if (flags & WL1273_PD_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ: PD\n");
> > > +
> > > +    if (flags &
> > WL1273_STIC_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> STIC\n");
> > > +
> > > +    if (flags & WL1273_MAL_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ: MAL\n");
> > > +
> > > +    if (flags &
> > WL1273_POW_ENB_EVENT) {
> > > +       
> > complete(&core->busy);
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "NOT BUSY\n");
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> POW_ENB\n");
> > > +    }
> > > +
> > > +    if (flags &
> > WL1273_SCAN_OVER_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> SCAN_OVER\n");
> > > +
> > > +    if (flags &
> > WL1273_ERROR_EVENT)
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ:
> ERROR\n");
> > > +
> > > +    if (flags & WL1273_FR_EVENT)
> > {
> > > +        u16 freq;
> > > +
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "IRQ: FR:\n");
> > > +
> > > +        if
> > (core->mode == WL1273_MODE_RX) {
> > > +       
> >     r = wl1273_fm_write_cmd(core,
> > WL1273_TUNER_MODE_SET,
> > > +       
> >            
> >     TUNER_MODE_STOP_SEARCH);
> > > +       
> >     if (r) {
> > > +       
> >        
> > dev_err(&core->i2c_dev->dev,
> > > +       
> >            
> > "%s: TUNER_MODE_SET fails: %d\n",
> > > +       
> >            
> > __func__, r);
> > > +       
> >         goto out;
> > > +       
> >     }
> > > +
> > > +       
> >     r = wl1273_fm_read_reg(core,
> > WL1273_FREQ_SET, &freq);
> > > +       
> >     if (r)
> > > +       
> >         goto out;
> > > +
> > > +       
> >     core->rx_frequency =
> > > +       
> >        
> > bands[core->band].bottom_frequency +
> > > +       
> >         freq * 50;
> > > +
> > > +       
> >     /*
> > > +       
> >      *  The driver works
> > better with this msleep,
> > > +       
> >      *  the documentation
> > doesn't mention it.
> > > +       
> >      */
> > > +       
> >     msleep(10);
> > 
> > 
> > msleep on an irq handler? You shouldn't be doing it!
> You're
> > not allowed to sleep
> > during IRQ time. Kernel can panic here. You'll
> probably
> > need to defer work and
> > handle it outside irq time.
> > > +
> > > +       
> >     dev_dbg(&core->i2c_dev->dev,
> > "%dkHz\n",
> > > +       
> >        
> > core->rx_frequency);
> > > +
> > > +        } else {
> > > +       
> >     r = wl1273_fm_read_reg(core,
> > WL1273_CHANL_SET, &freq);
> > > +       
> >     if (r)
> > > +       
> >         goto out;
> > > +
> > > +       
> >     dev_dbg(&core->i2c_dev->dev,
> > "%dkHz\n", freq);
> > > +        }
> > > +       
> > dev_dbg(&core->i2c_dev->dev, "%s: NOT
> BUSY\n",
> > __func__);
> > > +    }
> > > +
> > > +out:
> > > +    wl1273_fm_write_cmd(core,
> > WL1273_INT_MASK_SET,
> > > +       
> >         core->irq_flags);
> > > +    complete(&core->busy);
> > > +
> > > +    return IRQ_HANDLED;
> > > +}
> > > +
> > > +static struct i2c_device_id
> wl1273_driver_id_table[]
> > = {
> > > +    { WL1273_FM_DRIVER_NAME, 0 },
> > > +    { }
> > > +};
> > > +MODULE_DEVICE_TABLE(i2c,
> wl1273_driver_id_table);
> > > +
> > > +static int wl1273_core_remove(struct i2c_client
> > *client)
> > > +{
> > > +    struct wl1273_core *core =
> > i2c_get_clientdata(client);
> > > +    struct wl1273_fm_platform_data
> > *pdata =
> > > +       
> > client->dev.platform_data;
> > > +
> > > +    dev_dbg(&client->dev,
> > "%s\n", __func__);
> > > +
> > > +   
> > mfd_remove_devices(&client->dev);
> > > +    i2c_set_clientdata(client, core);
> > > +
> > > +    free_irq(client->irq, core);
> > > +    pdata->free_resources();
> > > +
> > > +    kfree(core->buffer);
> > > +    kfree(core);
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +static int __devinit wl1273_core_probe(struct
> > i2c_client *client,
> > > +       
> >            
> >    const struct i2c_device_id *id)
> > > +{
> > > +    struct wl1273_fm_platform_data
> > *pdata = client->dev.platform_data;
> > > +    int r = 0;
> > > +    struct wl1273_core *core;
> > > +    int children = 0;
> > > +
> > > +    dev_dbg(&client->dev,
> > "%s\n", __func__);
> > > +
> > > +    if (!pdata) {
> > > +       
> > dev_err(&client->dev, "No platform data.\n");
> > > +        return
> > -EINVAL;
> > > +    }
> > > +
> > > +    core = kzalloc(sizeof(*core),
> > GFP_KERNEL);
> > > +    if (!core)
> > > +        return
> > -ENOMEM;
> > > +
> > > +    /* RDS buffer allocation */
> > > +    core->buf_size = rds_buf * 3;
> > > +    core->buffer =
> > kmalloc(core->buf_size, GFP_KERNEL);
> > > +    if (!core->buffer) {
> > > +       
> > dev_err(&client->dev,
> > > +       
> >     "Cannot allocate memory for RDS
> > buffer.\n");
> > > +        r = -ENOMEM;
> > > +        goto
> > err_kmalloc;
> > > +    }
> > > +
> > > +    core->irq_flags =
> > WL1273_IRQ_MASK;
> > > +    core->i2c_dev = client;
> > > +    core->rds_on = false;
> > > +    core->mode = WL1273_MODE_OFF;
> > > +    core->tx_power = 4;
> > > +    core->audio_mode =
> > WL1273_AUDIO_ANALOG;
> > > +    core->band = radio_band;
> > > +    core->bands = bands;
> > > +    core->number_of_bands =
> > ARRAY_SIZE(bands);
> > > +    core->i2s_mode =
> > WL1273_I2S_DEF_MODE;
> > > +    core->channel_number = 2;
> > > +    core->volume =
> > WL1273_DEFAULT_VOLUME;
> > > +    core->rx_frequency =
> > bands[core->band].bottom_frequency;
> > > +    core->tx_frequency =
> > bands[core->band].top_frequency;
> > > +
> > > +    dev_dbg(&client->dev,
> > "radio_band: %d\n", radio_band);
> > > +
> > > +    mutex_init(&core->lock);
> > > +
> > > +    pdata =
> > client->dev.platform_data;
> > > +    if (pdata) {
> > > +        r =
> > pdata->request_resources(client);
> > > +        if (r) {
> > > +       
> >     dev_err(&client->dev,
> > WL1273_FM_DRIVER_NAME
> > > +       
> >         ": Cannot get platform
> > data\n");
> > > +       
> >     goto err_new_mixer;
> > > +        }
> > > +
> > > +        r =
> > request_threaded_irq(client->irq, NULL,
> > > +       
> >        
> >      wl1273_fm_irq_thread_handler,
> > > +       
> >        
> >      IRQF_ONESHOT |
> > IRQF_TRIGGER_FALLING,
> > > +       
> >        
> >      "wl1273-fm", core);
> > > +        if (r < 0)
> > {
> > > +       
> >     dev_err(&client->dev,
> > WL1273_FM_DRIVER_NAME
> > > +       
> >         ": Unable to register
> > IRQ handler\n");
> > > +       
> >     goto err_request_irq;
> > > +        }
> > > +    } else {
> > > +       
> > dev_err(&client->dev, WL1273_FM_DRIVER_NAME ":
> Core
> > WL1273 IRQ"
> > > +       
> >     " not configured");
> > > +        r = -EINVAL;
> > > +        goto
> > err_new_mixer;
> > > +    }
> > > +
> > > +   
> > init_completion(&core->busy);
> > > +   
> > init_waitqueue_head(&core->read_queue);
> > > +
> > > +    i2c_set_clientdata(client, core);
> > > +
> > > +    if (pdata->children &
> > WL1273_RADIO_CHILD) {
> > > +        struct mfd_cell
> > *cell = &core->cells[children];
> > > +       
> > dev_dbg(&client->dev, "%s: Have V4L2.\n",
> __func__);
> > > +        cell->name =
> > "wl1273_fm_radio";
> > > +       
> > cell->platform_data = &core;
> > > +       
> > cell->data_size = sizeof(core);
> > > +        children++;
> > > +    }
> > > +
> > > +    if (pdata->children &
> > WL1273_CODEC_CHILD) {
> > > +        struct mfd_cell
> > *cell = &core->cells[children];
> > > +       
> > dev_dbg(&client->dev, "%s: Have codec.\n",
> > __func__);
> > > +        cell->name =
> > "wl1273_codec_audio";
> > > +       
> > cell->platform_data = &core;
> > > +       
> > cell->data_size = sizeof(core);
> > > +        children++;
> > > +    }
> > > +
> > > +    if (children) {
> > > +       
> > dev_dbg(&client->dev, "%s: Have children.\n",
> > __func__);
> > > +        r =
> > mfd_add_devices(&client->dev, -1,
> core->cells,
> > > +       
> >            
> > children, NULL, 0);
> > > +    } else {
> > > +       
> > dev_err(&client->dev, "No platform data found
> for
> > children.\n");
> > > +        r = -ENODEV;
> > > +    }
> > > +
> > > +    if (!r)
> > > +        return 0;
> > > +
> > > +    i2c_set_clientdata(client, NULL);
> > > +    kfree(core);
> > > +    free_irq(client->irq, core);
> > > +err_request_irq:
> > > +    pdata->free_resources();
> > > +err_new_mixer:
> > > +    kfree(core->buffer);
> > > +err_kmalloc:
> > > +    kfree(core);
> > > +    dev_dbg(&client->dev,
> > "%s\n", __func__);
> > > +
> > > +    return r;
> > > +}
> > > +
> > > +static struct i2c_driver wl1273_core_driver = {
> > > +    .driver = {
> > > +        .name =
> > WL1273_FM_DRIVER_NAME,
> > > +    },
> > > +    .probe = wl1273_core_probe,
> > > +    .id_table =
> > wl1273_driver_id_table,
> > > +    .remove =
> > __devexit_p(wl1273_core_remove),
> > > +};
> > > +
> > > +static int __init wl1273_core_init(void)
> > > +{
> > > +    int r;
> > > +
> > > +    r =
> > i2c_add_driver(&wl1273_core_driver);
> > > +    if (r) {
> > > +       
> > pr_err(WL1273_FM_DRIVER_NAME
> > > +           
> >    ": driver registration failed\n");
> > > +        return r;
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +static void __exit wl1273_core_exit(void)
> > > +{
> > > +    flush_scheduled_work();
> > > +
> > > +   
> > i2c_del_driver(&wl1273_core_driver);
> > > +}
> > > +late_initcall(wl1273_core_init);
> > > +module_exit(wl1273_core_exit);
> > > +
> > > +MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
> > > +MODULE_DESCRIPTION(DRIVER_DESC);
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/include/linux/mfd/wl1273-core.h
> > b/include/linux/mfd/wl1273-core.h
> > > new file mode 100644
> > > index 0000000..81c9743
> > > --- /dev/null
> > > +++ b/include/linux/mfd/wl1273-core.h
> > > @@ -0,0 +1,326 @@
> > > +/*
> > > + * include/media/radio/radio-wl1273.h
> > > + *
> > > + * Some definitions for the wl1273 radio
> > receiver/transmitter chip.
> > > + *
> > > + * Copyright (C) Nokia Corporation
> > > + * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> > > + *
> > > + * This program is free software; you can
> > redistribute it and/or
> > > + * modify it under the terms of the GNU General
> > Public License
> > > + * version 2 as published by the Free Software
> > Foundation.
> > > + *
> > > + * This program is distributed in the hope that
> it
> > will be useful, but
> > > + * WITHOUT ANY WARRANTY; without even the
> implied
> > warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR
> > PURPOSE.  See the GNU
> > > + * General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU
> General
> > Public License
> > > + * along with this program; if not, write to the
> Free
> > Software
> > > + * Foundation, Inc., 51 Franklin St, Fifth
> Floor,
> > Boston, MA
> > > + * 02110-1301 USA
> > > + */
> > > +
> > > +#ifndef RADIO_WL1273_H
> > > +#define RADIO_WL1273_H
> > > +
> > > +#include <linux/i2c.h>
> > > +#include <linux/mfd/core.h>
> > > +
> > > +#define WL1273_FM_DRIVER_NAME   
> > "wl1273-fm"
> > > +#define RX71_FM_I2C_ADDR    0x22
> > > +
> > > +#define WL1273_STEREO_GET   
> >     0
> > > +#define WL1273_RSSI_LVL_GET   
> >     1
> > > +#define WL1273_IF_COUNT_GET   
> >     2
> > > +#define WL1273_FLAG_GET   
> >         3
> > > +#define WL1273_RDS_SYNC_GET   
> >     4
> > > +#define WL1273_RDS_DATA_GET   
> >     5
> > > +#define WL1273_FREQ_SET   
> >         10
> > > +#define WL1273_AF_FREQ_SET   
> >     11
> > > +#define WL1273_MOST_MODE_SET   
> >     12
> > > +#define WL1273_MOST_BLEND_SET   
> >     13
> > > +#define WL1273_DEMPH_MODE_SET   
> >     14
> > > +#define WL1273_SEARCH_LVL_SET   
> >     15
> > > +#define WL1273_BAND_SET   
> >         16
> > > +#define WL1273_MUTE_STATUS_SET   
> >     17
> > > +#define WL1273_RDS_PAUSE_LVL_SET   
> > 18
> > > +#define WL1273_RDS_PAUSE_DUR_SET   
> > 19
> > > +#define WL1273_RDS_MEM_SET   
> >     20
> > > +#define WL1273_RDS_BLK_B_SET   
> >     21
> > > +#define WL1273_RDS_MSK_B_SET   
> >     22
> > > +#define WL1273_RDS_PI_MASK_SET   
> >     23
> > > +#define WL1273_RDS_PI_SET   
> >     24
> > > +#define WL1273_RDS_SYSTEM_SET   
> >     25
> > > +#define WL1273_INT_MASK_SET   
> >     26
> > > +#define WL1273_SEARCH_DIR_SET   
> >     27
> > > +#define WL1273_VOLUME_SET   
> >     28
> > > +#define WL1273_AUDIO_ENABLE   
> >     29
> > > +#define WL1273_PCM_MODE_SET   
> >     30
> > > +#define WL1273_I2S_MODE_CONFIG_SET   
> > 31
> > > +#define WL1273_POWER_SET   
> >     32
> > > +#define WL1273_INTX_CONFIG_SET   
> >     33
> > > +#define WL1273_PULL_EN_SET   
> >     34
> > > +#define WL1273_HILO_SET   
> >         35
> > > +#define WL1273_SWITCH2FREF   
> >     36
> > > +#define WL1273_FREQ_DRIFT_REPORT   
> > 37
> > > +
> > > +#define WL1273_PCE_GET   
> >         40
> > > +#define WL1273_FIRM_VER_GET   
> >     41
> > > +#define WL1273_ASIC_VER_GET   
> >     42
> > > +#define WL1273_ASIC_ID_GET   
> >     43
> > > +#define WL1273_MAN_ID_GET   
> >     44
> > > +#define WL1273_TUNER_MODE_SET   
> >     45
> > > +#define WL1273_STOP_SEARCH   
> >     46
> > > +#define WL1273_RDS_CNTRL_SET   
> >     47
> > > +
> > > +#define WL1273_WRITE_HARDWARE_REG   
> > 100
> > > +#define WL1273_CODE_DOWNLOAD   
> >     101
> > > +#define WL1273_RESET   
> >         102
> > > +
> > > +#define WL1273_FM_POWER_MODE   
> >     254
> > > +#define WL1273_FM_INTERRUPT   
> >     255
> > > +
> > > +/* Transmitter API */
> > > +
> > > +#define WL1273_CHANL_SET   
> >     55
> > > +#define WL1273_SCAN_SPACING_SET   
> >     56
> > > +#define WL1273_REF_SET   
> >         57
> > > +#define WL1273_POWER_ENB_SET   
> >     90
> > > +#define WL1273_POWER_ATT_SET   
> >     58
> > > +#define WL1273_POWER_LEV_SET   
> >     59
> > > +#define WL1273_AUDIO_DEV_SET   
> >     60
> > > +#define WL1273_PILOT_DEV_SET   
> >     61
> > > +#define WL1273_RDS_DEV_SET   
> >     62
> > > +#define WL1273_PUPD_SET   
> >         91
> > > +#define WL1273_AUDIO_IO_SET   
> >     63
> > > +#define WL1273_PREMPH_SET   
> >     64
> > > +#define WL1273_MONO_SET   
> >         66
> > > +#define WL1273_MUTE   
> >         92
> > > +#define WL1273_MPX_LMT_ENABLE   
> >     67
> > > +#define WL1273_PI_SET   
> >         93
> > > +#define WL1273_ECC_SET   
> >         69
> > > +#define WL1273_PTY   
> >         70
> > > +#define WL1273_AF   
> >         71
> > > +#define WL1273_DISPLAY_MODE   
> >     74
> > > +#define WL1273_RDS_REP_SET   
> >     77
> > > +#define WL1273_RDS_CONFIG_DATA_SET   
> > 98
> > > +#define WL1273_RDS_DATA_SET   
> >     99
> > > +#define WL1273_RDS_DATA_ENB   
> >     94
> > > +#define WL1273_TA_SET   
> >         78
> > > +#define WL1273_TP_SET   
> >         79
> > > +#define WL1273_DI_SET   
> >         80
> > > +#define WL1273_MS_SET   
> >         81
> > > +#define WL1273_PS_SCROLL_SPEED   
> >     82
> > > +#define WL1273_TX_AUDIO_LEVEL_TEST   
> > 96
> > > +#define
> > WL1273_TX_AUDIO_LEVEL_TEST_THRESHOLD    73
> > > +#define
> > WL1273_TX_AUDIO_INPUT_LEVEL_RANGE_SET    54
> > > +#define WL1273_RX_ANTENNA_SELECT   
> > 87
> > > +#define WL1273_I2C_DEV_ADDR_SET   
> >     86
> > > +#define
> > WL1273_REF_ERR_CALIB_PARAM_SET   
> >     88
> > > +#define
> > WL1273_REF_ERR_CALIB_PERIODICITY_SET    89
> > > +#define WL1273_SOC_INT_TRIGGER   
> >         52
> > > +#define WL1273_SOC_AUDIO_PATH_SET   
> >     83
> > > +#define WL1273_SOC_PCMI_OVERRIDE   
> >     84
> > > +#define WL1273_SOC_I2S_OVERRIDE   
> >     85
> > > +#define
> > WL1273_RSSI_BLOCK_SCAN_FREQ_SET    95
> > > +#define
> > WL1273_RSSI_BLOCK_SCAN_START    97
> > > +#define
> > WL1273_RSSI_BLOCK_SCAN_DATA_GET     5
> > > +#define
> > WL1273_READ_FMANT_TUNE_VALUE   
> >     104
> > > +
> > > +#define WL1273_RDS_OFF   
> >     0
> > > +#define WL1273_RDS_ON   
> >     1
> > > +#define WL1273_RDS_RESET    2
> > > +
> > > +#define WL1273_AUDIO_DIGITAL    0
> > > +#define WL1273_AUDIO_ANALOG    1
> > > +
> > > +#define WL1273_MODE_RX   
> >     0
> > > +#define WL1273_MODE_TX   
> >     1
> > > +#define WL1273_MODE_OFF   
> >     2
> > > +#define WL1273_MODE_SUSPENDED    3
> > > +
> > > +#define WL1273_RADIO_CHILD    (1
> > << 0)
> > > +#define WL1273_CODEC_CHILD    (1
> > << 1)
> > > +
> > > +#define WL1273_RX_MONO   
> >     1
> > > +#define WL1273_RX_STEREO    0
> > > +#define WL1273_TX_MONO   
> >     0
> > > +#define WL1273_TX_STEREO    1
> > > +
> > > +#define WL1273_MAX_VOLUME    0xffff
> > > +#define WL1273_DEFAULT_VOLUME   
> > 0x78b8
> > > +
> > > +/* I2S protocol, left channel first, data width
> 16
> > bits */
> > > +#define WL1273_PCM_DEF_MODE   
> >     0x00
> > > +
> > > +/* Rx */
> > > +#define WL1273_AUDIO_ENABLE_I2S   
> >     (1 << 0)
> > > +#define WL1273_AUDIO_ENABLE_ANALOG   
> > (1 << 1)
> > > +
> > > +/* Tx */
> > > +#define WL1273_AUDIO_IO_SET_ANALOG   
> > 0
> > > +#define WL1273_AUDIO_IO_SET_I2S   
> >     1
> > > +
> > > +#define WL1273_POWER_SET_OFF   
> >     0
> > > +#define WL1273_POWER_SET_FM   
> >     (1 << 0)
> > > +#define WL1273_POWER_SET_RDS   
> >     (1 << 1)
> > > +#define WL1273_POWER_SET_RETENTION   
> > (1 << 4)
> > > +
> > > +#define WL1273_PUPD_SET_OFF   
> >     0x00
> > > +#define WL1273_PUPD_SET_ON   
> >     0x01
> > > +#define WL1273_PUPD_SET_RETENTION   
> > 0x10
> > > +
> > > +/* I2S mode */
> > > +#define WL1273_IS2_WIDTH_32    0x0
> > > +#define WL1273_IS2_WIDTH_40    0x1
> > > +#define WL1273_IS2_WIDTH_22_23    0x2
> > > +#define WL1273_IS2_WIDTH_23_22    0x3
> > > +#define WL1273_IS2_WIDTH_48    0x4
> > > +#define WL1273_IS2_WIDTH_50    0x5
> > > +#define WL1273_IS2_WIDTH_60    0x6
> > > +#define WL1273_IS2_WIDTH_64    0x7
> > > +#define WL1273_IS2_WIDTH_80    0x8
> > > +#define WL1273_IS2_WIDTH_96    0x9
> > > +#define WL1273_IS2_WIDTH_128    0xa
> > > +#define WL1273_IS2_WIDTH    0xf
> > > +
> > > +#define WL1273_IS2_FORMAT_STD    (0x0
> > << 4)
> > > +#define WL1273_IS2_FORMAT_LEFT    (0x1
> > << 4)
> > > +#define WL1273_IS2_FORMAT_RIGHT   
> > (0x2 << 4)
> > > +#define WL1273_IS2_FORMAT_USER    (0x3
> > << 4)
> > > +
> > > +#define WL1273_IS2_MASTER    (0x0
> > << 6)
> > > +#define WL1273_IS2_SLAVEW    (0x1
> > << 6)
> > > +
> > > +#define
> > WL1273_IS2_TRI_AFTER_SENDING    (0x0 <<
> > 7)
> > > +#define
> > WL1273_IS2_TRI_ALWAYS_ACTIVE    (0x1 <<
> > 7)
> > > +
> > > +#define WL1273_IS2_SDOWS_RR    (0x0
> > << 8)
> > > +#define WL1273_IS2_SDOWS_RF    (0x1
> > << 8)
> > > +#define WL1273_IS2_SDOWS_FR    (0x2
> > << 8)
> > > +#define WL1273_IS2_SDOWS_FF    (0x3
> > << 8)
> > > +
> > > +#define WL1273_IS2_TRI_OPT    (0x0
> > << 10)
> > > +#define WL1273_IS2_TRI_ALWAYS    (0x1
> > << 10)
> > > +
> > > +#define WL1273_IS2_RATE_48K    (0x0
> > << 12)
> > > +#define WL1273_IS2_RATE_44_1K    (0x1
> > << 12)
> > > +#define WL1273_IS2_RATE_32K    (0x2
> > << 12)
> > > +#define WL1273_IS2_RATE_22_05K    (0x4
> > << 12)
> > > +#define WL1273_IS2_RATE_16K    (0x5
> > << 12)
> > > +#define WL1273_IS2_RATE_12K    (0x8
> > << 12)
> > > +#define WL1273_IS2_RATE_11_025    (0x9
> > << 12)
> > > +#define WL1273_IS2_RATE_8K    (0xa
> > << 12)
> > > +#define WL1273_IS2_RATE   
> >     (0xf << 12)
> > > +
> > > +#define WL1273_I2S_DEF_MODE   
> > (WL1273_IS2_WIDTH_32 | \
> > > +       
> >    
> >      WL1273_IS2_FORMAT_STD | \
> > > +       
> >    
> >      WL1273_IS2_MASTER | \
> > > +       
> >    
> >      WL1273_IS2_TRI_AFTER_SENDING |
> > \
> > > +       
> >    
> >      WL1273_IS2_SDOWS_RR | \
> > > +       
> >    
> >      WL1273_IS2_TRI_OPT | \
> > > +       
> >    
> >      WL1273_IS2_RATE_48K)
> > > +
> > > +/* Private IOCTL */
> > > +#define WL1273_CID_FM_BAND   
> > (V4L2_CID_PRIVATE_BASE + 2)
> > > +
> > > +#define SCHAR_MIN (-128)
> > > +#define SCHAR_MAX 127
> > > +
> > > +#define WL1273_FR_EVENT   
> >         (1 << 0)
> > > +#define WL1273_BL_EVENT   
> >         (1 << 1)
> > > +#define WL1273_RDS_EVENT   
> >     (1 << 2)
> > > +#define WL1273_BBLK_EVENT   
> >     (1 << 3)
> > > +#define WL1273_LSYNC_EVENT   
> >     (1 << 4)
> > > +#define WL1273_LEV_EVENT   
> >     (1 << 5)
> > > +#define WL1273_IFFR_EVENT   
> >     (1 << 6)
> > > +#define WL1273_PI_EVENT   
> >         (1 << 7)
> > > +#define WL1273_PD_EVENT   
> >         (1 << 8)
> > > +#define WL1273_STIC_EVENT   
> >     (1 << 9)
> > > +#define WL1273_MAL_EVENT   
> >     (1 << 10)
> > > +#define WL1273_POW_ENB_EVENT   
> >     (1 << 11)
> > > +#define WL1273_SCAN_OVER_EVENT   
> >     (1 << 12)
> > > +#define WL1273_ERROR_EVENT   
> >     (1 << 13)
> > > +
> > > +#define TUNER_MODE_STOP_SEARCH   
> >     0
> > > +#define TUNER_MODE_PRESET   
> >     1
> > > +#define TUNER_MODE_AUTO_SEEK   
> >     2
> > > +#define TUNER_MODE_AF   
> >         3
> > > +#define TUNER_MODE_AUTO_SEEK_PI   
> >     4
> > > +#define TUNER_MODE_AUTO_SEEK_BULK   
> > 5
> > > +
> > > +/* Allowed modes */
> > > +#define WL1273_RX_ALLOWED    0x01
> > > +#define WL1273_TX_ALLOWED    0x02
> > > +#define WL1273_RXTX_ALLOWED   
> > (WL1273_RX_ALLOWED | WL1273_TX_ALLOWED)
> > > +
> > > +struct band_info {
> > > +    u32 bottom_frequency;
> > > +    u32 top_frequency;
> > > +    u8 band;
> > > +};
> > > +
> > > +struct wl1273_fm_platform_data {
> > > +    int (*request_resources) (struct
> > i2c_client *client);
> > > +    void (*free_resources) (void);
> > > +    void (*enable) (void);
> > > +    void (*disable) (void);
> > > +
> > > +    u8 modes;
> > > +    unsigned int children;
> > > +};
> > > +
> > > +#define WL1273_FM_CORE_CELLS    2
> > > +
> > > +/* Allowed modes */
> > > +#define WL1273_RX_ALLOWED    0x01
> > > +#define WL1273_TX_ALLOWED    0x02
> > > +#define WL1273_RXTX_ALLOWED   
> > (WL1273_RX_ALLOWED | WL1273_TX_ALLOWED)
> > > +
> > > +struct wl1273_core {
> > > +    struct mfd_cell
> > cells[WL1273_FM_CORE_CELLS];
> > > +    struct i2c_client *i2c_dev;
> > > +
> > > +     u8 allowed_modes;
> > > +    unsigned int mode;
> > > +    unsigned int preemphasis;
> > > +    unsigned int audio_mode;
> > > +    unsigned int spacing;
> > > +    unsigned int tx_power;
> > > +    unsigned int rx_frequency;
> > > +    unsigned int tx_frequency;
> > > +    unsigned int band;
> > > +    unsigned int i2s_mode;
> > > +    unsigned int channel_number;
> > > +    unsigned int number_of_bands;
> > > +    unsigned int volume;
> > > +
> > > +    const struct band_info *bands;
> > > +
> > > +    /* RDS */
> > > +    bool rds_on;
> > > +    struct delayed_work work;
> > > +
> > > +    wait_queue_head_t read_queue;
> > > +    struct mutex lock; /* for
> > serializing fm radio operations */
> > > +    struct completion busy;
> > > +
> > > +    unsigned char *buffer;
> > > +    unsigned int buf_size;
> > > +    unsigned int rd_index;
> > > +    unsigned int wr_index;
> > > +
> > > +    /* Selected interrupts */
> > > +    u16 irq_flags;
> > > +    u16 irq_received;
> > > +};
> > > +
> > > +int wl1273_fm_write_cmd(struct wl1273_core
> *core, u8
> > cmd, u16 param);
> > > +int wl1273_fm_write_data(struct wl1273_core
> *core, u8
> > *data, u16 len);
> > > +int wl1273_fm_read_reg(struct wl1273_core *core,
> u8
> > reg, u16 *value);
> > > +
> > > +int wl1273_fm_set_audio(struct wl1273_core
> *core,
> > unsigned int mode);
> > > +int wl1273_fm_set_volume(struct wl1273_core
> *core,
> > unsigned int volume);
> > > +
> > > +#endif    /* ifndef RADIO_WL1273_H */
> > 
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe
> > linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> 


