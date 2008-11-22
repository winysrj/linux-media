Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail13.svc.cra.dublin.eircom.net ([159.134.118.29])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jdonog01@eircom.net>) id 1L3rAM-0006MV-QG
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 13:00:48 +0100
From: John Donoghue <jdonog01@eircom.net>
To: linux-dvb@linuxtv.org
In-Reply-To: 
Date: Sat, 22 Nov 2008 12:00:15 +0000
Message-Id: <1227355215.10535.30.camel@john-desktop>
Mime-Version: 1.0
Subject: [linux-dvb]  Hi, hauppauge win tv Nova-s plus won't tune
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Roland HAMON wrote:
> Under ubuntu intrepid 64 bits (2.6.27 kernel) vdr fails to tune any
> channel. I tried dvb-apps 'scan' with no success:

> scanning Hotbird-13.0E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12539000 H 27500000 3
> initial transponder 10892000 H 27500000 3

> >>> tune to: 12539:h:0:27500
> DiSEqC: switch pos 0, 18V, hiband (index 3)
> >>> tuning status == 0x01
> >>> tuning status == 0x01

There is a bug in the cx24123 driver.  It does not generate the 22KHz
tone for high-band.  This seems to date back to changeset 4012.  This
removed the code which used the ISL6421 tone generator.  I presume the
intention was to transfer this function to the isl6421 module, but
this wasn't done.  I tested this with a function as follows:

static int isl6421_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
{
	struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
	struct i2c_msg msg = {	.addr = isl6421->i2c_addr, .flags = 0,
				.buf = &isl6421->config,
				.len = sizeof(isl6421->config) };

	switch (tone) {
	case SEC_TONE_ON:
		isl6421->config |= ISL6421_ENT1;
		break;
	case SEC_TONE_OFF:
		isl6421->config &= ~ISL6421_ENT1;
		break;
	default:
		return -EINVAL;
	}

	isl6421->config |= isl6421->override_or;
	isl6421->config &= isl6421->override_and;

	return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
}

and added it to the override ops.  This works fine for me and I am now
getting lock on high-band transponders, but it is probably just the
easy part as I have no idea how DiSEqC Encoding should be handled, nor
how to manage overrides for other cards which use this driver, but may
not want it to generate tones.

Roland, if your low-band transponders are also failing, that is another
issue!

> Then when I poweroff my computer hangs and the motherboards beeps
> repeatedly until I hard switch it off.

This is a known bug in latest Ubuntu release and not related to DVB.

Regards, John



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
