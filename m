Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:60381 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZB0XFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 18:05:09 -0500
Subject: Re: [linux-dvb] GDI Black Gold [14c7:0108] cx88 based DVB-T card
From: hermann pitton <hermann-pitton@arcor.de>
To: Tim Small <tim@buttersideup.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <49A7CE56.5040909@buttersideup.com>
References: <737399.42093.qm@web23305.mail.ird.yahoo.com>
	 <49A7CE56.5040909@buttersideup.com>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 00:06:25 +0100
Message-Id: <1235775985.2697.19.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Am Freitag, den 27.02.2009, 11:28 +0000 schrieb Tim Small:
> Hello,
> 
> I'm interested in getting this card working under Linux as well, it's
> labelled GDI2500PCTV on the back, and has a Conexant CX23881 visible on
> the front, with a Philips "TU1216/1 H P" RF box...  Looks like there may
> be some more ICs under the metal box, but I'd have to desolder it to
> check what they were (which I can do if necessary).
> 
> According to the preliminary datasheet which I found, the TU1216
> contains a TDA 10046 Channel Decoder, and a TDA6651 Mixer/Oscillator.
> 
> There seems to be TU1216 support in both v4l/saa7134-dvb.c and
> v4l/budget-av.c (code cut-n-paste by the look of it), but I can't see a
> way to select this tuner with the cx88xx module (e.g. CARDLIST.tuner),
> unless it's called something different, or is compatible with another
> Philips tuner.

since there is no analog TV tuning support you use TUNER_ABSENT in
cx88-cards.c like SAA7134_BOARD_VIDEOMATE_DVBT_200 and
SAA7134_BOARD_PHILIPS_TOUGH do in saa7134-cards.c accordingly.

> So... I'm game for trying to get this working, and have a bit of kernel
> programming experience, but is there anything else I'm likely to need to
> know before I set out on this?

You then need to implement the functions they call in saa7134-dvb.c
accordingly to cx88-dvb.c and find out if the tuner address is 0x60 or
0x61.

	case SAA7134_BOARD_PHILIPS_TOUGH:
		fe0->dvb.frontend = dvb_attach(tda10046_attach,
					       &philips_tu1216_60_config,
					       &dev->i2c_adap);
		if (fe0->dvb.frontend) {
			fe0->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
		}

For testing, on a first look, you need to introduce the tda10046
including firmware upload #include "tda1004x.h" and at least adapt these
functions to cx88-dvb.

/* ==================================================================
 * tda1004x based DVB-T cards, helper functions
 */

static int philips_tda1004x_request_firmware(struct dvb_frontend *fe,
					   const struct firmware **fw, char *name)
{
	struct saa7134_dev *dev = fe->dvb->priv;
	return request_firmware(fw, name, &dev->pci->dev);
}

/* ------------------------------------------------------------------
 * these tuners are tu1216, td1316(a)
 */

static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
{
	struct saa7134_dev *dev = fe->dvb->priv;
	struct tda1004x_state *state = fe->demodulator_priv;
	u8 addr = state->config->tuner_address;
	u8 tuner_buf[4];
	struct i2c_msg tuner_msg = {.addr = addr,.flags = 0,.buf = tuner_buf,.len =
			sizeof(tuner_buf) };
	int tuner_frequency = 0;
	u8 band, cp, filter;

	/* determine charge pump */
	tuner_frequency = params->frequency + 36166000;
	if (tuner_frequency < 87000000)
		return -EINVAL;
	else if (tuner_frequency < 130000000)
		cp = 3;
	else if (tuner_frequency < 160000000)
		cp = 5;
	else if (tuner_frequency < 200000000)
		cp = 6;
	else if (tuner_frequency < 290000000)
		cp = 3;
	else if (tuner_frequency < 420000000)
		cp = 5;
	else if (tuner_frequency < 480000000)
		cp = 6;
	else if (tuner_frequency < 620000000)
		cp = 3;
	else if (tuner_frequency < 830000000)
		cp = 5;
	else if (tuner_frequency < 895000000)
		cp = 7;
	else
		return -EINVAL;

	/* determine band */
	if (params->frequency < 49000000)
		return -EINVAL;
	else if (params->frequency < 161000000)
		band = 1;
	else if (params->frequency < 444000000)
		band = 2;
	else if (params->frequency < 861000000)
		band = 4;
	else
		return -EINVAL;

	/* setup PLL filter */
	switch (params->u.ofdm.bandwidth) {
	case BANDWIDTH_6_MHZ:
		filter = 0;
		break;

	case BANDWIDTH_7_MHZ:
		filter = 0;
		break;

	case BANDWIDTH_8_MHZ:
		filter = 1;
		break;

	default:
		return -EINVAL;
	}

	/* calculate divisor
	 * ((36166000+((1000000/6)/2)) + Finput)/(1000000/6)
	 */
	tuner_frequency = (((params->frequency / 1000) * 6) + 217496) / 1000;

	/* setup tuner buffer */
	tuner_buf[0] = (tuner_frequency >> 8) & 0x7f;
	tuner_buf[1] = tuner_frequency & 0xff;
	tuner_buf[2] = 0xca;
	tuner_buf[3] = (cp << 5) | (filter << 3) | band;

	if (fe->ops.i2c_gate_ctrl)
		fe->ops.i2c_gate_ctrl(fe, 1);
	if (i2c_transfer(&dev->i2c_adap, &tuner_msg, 1) != 1) {
		wprintk("could not write to tuner at addr: 0x%02x\n",
			addr << 1);
		return -EIO;
	}
	msleep(1);
	return 0;
}

static int philips_tu1216_init(struct dvb_frontend *fe)
{
	struct saa7134_dev *dev = fe->dvb->priv;
	struct tda1004x_state *state = fe->demodulator_priv;
	u8 addr = state->config->tuner_address;
	static u8 tu1216_init[] = { 0x0b, 0xf5, 0x85, 0xab };
	struct i2c_msg tuner_msg = {.addr = addr,.flags = 0,.buf = tu1216_init,.len = sizeof(tu1216_init) };

	/* setup PLL configuration */
	if (fe->ops.i2c_gate_ctrl)
		fe->ops.i2c_gate_ctrl(fe, 1);
	if (i2c_transfer(&dev->i2c_adap, &tuner_msg, 1) != 1)
		return -EIO;
	msleep(1);

	return 0;
}

/* ------------------------------------------------------------------ */

static struct tda1004x_config philips_tu1216_60_config = {
	.demod_address = 0x8,
	.invert        = 1,
	.invert_oclk   = 0,
	.xtal_freq     = TDA10046_XTAL_4M,
	.agc_config    = TDA10046_AGC_DEFAULT,
	.if_freq       = TDA10046_FREQ_3617,
	.tuner_address = 0x60,
	.request_firmware = philips_tda1004x_request_firmware
};

static struct tda1004x_config philips_tu1216_61_config = {

	.demod_address = 0x8,
	.invert        = 1,
	.invert_oclk   = 0,
	.xtal_freq     = TDA10046_XTAL_4M,
	.agc_config    = TDA10046_AGC_DEFAULT,
	.if_freq       = TDA10046_FREQ_3617,
	.tuner_address = 0x61,
	.request_firmware = philips_tda1004x_request_firmware
};

/* ------------------------------------------------------------------ */

What could be factored out to avoid code duplication is another later
question I guess.

Cheers,
Hermann

> Cheers!
> 
> Tim.
> 
> 
> Richard Runds wrote:
> > Hi,
> >
> > Have a GDI Black Gold card with subsystem 14c7:0108 and I cannot make it work. Does anyone on the list have a working config for this card and/or know how to make this card work?
> >
> > I'm getting so far as video1 and vbi1 is created, but I don't have any entries in /dev/dvb/.
> >
> > cat /dev/video1 > test.mpg produces a video typical of a tv picture without signal (ant-war)... :)
> >
> >
> > config
> > ====
> >
> > /etc/modprobe.conf:
> >
> > alias char-major-81-1 cx88-dvb
> > options cx88xx card=2 i2c_scan=1
> >
> > lspci -v:
> >
> > 02:09.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
> >         Subsystem: Modular Technology Holdings Ltd GDI Black Gold
> >         Flags: bus master, medium devsel, latency 64, IRQ 23
> >         Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
> >         Capabilities: [44] Vital Product Data
> >         Capabilities: [4c] Power Management version 2
> >
> > 02:09.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
> >         Subsystem: Modular Technology Holdings Ltd Unknown device 0108
> >         Flags: bus master, medium devsel, latency 64, IRQ 5
> >         Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
> >         Capabilities: [4c] Power Management version 2
> >
> > dmesg:
> >
> > CORE cx88[0]: subsystem: 14c7:0108, board: GDI Black Gold [card=2,insmod option]
> > TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
> > cx88[0]: Test OK
> > cx88[0]: i2c scan: found device @ 0x10  [???]
> > cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> > cx88[0]: GDI: tuner=unknown
> > cx88[0]/2: cx2388x 8802 Driver Manager
> > ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 21 (level, low) -> IRQ 23
> > CORE cx88[0]: subsystem: 14c7:0108, board: GDI Black Gold [card=2,insmod option]
> > TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
> > cx88[0]: Test OK
> > cx88[0]: i2c scan: found device @ 0x10  [???]
> > cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> > cx88[0]: GDI: tuner=unknown
> > cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 23, latency: 64, mmio: 0xf5000000
> > cx88[0]/0: registered device video1 [v4l2]
> > cx88[0]/0: registered device vbi1
> >
> >
> >
> > Thanks,
> >
> > //riru
> >
> >


