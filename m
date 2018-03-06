Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeCFQOY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:14:24 -0500
Date: Tue, 6 Mar 2018 13:14:20 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH v2 08/12] [media] ngene: deduplicate I2C adapter
 evaluation
Message-ID: <20180306131420.0f012549@vento.lan>
In-Reply-To: <20180306130615.25fd87b5@vento.lan>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
        <20180225123140.19486-9-d.scheller.oss@gmail.com>
        <20180306130615.25fd87b5@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Mar 2018 13:06:15 -0300
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Em Sun, 25 Feb 2018 13:31:36 +0100
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > The I2C adapter evaluation (based on chan->number) is duplicated at
> > several places (tuner_attach_() functions, demod_attach_stv0900() and
> > cineS2_probe()). Clean this up by wrapping that construct in a separate
> > function which all users of that can pass the ngene_channel pointer and
> > get the correct I2C adapter from.
> 
> This patch doesn't apply. 

Forget that. Patch 7 was missing. After applying it, this one
merged OK.

> 
> Please rebase from this point at the top of the media tree.
> 
> PS.: Perhaps I ended by merging an older version of some of your
> patches, as I noticed that some e-mails got lost either by me or
> by patch work along those days.


> 
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >  drivers/media/pci/ngene/ngene-cards.c | 41 +++++++++++++----------------------
> >  1 file changed, 15 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
> > index 00b100660784..dff55c7c9f86 100644
> > --- a/drivers/media/pci/ngene/ngene-cards.c
> > +++ b/drivers/media/pci/ngene/ngene-cards.c
> > @@ -118,17 +118,25 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
> >  /* Demod/tuner attachment ***************************************************/
> >  /****************************************************************************/
> >  
> > +static struct i2c_adapter *i2c_adapter_from_chan(struct ngene_channel *chan)
> > +{
> > +	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
> > +	if (chan->number < 2)
> > +		return &chan->dev->channel[0].i2c_adapter;
> > +
> > +	return &chan->dev->channel[1].i2c_adapter;
> > +}
> > +
> >  static int tuner_attach_stv6110(struct ngene_channel *chan)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct stv090x_config *feconf = (struct stv090x_config *)
> >  		chan->dev->card_info->fe_config[chan->number];
> >  	struct stv6110x_config *tunerconf = (struct stv6110x_config *)
> >  		chan->dev->card_info->tuner_config[chan->number];
> >  	const struct stv6110x_devctl *ctl;
> >  
> > -	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
> >  	if (chan->number < 2)
> >  		i2c = &chan->dev->channel[0].i2c_adapter;
> >  	else
> > @@ -158,16 +166,10 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
> >  static int tuner_attach_stv6111(struct ngene_channel *chan)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct dvb_frontend *fe;
> >  	u8 adr = 4 + ((chan->number & 1) ? 0x63 : 0x60);
> >  
> > -	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
> > -	if (chan->number < 2)
> > -		i2c = &chan->dev->channel[0].i2c_adapter;
> > -	else
> > -		i2c = &chan->dev->channel[1].i2c_adapter;
> > -
> >  	fe = dvb_attach(stv6111_attach, chan->fe, i2c, adr);
> >  	if (!fe) {
> >  		fe = dvb_attach(stv6111_attach, chan->fe, i2c, adr & ~4);
> > @@ -197,10 +199,9 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
> >  static int tuner_attach_tda18271(struct ngene_channel *chan)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct dvb_frontend *fe;
> >  
> > -	i2c = &chan->dev->channel[0].i2c_adapter;
> >  	if (chan->fe->ops.i2c_gate_ctrl)
> >  		chan->fe->ops.i2c_gate_ctrl(chan->fe, 1);
> >  	fe = dvb_attach(tda18271c2dd_attach, chan->fe, i2c, 0x60);
> > @@ -240,7 +241,7 @@ static int tuner_tda18212_ping(struct ngene_channel *chan,
> >  static int tuner_attach_tda18212(struct ngene_channel *chan, u32 dmdtype)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct i2c_client *client;
> >  	struct tda18212_config config = {
> >  		.fe = chan->fe,
> > @@ -262,12 +263,6 @@ static int tuner_attach_tda18212(struct ngene_channel *chan, u32 dmdtype)
> >  	else
> >  		board_info.addr = 0x60;
> >  
> > -	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
> > -	if (chan->number < 2)
> > -		i2c = &chan->dev->channel[0].i2c_adapter;
> > -	else
> > -		i2c = &chan->dev->channel[1].i2c_adapter;
> > -
> >  	/*
> >  	 * due to a hardware quirk with the I2C gate on the stv0367+tda18212
> >  	 * combo, the tda18212 must be probed by reading it's id _twice_ when
> > @@ -320,7 +315,7 @@ static int tuner_attach_probe(struct ngene_channel *chan)
> >  static int demod_attach_stv0900(struct ngene_channel *chan)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct stv090x_config *feconf = (struct stv090x_config *)
> >  		chan->dev->card_info->fe_config[chan->number];
> >  
> > @@ -620,7 +615,7 @@ static int port_has_xo2(struct i2c_adapter *i2c, u8 *type, u8 *id)
> >  static int cineS2_probe(struct ngene_channel *chan)
> >  {
> >  	struct device *pdev = &chan->dev->pci_dev->dev;
> > -	struct i2c_adapter *i2c;
> > +	struct i2c_adapter *i2c = i2c_adapter_from_chan(chan);
> >  	struct stv090x_config *fe_conf;
> >  	u8 buf[3];
> >  	u8 xo2_type, xo2_id, xo2_demodtype;
> > @@ -628,12 +623,6 @@ static int cineS2_probe(struct ngene_channel *chan)
> >  	struct i2c_msg i2c_msg = { .flags = 0, .buf = buf };
> >  	int rc;
> >  
> > -	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
> > -	if (chan->number < 2)
> > -		i2c = &chan->dev->channel[0].i2c_adapter;
> > -	else
> > -		i2c = &chan->dev->channel[1].i2c_adapter;
> > -
> >  	if (port_has_xo2(i2c, &xo2_type, &xo2_id)) {
> >  		xo2_id >>= 2;
> >  		dev_dbg(pdev, "XO2 on channel %d (type %d, id %d)\n",
> 
> 
> 
> Thanks,
> Mauro



Thanks,
Mauro
