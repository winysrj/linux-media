Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3BDNn6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 08:43:58 -0500
Date: Mon, 4 Feb 2013 11:43:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] tuner-core: Change config from unsigned int to void
 *
Message-ID: <20130204114347.0c28af10@redhat.com>
In-Reply-To: <CAOcJUbwyh7_Mh+-dGWbTzUNcdbS4gtV2Hch0-oKdfZydJm42XQ@mail.gmail.com>
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
	<1359750087-1155-4-git-send-email-linux@rainbow-software.org>
	<CAOcJUbwyh7_Mh+-dGWbTzUNcdbS4gtV2Hch0-oKdfZydJm42XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Feb 2013 20:59:12 -0500
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> On Fri, Feb 1, 2013 at 3:21 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> > config looks like a hack that was added to tuner-core to allow some
> > configuration of TDA8290 tuner (it's not used by any other driver).
> > But with the new configuration options of tda8290 driver (no_i2c_gate
> > and std_map), it's no longer sufficient.
> >
> > Change config to be void * instead, which allows passing tuner-dependent
> > config struct to drivers.
> >
> > Also update saa7134 driver to reflect this change (no other driver uses this).
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/media/pci/saa7134/saa7134-cards.c |   40 ++++++++++++++--------------
> >  drivers/media/pci/saa7134/saa7134.h       |    3 +-
> >  drivers/media/v4l2-core/tuner-core.c      |   20 +++++---------
> >  include/media/tuner.h                     |    2 +-
> >  4 files changed, 30 insertions(+), 35 deletions(-)
> >
> > diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
> > index bc08f1d..fe54f88 100644
> > --- a/drivers/media/pci/saa7134/saa7134-cards.c
> > +++ b/drivers/media/pci/saa7134/saa7134-cards.c
> > @@ -2760,7 +2760,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 0,
> > +               .tda829x_conf   = { .lna_cfg = 0 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = {{
> > @@ -3291,7 +3291,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 1,
> > +               .tda829x_conf   = { .lna_cfg = 1 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x000200000,
> >                 .inputs         = {{
> > @@ -3395,7 +3395,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 1,
> > +               .tda829x_conf   = { .lna_cfg = 1 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200100,
> >                 .inputs         = {{
> > @@ -3426,7 +3426,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 3,
> > +               .tda829x_conf   = { .lna_cfg = 3 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .ts_type        = SAA7134_MPEG_TS_SERIAL,
> >                 .ts_force_val   = 1,
> > @@ -3459,7 +3459,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 3,
> > +               .tda829x_conf   = { .lna_cfg = 3 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .ts_type        = SAA7134_MPEG_TS_SERIAL,
> >                 .gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
> > @@ -3683,7 +3683,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = {{
> > @@ -3736,7 +3736,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = {{
> > @@ -3754,7 +3754,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .gpiomask       = 1 << 21,
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .inputs         = {{
> > @@ -3887,7 +3887,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 0,
> > +               .tda829x_conf   = { .lna_cfg = 0 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .inputs = {{
> >                         .name   = name_tv, /* FIXME: analog tv untested */
> > @@ -3903,7 +3903,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .gpiomask       = 0x020200000,
> >                 .inputs         = {{
> >                         .name = name_tv,
> > @@ -3937,7 +3937,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 0,
> > +               .tda829x_conf   = { .lna_cfg = 0 },
> >                 .gpiomask       = 0x020200000,
> >                 .inputs         = {{
> >                         .name = name_tv,
> > @@ -4737,7 +4737,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = {{
> > @@ -4823,7 +4823,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type   = UNSET,
> >                 .tuner_addr   = ADDR_UNSET,
> >                 .radio_addr   = ADDR_UNSET,
> > -               .tuner_config = 0,
> > +               .tda829x_conf = { .lna_cfg = 0 },
> >                 .mpeg         = SAA7134_MPEG_DVB,
> >                 .inputs       = {{
> >                         .name = name_tv,
> > @@ -4847,7 +4847,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = { {
> > @@ -5057,7 +5057,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .gpiomask       = 1 << 21,
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .inputs         = {{
> > @@ -5087,7 +5087,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 2,
> > +               .tda829x_conf   = { .lna_cfg = 2 },
> >                 .gpiomask       = 1 << 21,
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .inputs         = {{
> > @@ -5176,7 +5176,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 0,
> > +               .tda829x_conf   = { .lna_cfg = 0 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .gpiomask       = 0x0200000,
> >                 .inputs = { {
> > @@ -5406,7 +5406,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .radio_type     = UNSET,
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> > -               .tuner_config   = 0,
> > +               .tda829x_conf   = { .lna_cfg = 0 },
> >                 .mpeg           = SAA7134_MPEG_DVB,
> >                 .ts_type        = SAA7134_MPEG_TS_PARALLEL,
> >                 .inputs         = {{
> > @@ -5629,7 +5629,7 @@ struct saa7134_board saa7134_boards[] = {
> >                 .audio_clock    = 0x00187de7,
> >                 .tuner_type     = TUNER_PHILIPS_TDA8290,
> >                 .radio_type     = UNSET,
> > -               .tuner_config   = 3,
> > +               .tda829x_conf   = { .lna_cfg = 3 },
> >                 .tuner_addr     = ADDR_UNSET,
> >                 .radio_addr     = ADDR_UNSET,
> >                 .gpiomask       = 0x02050000,
> > @@ -7616,7 +7616,7 @@ static void saa7134_tuner_setup(struct saa7134_dev *dev)
> >         if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type != UNSET)) {
> >                 tun_setup.type = dev->tuner_type;
> >                 tun_setup.addr = dev->tuner_addr;
> > -               tun_setup.config = saa7134_boards[dev->board].tuner_config;
> > +               tun_setup.config = &saa7134_boards[dev->board].tda829x_conf;
> >                 tun_setup.tuner_callback = saa7134_tuner_callback;
> >
> >                 tun_setup.mode_mask = mode_mask;
> > diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
> > index c24b651..ce1b4b5 100644
> > --- a/drivers/media/pci/saa7134/saa7134.h
> > +++ b/drivers/media/pci/saa7134/saa7134.h
> > @@ -44,6 +44,7 @@
> >  #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
> >  #include <media/videobuf-dvb.h>
> >  #endif
> > +#include "tda8290.h"
> >
> >  #define UNSET (-1U)
> >
> > @@ -388,7 +389,7 @@ struct saa7134_board {
> >         unsigned char           rds_addr;
> >
> >         unsigned int            tda9887_conf;
> > -       unsigned int            tuner_config;
> > +       struct tda829x_config   tda829x_conf;
> >
> >         /* peripheral I/O */
> >         enum saa7134_video_out  video_out;
> > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > index b5a819a..14ad8f4 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -132,7 +132,7 @@ struct tuner {
> >         bool                standby;    /* Standby mode */
> >
> >         unsigned int        type; /* chip type id */
> > -       unsigned int        config;
> > +       void                *config;
> >         const char          *name;
> >  };
> >
> > @@ -272,9 +272,8 @@ static struct analog_demod_ops tuner_analog_ops = {
> >   * @c:                 i2c_client descriptoy
> >   * @type:              type of the tuner (e. g. tuner number)
> >   * @new_mode_mask:     Indicates if tuner supports TV and/or Radio
> > - * @new_config:                an optional parameter ranging from 0-255 used by
> > -                       a few tuners to adjust an internal parameter,
> > -                       like LNA mode
> > + * @new_config:                an optional parameter used by a few tuners to adjust
> > +                       internal parameters, like LNA mode
> >   * @tuner_callback:    an optional function to be called when switching
> >   *                     to analog mode
> >   *
> > @@ -282,7 +281,7 @@ static struct analog_demod_ops tuner_analog_ops = {
> >   * by tun_setup structure. It contains several per-tuner initialization "magic"
> >   */
> >  static void set_type(struct i2c_client *c, unsigned int type,
> > -                    unsigned int new_mode_mask, unsigned int new_config,
> > +                    unsigned int new_mode_mask, void *new_config,
> >                      int (*tuner_callback) (void *dev, int component, int cmd, int arg))
> >  {
> >         struct tuner *t = to_tuner(i2c_get_clientdata(c));
> > @@ -297,8 +296,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >         }
> >
> >         t->type = type;
> > -       /* prevent invalid config values */
> > -       t->config = new_config < 256 ? new_config : 0;
> > +       t->config = new_config;
> >         if (tuner_callback != NULL) {
> >                 tuner_dbg("defining GPIO callback\n");
> >                 t->fe.callback = tuner_callback;
> > @@ -316,11 +314,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >                 break;
> >         case TUNER_PHILIPS_TDA8290:
> >         {
> > -               struct tda829x_config cfg = {
> > -                       .lna_cfg        = t->config,
> > -               };
> >                 if (!dvb_attach(tda829x_attach, &t->fe, t->i2c->adapter,
> > -                               t->i2c->addr, &cfg))
> > +                               t->i2c->addr, t->config))
> >                         goto attach_failed;
> >                 break;
> >         }
> > @@ -409,7 +404,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >         case TUNER_NXP_TDA18271:
> >         {
> >                 struct tda18271_config cfg = {
> > -                       .config = t->config,
> >                         .small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
> >                 };
> >
> > @@ -506,7 +500,7 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd,
> >         struct tuner *t = to_tuner(sd);
> >         struct i2c_client *c = v4l2_get_subdevdata(sd);
> >
> > -       tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
> > +       tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=%p\n",
> >                         tun_setup->type,
> >                         tun_setup->addr,
> >                         tun_setup->mode_mask,
> > diff --git a/include/media/tuner.h b/include/media/tuner.h
> > index 926aff9..c60552b 100644
> > --- a/include/media/tuner.h
> > +++ b/include/media/tuner.h
> > @@ -188,7 +188,7 @@ struct tuner_setup {
> >         unsigned short  addr;   /* I2C address */
> >         unsigned int    type;   /* Tuner type */
> >         unsigned int    mode_mask;  /* Allowed tuner modes */
> > -       unsigned int    config; /* configuraion for more complex tuners */
> > +       void            *config;    /* configuraion for more complex tuners */
> >         int (*tuner_callback) (void *dev, int component, int cmd, int arg);
> >  };
> 
> I pushed patch 1 & 2 into the 'zary' branch of my 'dvb' git tree on
> linuxtv.org -- I am going to do some testing and then issue a merge
> request to Mauro if all is OK.
> 
> As for this patch, I think this is a good idea, but I think the patch
> should be resent with RFC in the title, to ensure that everybody sees
> that you're proposing a tuner internal API change (unless Mauro has
> any comments in this thread)
> 
> I'm still digging a bit to make sure this doesn't have any negative
> effect on the tda827x driver, but it looks safe to me right now.
> 
> I'd like to hear Mauro's comments on this too, but it looks good to me.

It looks good to me, as it makes clearer for what purpose the config is being
used.

I would also change the magic values for LNA config to some enum, as
"0", "1", "2", "3" doesn't bring any meaning.
It would be better to call it with something like:

enum tda8290_lna {
	TDA8290_LNA_OFF = 0,
	TDA8290_LNA_GP0_HIGH_ON = 1,
	TDA8290_LNA_GP0_HIGH_OFF = 2,
	TDA8290_LNA_ON_BRIDGE = 3,
};

and replace the magic number occurrences at tda8290, tda827x and saa713x.
	

> 
> Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>


-- 

Cheers,
Mauro
