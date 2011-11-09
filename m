Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36514 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1KIEsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 23:48:20 -0500
Received: by vws1 with SMTP id 1so1097694vws.19
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 20:48:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EB9C13A.2060707@iki.fi>
References: <4EB9C13A.2060707@iki.fi>
Date: Tue, 8 Nov 2011 23:48:19 -0500
Message-ID: <CAHAyoxyjKiuJchdj+2+=tXt8diLRmvduo2fmpES9gEoRFJL4vw@mail.gmail.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C register
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 8, 2011 at 6:54 PM, Antti Palosaari <crope@iki.fi> wrote:
> Function that splits and sends most typical I2C register write.
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/Makefile      |    2 +-
>  drivers/media/dvb/dvb-core/dvb_generic.c |   48
> ++++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-core/dvb_generic.h |   21 +++++++++++++
>  3 files changed, 70 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.c
>  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.h
>
> diff --git a/drivers/media/dvb/dvb-core/Makefile
> b/drivers/media/dvb/dvb-core/Makefile
> index 8f22bcd..230584a 100644
> --- a/drivers/media/dvb/dvb-core/Makefile
> +++ b/drivers/media/dvb/dvb-core/Makefile
> @@ -6,6 +6,6 @@ dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
>
>  dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o    \
>                 dvb_ca_en50221.o dvb_frontend.o                \
> -                $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
> +                $(dvb-net-y) dvb_ringbuffer.o dvb_math.o dvb_generic.o
>
>  obj-$(CONFIG_DVB_CORE) += dvb-core.o
> diff --git a/drivers/media/dvb/dvb-core/dvb_generic.c
> b/drivers/media/dvb/dvb-core/dvb_generic.c
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
> +       int ret, len_cur, len_rem, len_max;
> +       u8 buf[i2c_cfg->max_wr];
> +       struct i2c_msg msg[1] = {
> +               {
> +                       .addr = i2c_cfg->addr,
> +                       .flags = 0,
> +                       .buf = buf,
> +               }
> +       };
> +
> +       len_max = i2c_cfg->max_wr - REG_ADDR_LEN;
> +       for (len_rem = len_tot; len_rem > 0; len_rem -= len_max) {
> +               len_cur = len_rem;
> +               if (len_cur > len_max)
> +                       len_cur = len_max;
> +
> +               msg[0].len = len_cur + REG_ADDR_LEN;
> +               buf[0] = reg;
> +               memcpy(&buf[REG_ADDR_LEN], &val[len_tot - len_rem],
> len_cur);
> +
> +               ret = i2c_transfer(i2c_cfg->adapter, msg, 1);
> +               if (ret != 1) {
> +                       warn("i2c wr failed=%d reg=%02x len=%d",
> +                               ret, reg, len_cur);
> +                       return -EREMOTEIO;
> +               }
> +               reg += len_cur;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(dvb_wr_regs);
> +
> +/* write single register */
> +int dvb_wr_reg(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 val)
> +{
> +       return dvb_wr_regs(i2c_cfg, reg, &val, 1);
> +}
> +EXPORT_SYMBOL(dvb_wr_reg);
> +
> diff --git a/drivers/media/dvb/dvb-core/dvb_generic.h
> b/drivers/media/dvb/dvb-core/dvb_generic.h
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
> +       printk(KERN_WARNING DVB_GENERIC_LOG_PREFIX": " f "\n", ## arg)
> +
> +struct dvb_i2c_cfg {
> +       struct i2c_adapter *adapter;
> +       u8 addr;
> +       /* TODO: reg_addr_len; as now use one byte */
> +       /* TODO: reg_val_len; as now use one byte */
> +       u8 max_wr;
> +       u8 max_rd;
> +};
> +
> +extern int dvb_wr_regs(struct dvb_i2c_cfg *, u8, u8 *, int);
> +extern int dvb_wr_reg(struct dvb_i2c_cfg *, u8, u8);
> +
> +#endif
> +
> --
> 1.7.4.4
>

Without reviewing the actual code here, there actually isn't any
reason for this to be a part of dvb-core.  It can be its own module.

Meanwhile, if there is need for this, don't you think it should be
implemented in a generic way for use by other, NON-dvb drivers?

-Mike
