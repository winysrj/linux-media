Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47980 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbbBCTon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 14:44:43 -0500
Date: Tue, 3 Feb 2015 17:44:38 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] lmedm04: add read snr, signal strength and ber call
 backs
Message-ID: <20150203174438.3832d42d@recife.lan>
In-Reply-To: <54D12204.4030403@gmail.com>
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
	<1420206991-3939-5-git-send-email-tvboxspy@gmail.com>
	<20150203171921.2afa629c@recife.lan>
	<54D12204.4030403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 03 Feb 2015 19:31:16 +0000
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> 
> 
> On 03/02/15 19:19, Mauro Carvalho Chehab wrote:
> > Em Fri,  2 Jan 2015 13:56:31 +0000
> > Malcolm Priestley <tvboxspy@gmail.com> escreveu:
> >
> >> This allows calling the original functions providing the streaming is off.
> >
> > Malcolm,
> >
> > I'm applying this patch series, as the driver has already some support for
> > the legacy DVBv3 stats, but please port it to use DVBv5.
> Hi Mauro,
> 
> I am not sure what you mean by this?

The DVB API version 3 has some issues with stats. The main one is that
they don't provide any glue to userspace about what scale they use. 
Due to that, we've added a new API at DVB. We're gradually adding
support for that on the already existing drivers.

> Are there any examples?

Yes. You can see, for example:

$ git lg drivers/media/dvb-frontends/ |grep stats
906aaf5a195b [media] dvb:tc90522: fix stats report
1d0ceae4a19d [media] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
041ad449683b [media] dib7000p: Add DVBv5 stats support
d591590e1b5b [media] drx-j: enable DVBv5 stats
6983257813dc [media] drx-j: properly handle bit counts on stats
03fdfbfd3b59 [media] drx-j: Prepare to use DVBv5 stats
704f01bbc7e4 [media] dib8000: be sure that stats are available before reading them
7a9d85d5559f [media] dib8000: Fix UCB measure with DVBv5 stats
6ef06e78c74c [media] dib8000: add DVBv5 stats
8f3741e02831 [media] drxk: Add pre/post BER and PER/UCB stats
8b8e444a2711 [media] mb86a20s: Don't reset strength with the other stats
15b1c5a068e7 [media] mb86a20s: provide CNR stats before FE_HAS_SYNC

or:

$ git lg drivers/media/dvb-frontends/ |grep DVBv5
25ef9f554713 [media] rtl2832: implement DVBv5 signal strength statistics
084330b746d9 [media] rtl2832: wrap DVBv5 BER to DVBv3
f7caf93fb8ed [media] rtl2832: wrap DVBv5 CNR to DVBv3 SNR
6b4fd01804ce [media] rtl2832: implement DVBv5 BER statistic
19d273d63552 [media] rtl2832: implement DVBv5 CNR statistic
6dcfe3cc2e33 [media] rtl2830: wrap DVBv5 CNR to DVBv3 SNR
f491391cc331 [media] rtl2830: wrap DVBv5 BER to DVBv3
d512e286512c [media] rtl2830: wrap DVBv5 signal strength to DVBv3
5bb11ca5864a [media] rtl2830: implement DVBv5 BER statistic
871f70252b6f [media] rtl2830: implement DVBv5 signal strength statistics
47b4dbfff1f3 [media] rtl2830: implement DVBv5 CNR statistic
2db4d179e16d [media] af9033: init DVBv5 statistics
e53c47445bb5 [media] af9033: wrap DVBv3 BER to DVBv5 BER
1d0ceae4a19d [media] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
6bb096c92671 [media] af9033: implement DVBv5 post-Viterbi BER
204f4319289f [media] af9033: implement DVBv5 stat block counters
6b45778609db [media] af9033: wrap DVBv3 read SNR to DVBv5 CNR
3e41313aeadf [media] af9033: implement DVBv5 statistics for CNR
83f1161911c5 [media] af9033: implement DVBv5 statistics for signal strength
041ad449683b [media] dib7000p: Add DVBv5 stats support
d591590e1b5b [media] drx-j: enable DVBv5 stats
03fdfbfd3b59 [media] drx-j: Prepare to use DVBv5 stats
7a9d85d5559f [media] dib8000: Fix UCB measure with DVBv5 stats
6ef06e78c74c [media] dib8000: add DVBv5 stats



> 
> 
> Regards
> 
> 
> Malcolm
> 
> 
> >
> > Thanks,
> > Mauro
> >
> >>
> >> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> >> ---
> >>   drivers/media/usb/dvb-usb-v2/lmedm04.c | 24 ++++++++++++++++++++++++
> >>   1 file changed, 24 insertions(+)
> >>
> >> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> >> index a9c7fd0..5de6f7c 100644
> >> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> >> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> >> @@ -145,6 +145,10 @@ struct lme2510_state {
> >>   	void *usb_buffer;
> >>   	/* Frontend original calls */
> >>   	int (*fe_read_status)(struct dvb_frontend *, fe_status_t *);
> >> +	int (*fe_read_signal_strength)(struct dvb_frontend *, u16 *);
> >> +	int (*fe_read_snr)(struct dvb_frontend *, u16 *);
> >> +	int (*fe_read_ber)(struct dvb_frontend *, u32 *);
> >> +	int (*fe_read_ucblocks)(struct dvb_frontend *, u32 *);
> >>   	int (*fe_set_voltage)(struct dvb_frontend *, fe_sec_voltage_t);
> >>   	u8 dvb_usb_lme2510_firmware;
> >>   };
> >> @@ -877,6 +881,9 @@ static int dm04_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
> >>   {
> >>   	struct lme2510_state *st = fe_to_priv(fe);
> >>
> >> +	if (st->fe_read_signal_strength && !st->stream_on)
> >> +		return st->fe_read_signal_strength(fe, strength);
> >> +
> >>   	switch (st->tuner_config) {
> >>   	case TUNER_LG:
> >>   		*strength = 0xff - st->signal_level;
> >> @@ -898,6 +905,9 @@ static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
> >>   {
> >>   	struct lme2510_state *st = fe_to_priv(fe);
> >>
> >> +	if (st->fe_read_snr && !st->stream_on)
> >> +		return st->fe_read_snr(fe, snr);
> >> +
> >>   	switch (st->tuner_config) {
> >>   	case TUNER_LG:
> >>   		*snr = 0xff - st->signal_sn;
> >> @@ -917,6 +927,11 @@ static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
> >>
> >>   static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
> >>   {
> >> +	struct lme2510_state *st = fe_to_priv(fe);
> >> +
> >> +	if (st->fe_read_ber && !st->stream_on)
> >> +		return st->fe_read_ber(fe, ber);
> >> +
> >>   	*ber = 0;
> >>
> >>   	return 0;
> >> @@ -924,6 +939,11 @@ static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
> >>
> >>   static int dm04_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> >>   {
> >> +	struct lme2510_state *st = fe_to_priv(fe);
> >> +
> >> +	if (st->fe_read_ucblocks && !st->stream_on)
> >> +		return st->fe_read_ucblocks(fe, ucblocks);
> >> +
> >>   	*ucblocks = 0;
> >>
> >>   	return 0;
> >> @@ -1036,6 +1056,10 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
> >>   	}
> >>
> >>   	st->fe_read_status = adap->fe[0]->ops.read_status;
> >> +	st->fe_read_signal_strength = adap->fe[0]->ops.read_signal_strength;
> >> +	st->fe_read_snr = adap->fe[0]->ops.read_snr;
> >> +	st->fe_read_ber = adap->fe[0]->ops.read_ber;
> >> +	st->fe_read_ucblocks = adap->fe[0]->ops.read_ucblocks;
> >>
> >>   	adap->fe[0]->ops.read_status = dm04_read_status;
> >>   	adap->fe[0]->ops.read_signal_strength = dm04_read_signal_strength;
