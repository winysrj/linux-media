Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48B95633.8070201@linuxtv.org>
Date: Sat, 30 Aug 2008 16:16:19 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48B8400A.9030409@linuxtv.org>
In-Reply-To: <48B8400A.9030409@linuxtv.org>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Steven Toth wrote:
> If you feel that you want to support our movement then please help us by
> acking this email.

In general, I like your proposal.

Acked-by: Andreas Oberritter <obi@linuxtv.org>

Regarding the code:
1) What's TV_SEQ_CONTINUE good for? It seems to be unused.

2) Like Christophe I'd prefer to use DTV_ and dtv_ prefixes.

3) Did you mean p.u.qam.modulation below? Also, p.u.qam.fec_inner is
missing.

+		printk("%s() Preparing QAM req\n", __FUNCTION__);
+		/* TODO: Insert sanity code to validate a little. */
+		p.frequency = c->frequency;
+		p.inversion = c->inversion;
+		p.u.qam.symbol_rate = c->symbol_rate;		
+		p.u.vsb.modulation = c->modulation;

4) About enum tv_cmd_types:

SYMBOLRATE -> SYMBOL_RATE?
INNERFEC -> INNER_FEC (or FEC)?

The Tone Burst command got lost (FE_DISEQC_SEND_BURST). How about
TV_SET_TONE_BURST?

FE_ENABLE_HIGH_LNB_VOLTAGE got lost, too.

Which old ioctls should be considered as obsolete? Do you plan to add a
tv_cmd for every old ioctl?

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
