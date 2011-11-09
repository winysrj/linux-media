Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40068 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1KIKhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 05:37:54 -0500
Date: Wed, 9 Nov 2011 11:37:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C
 register
Message-ID: <20111109113740.4b345130@endymion.delvare>
In-Reply-To: <4EBA4E3D.80105@redhat.com>
References: <4EB9C13A.2060707@iki.fi>
	<4EBA4E3D.80105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 09 Nov 2011 07:56:13 -0200, Mauro Carvalho Chehab wrote:
> Em 08-11-2011 21:54, Antti Palosaari escreveu:
> > Function that splits and sends most typical I2C register write.
> > 
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >  drivers/media/dvb/dvb-core/Makefile      |    2 +-
> >  drivers/media/dvb/dvb-core/dvb_generic.c |   48 ++++++++++++++++++++++++++++++
> >  drivers/media/dvb/dvb-core/dvb_generic.h |   21 +++++++++++++
> >  3 files changed, 70 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.c
> >  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.h
> > 
> > diff --git a/drivers/media/dvb/dvb-core/Makefile b/drivers/media/dvb/dvb-core/Makefile
> > index 8f22bcd..230584a 100644
> > --- a/drivers/media/dvb/dvb-core/Makefile
> > +++ b/drivers/media/dvb/dvb-core/Makefile
> > @@ -6,6 +6,6 @@ dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
> > 
> >  dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o     \
> >           dvb_ca_en50221.o dvb_frontend.o         \
> > -         $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
> > +         $(dvb-net-y) dvb_ringbuffer.o dvb_math.o dvb_generic.o
> > 
> >  obj-$(CONFIG_DVB_CORE) += dvb-core.o
> > diff --git a/drivers/media/dvb/dvb-core/dvb_generic.c b/drivers/media/dvb/dvb-core/dvb_generic.c
> > new file mode 100644
> > index 0000000..002bd24
> > --- /dev/null
> > +++ b/drivers/media/dvb/dvb-core/dvb_generic.c
> > @@ -0,0 +1,48 @@
> > +#include <linux/i2c.h>
> > +#include "dvb_generic.h"
> > +
> > +/* write multiple registers */
> > +int dvb_wr_regs(struct dvb_i2c_cfg *i2c_cfg, u8 reg, u8 *val, int len_tot)
> > +{
> > +#define REG_ADDR_LEN 1
> > +#define REG_VAL_LEN 1
> > +    int ret, len_cur, len_rem, len_max;
> > +    u8 buf[i2c_cfg->max_wr];
> > +    struct i2c_msg msg[1] = {
> > +        {
> > +            .addr = i2c_cfg->addr,
> > +            .flags = 0,
> > +            .buf = buf,
> > +        }
> > +    };
> > +
> > +    len_max = i2c_cfg->max_wr - REG_ADDR_LEN;
> > +    for (len_rem = len_tot; len_rem > 0; len_rem -= len_max) {
> > +        len_cur = len_rem;
> > +        if (len_cur > len_max)
> > +            len_cur = len_max;
> > +
> > +        msg[0].len = len_cur + REG_ADDR_LEN;
> > +        buf[0] = reg;
> > +        memcpy(&buf[REG_ADDR_LEN], &val[len_tot - len_rem], len_cur);
> > +
> > +        ret = i2c_transfer(i2c_cfg->adapter, msg, 1);
> > +        if (ret != 1) {
> > +            warn("i2c wr failed=%d reg=%02x len=%d",
> > +                ret, reg, len_cur);
> > +            return -EREMOTEIO;
> > +        }
> 
> Due to the way I2C locks are bound, doing something like the above and something like:
> 
>     struct i2c_msg msg[2] = {
>         {
>             .addr = i2c_cfg->addr,
>             .flags = 0,
>             .buf = buf,
>         },
>         {
>             .addr = i2c_cfg->addr,
>             .flags = 0,
>             .buf = buf2,
>         }
> 
>     };
> 
>     ret = i2c_transfer(i2c_cfg->adapter, msg, 2);
> 
> Produces a different result. In the latter case, I2C core avoids having any other
> transaction in the middle of the 2 messages.

This is correct, but this isn't the only difference. The second
difference is that, with the code above, a repeated-start condition is
used between both messages, instead of a stop condition followed by a
start condition. While ideally all controllers, all controller drivers
and all slaves would support that, I don't think this is true in
practice.

Also note that preventing others from accessing the bus during the
transaction might be desirable sometimes, but this isn't always the
case. A large data transfer over I2C can take a significant amount of
time, during which smaller signaling I2C transfers would be blocked.
Sometimes latency is important too. I think it would be wrong to
hard-code the latency vs. throughput/continuity decision in the helper
functions.

> I like the idea of having some functions to help handling those cases where a single
> transaction needs to be split into several messages.
> 
> Yet, I agree with Michael: I would add such logic inside the I2C subsystem, and
> being sure that the lock is kept during the entire I2C operation.
> 
> Jean,
> 	Thoughts?

I agree that it makes some sense. We recently added helper functions for
swapped word reads, to avoid code duplication amongst device drivers.
This would follow a similar logic.

However you should bear in mind that different I2C devices have
different expectations and requirements. Some do automatic register
address increment, some don't. Some support arbitrary read/write
length and alignment, some don't. It is common that write constraints
differ from read constraints. So you won't possibly come up with
universal I2C read and write functions. There is a reason why it was
originally decided to only provide the low-level transfer functions in
i2c-core and leave the rest up to individual device drivers.

If code is duplicated, then something should indeed be done about it.
But preferably after analyzing properly what the helper functions
should look like, and for this you'll have to look at "all" drivers
that could benefit from it. At the moment only the tda18218 driver was
reported to need it, that's not enough to generalize.

You should take a look at drivers/misc/eeprom/at24.c, it contains
fairly complete transfer functions which cover the various EEPROM
types. Non-EEPROM devices could behave differently, but this would
still seem to be a good start for any I2C device using block transfers.
It was once proposed that these functions could make their way into
i2c-core or a generic i2c helper function.

Both at24 and Antti's proposal share the idea of storing information
about the device capabilities (max block read and write lengths, but we
could also put there alignment requirements or support for repeated
start condition.) in a private structure. If we generalize the
functions then this information would have to be stored in struct
i2c_client and possibly struct i2c_adapter (or struct i2c_algorithm) so
that the function can automatically find out the right sequence of
commands for the adapter/slave combination.

Speaking of struct i2c_client, I seem to remember that the dvb
subsystem doesn't use it much at the moment. This might be an issue if
you intend to get the generic code into i2c-core, as most helper
functions rely on a valid i2c_client structure by design.

-- 
Jean Delvare
