Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1KIJ4c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 04:56:32 -0500
Message-ID: <4EBA4E3D.80105@redhat.com>
Date: Wed, 09 Nov 2011 07:56:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C register
References: <4EB9C13A.2060707@iki.fi>
In-Reply-To: <4EB9C13A.2060707@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-11-2011 21:54, Antti Palosaari escreveu:
> Function that splits and sends most typical I2C register write.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/Makefile      |    2 +-
>  drivers/media/dvb/dvb-core/dvb_generic.c |   48 ++++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-core/dvb_generic.h |   21 +++++++++++++
>  3 files changed, 70 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.c
>  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.h
> 
> diff --git a/drivers/media/dvb/dvb-core/Makefile b/drivers/media/dvb/dvb-core/Makefile
> index 8f22bcd..230584a 100644
> --- a/drivers/media/dvb/dvb-core/Makefile
> +++ b/drivers/media/dvb/dvb-core/Makefile
> @@ -6,6 +6,6 @@ dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
> 
>  dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o     \
>           dvb_ca_en50221.o dvb_frontend.o         \
> -         $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
> +         $(dvb-net-y) dvb_ringbuffer.o dvb_math.o dvb_generic.o
> 
>  obj-$(CONFIG_DVB_CORE) += dvb-core.o
> diff --git a/drivers/media/dvb/dvb-core/dvb_generic.c b/drivers/media/dvb/dvb-core/dvb_generic.c
> new file mode 100644
> index 0000000..002bd24
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-core/dvb_generic.c
> @@ -0,0 +1,48 @@
> +#include <linux/i2c.h>
> +#include "dvb_generic.h"
> +
> +/* write multiple registers */
> +int dvb_wr_regs(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 *val, int len_tot)
> +{
> +#define REG_ADDR_LEN 1
> +#define REG_VAL_LEN 1
> +    int ret, len_cur, len_rem, len_max;
> +    u8 buf[i2c_cfg->max_wr];
> +    struct i2c_msg msg[1] = {
> +        {
> +            .addr = i2c_cfg->addr,
> +            .flags = 0,
> +            .buf = buf,
> +        }
> +    };
> +
> +    len_max = i2c_cfg->max_wr - REG_ADDR_LEN;
> +    for (len_rem = len_tot; len_rem > 0; len_rem -= len_max) {
> +        len_cur = len_rem;
> +        if (len_cur > len_max)
> +            len_cur = len_max;
> +
> +        msg[0].len = len_cur + REG_ADDR_LEN;
> +        buf[0] = reg;
> +        memcpy(&buf[REG_ADDR_LEN], &val[len_tot - len_rem], len_cur);
> +
> +        ret = i2c_transfer(i2c_cfg->adapter, msg, 1);
> +        if (ret != 1) {
> +            warn("i2c wr failed=%d reg=%02x len=%d",
> +                ret, reg, len_cur);
> +            return -EREMOTEIO;
> +        }

Due to the way I2C locks are bound, doing something like the above and something like:

    struct i2c_msg msg[2] = {
        {
            .addr = i2c_cfg->addr,
            .flags = 0,
            .buf = buf,
        },
        {
            .addr = i2c_cfg->addr,
            .flags = 0,
            .buf = buf2,
        }

    };

    ret = i2c_transfer(i2c_cfg->adapter, msg, 2);

Produces a different result. In the latter case, I2C core avoids having any other
transaction in the middle of the 2 messages.

I like the idea of having some functions to help handling those cases where a single
transaction needs to be split into several messages.

Yet, I agree with Michael: I would add such logic inside the I2C subsystem, and
being sure that the lock is kept during the entire I2C operation.

Jean,
	Thoughts?

> +        reg += len_cur;
> +    }
> +
> +    return 0;
> +}
> +EXPORT_SYMBOL(dvb_wr_regs);
> +
> +/* write single register */
> +int dvb_wr_reg(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 val)
> +{
> +    return dvb_wr_regs(i2c_cfg, reg, &val, 1);
> +}
> +EXPORT_SYMBOL(dvb_wr_reg);
> +
> diff --git a/drivers/media/dvb/dvb-core/dvb_generic.h b/drivers/media/dvb/dvb-core/dvb_generic.h
> new file mode 100644
> index 0000000..7a140ab
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-core/dvb_generic.h
> @@ -0,0 +1,21 @@
> +#ifndef DVB_GENERIC_H
> +#define DVB_GENERIC_H
> +
> +#define DVB_GENERIC_LOG_PREFIX "dvb_generic"
> +#define warn(f, arg...) \
> +    printk(KERN_WARNING DVB_GENERIC_LOG_PREFIX": " f "\n", ## arg)
> +
> +struct dvb_i2c_cfg {
> +    struct i2c_adapter *adapter;
> +    u8 addr;
> +    /* TODO: reg_addr_len; as now use one byte */
> +    /* TODO: reg_val_len; as now use one byte */
> +    u8 max_wr;
> +    u8 max_rd;
> +};
> +
> +extern int dvb_wr_regs(struct dvb_i2c_cfg *, u8, u8 *, int);
> +extern int dvb_wr_reg(struct dvb_i2c_cfg *, u8, u8);
> +
> +#endif
> +

