Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jk3aL-0005Cq-UI
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 22:41:30 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 10 Apr 2008 22:40:13 +0200
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803220711.07186@orion.escape-edv.de>
	<47E53E1B.5050302@gmail.com>
In-Reply-To: <47E53E1B.5050302@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tsn/H7LDvkge72y"
Message-Id: <200804102240.13933@orion.escape-edv.de>
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
	transponder fails
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_tsn/H7LDvkge72y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Manu Abraham wrote:
> Oliver Endriss wrote:
> ...
> > Ok, some calculations according your formula
> > 
> >>>>> BW = (1 + RO) * SR/2 + 5) * 1.3
> > 
> > 45 MSPS:
> > BW = ((1 + 0.35) * 45/2 + 5) * 1.3 = 46
> > 
> > -> cutoff 36 MHz (maximum value supported)
> > 
> > 27 MSPS:
> > BW = ((1 + 0.35) * 27/2 + 5) * 1.3 = 30,2
> > 
> > -> cutoff 31 MHz
> > 
> > 22 MSPS:
> > BW = ((1 + 0.35) * 22/2 + 5) * 1.3 = 25,8
> > 
> > -> cutoff 26 MHz
> > 
> > Are these calculations correct, or did I miss something here?
> 
> 
> It looks fine, just round it off to the next integer. ie always round it
> up, rather than rounding it down. For the cutoff at 36MHz, it is fine as
> well, since at the last step, you will not need an offset, since it
> would be the last step in the spectrum.
> ...
> > Afaics a simple pre-calculated lookup table with 32 entries should do
> > the job. At least for the cut-off frequency.
> 
> That's possible, since you need only 32 precomputed entries, rather than
> continuous values. That would be much better too, without any runtime
> overheads. Just the table needs to be done nice.

Now I found some time to come back to this issue,

I prepared a small patch to set the cutoff according to Manu's formula.
The calculation is simple enough for integer arithmetic, so it is not
worth to prepare a lookup-table.

@ldvb:
Please test and report whether it works for you.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_tsn/H7LDvkge72y
Content-Type: text/x-diff;
  charset="us-ascii";
  name="tda826x_cutoff.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tda826x_cutoff.diff"

diff -r 8f1c4ba078eb linux/drivers/media/dvb/frontends/tda826x.c
--- a/linux/drivers/media/dvb/frontends/tda826x.c	Wed Mar 26 17:41:21 2008 +0100
+++ b/linux/drivers/media/dvb/frontends/tda826x.c	Thu Apr 10 22:17:48 2008 +0200
@@ -76,12 +76,23 @@ static int tda826x_set_params(struct dvb
 	struct tda826x_priv *priv = fe->tuner_priv;
 	int ret;
 	u32 div;
+	u32 ksyms;
+	u32 bandwidth;
 	u8 buf [11];
 	struct i2c_msg msg = { .addr = priv->i2c_address, .flags = 0, .buf = buf, .len = 11 };
 
 	dprintk("%s:\n", __FUNCTION__);
 
 	div = (params->frequency + (1000-1)) / 1000;
+
+	/* BW = (1 + RO) * SR/2 + 5) * 1.3      [SR in MSPS, BW in MHz] */
+	/* with R0 = 0.35 and some transformations: */
+	ksyms = params->u.qpsk.symbol_rate / 1000;
+	bandwidth = (878 * ksyms + 6500000) / 1000000 + 1;
+	if (bandwidth < 5)
+		bandwidth = 5;
+	else if (bandwidth > 36)
+		bandwidth = 36;
 
 	buf[0] = 0x00; // subaddress
 	buf[1] = 0x09; // powerdown RSSI + the magic value 1
@@ -90,7 +101,7 @@ static int tda826x_set_params(struct dvb
 	buf[2] = (1<<5) | 0x0b; // 1Mhz + 0.45 VCO
 	buf[3] = div >> 7;
 	buf[4] = div << 1;
-	buf[5] = 0x77; // baseband cut-off 19 MHz
+	buf[5] = ((bandwidth - 5) << 3) | 7; /* baseband cut-off */
 	buf[6] = 0xfe; // baseband gain 9 db + no RF attenuation
 	buf[7] = 0x83; // charge pumps at high, tests off
 	buf[8] = 0x80; // recommended value 4 for AMPVCO + disable ports.

--Boundary-00=_tsn/H7LDvkge72y
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_tsn/H7LDvkge72y--
