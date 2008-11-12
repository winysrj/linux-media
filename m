Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L0FeD-0001VP-DZ
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 14:20:43 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1056032ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 05:20:38 -0800 (PST)
Date: Wed, 12 Nov 2008 14:20:24 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Alex Betis <alex.betis@gmail.com>
In-Reply-To: <c74595dc0811120459w430cdamf92318e39eaae88d@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0811121404280.22461@ybpnyubfg.ybpnyqbznva>
References: <20081112023112.94740@gmx.net>
	<c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
	<alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
	<c74595dc0811120408l4ef3cf92g9b1efc850e3b0b48@mail.gmail.com>
	<alpine.DEB.2.00.0811121332240.22461@ybpnyubfg.ybpnyqbznva>
	<c74595dc0811120459w430cdamf92318e39eaae88d@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

On Wed, 12 Nov 2008, Alex Betis wrote:

> > +if (tn.modulation & 0x04) {
> > +       printf("  DVB-S2");
> > +  if ((tn.modulation & 0x03) == 0x01) printf (" QPSK");
> > +  if ((tn.modulation & 0x03) == 0x02) printf (" 8PSK");

> I must be missing something... How this code is aligned to the following
> modulation enumeration?
> QPSK enumeration has value 0, 8PSK value 9.

I don't think it is; it's based on parsing the NIT tables.

Now that I look more at my code, this part of which was
hacked many months ago and which has since passed from my
conscious memory (damn you, beer, solution to and cause of
all my problems), the following code snippets appear to be
needed for context.  Sorry, I honestly can't remember what
I needed to hack into dvb-apps/scan to get this, and what
was already present but unused...

@@ -143,6 +150,7 @@
        unsigned int wrong_frequency      : 1;  /* DVB-T with other_frequency_flag */
        int n_other_f;
        uint32_t *other_f;                      /* DVB-T freqeuency-list descriptor */
+       int modulation; /* XXX HACK */
 };



@@ -433,6 +449,7 @@
                                                         buf[10],
                                                         buf[11],
                                                         buf[12] & 
0xf0);
+       t->modulation = buf[8] & 0x07;

        t->polarisation = (buf[8] >> 5) & 0x03;
        t->param.inversion = spectral_inversion;



Sorry for the omission.  Even though I did sleep twelve
hours last night, it hasn't made up for only sleeping
two to three hours nightly for the past weeks...


Unfortunately, a hex dump of the NIT data isn't so easy
to follow, but here's a short example of how `dvbsnoop'
spews out data for one select transponder from the tables:

                  Frequency: 19234969 (=  12.58099 GHz)
                  Orbital_position: 402 (=  19.2)
                  West_East_flag: 1 (0x01)  [= EAST]
                  Polarisation: 1 (0x01)  [= linear - vertical]
                  Kind: 1 (0x01)  [= DVB-S2]
                  Roll Off Faktor: 0 (0x00)  [= Alpha 0.35]
                  Modulation_type: 2 (0x02)  [= 8PSK]
                  Symbol_rate: 2228224 (=  22.0000)
                  FEC_inner: 2 (0x02)  [= 2/3 conv. code rate]


baryr bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
