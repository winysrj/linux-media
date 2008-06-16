Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K8LaR-00072v-2x
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 22:46:00 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Mon, 16 Jun 2008 22:45:22 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200806161020.05437.ajurik@quick.cz>
	<200806162114.27912.joep@groovytunes.nl>
In-Reply-To: <200806162114.27912.joep@groovytunes.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806162245.22999.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : Re : Re : No lock possible at some DVB-S2
	channels with TT S2-3200/linux
Reply-To: ajurik@quick.cz
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

On Monday 16 of June 2008, joep wrote:
>
> The most important thing I can't get working is diseqc switching.
> Does anyone use Astra23,5 or hotbird13 with the multiproto driver?

I'm using multiproto with TT S2-3200 and 4-way diseqc switch (13.0E, 19.2E, 
23.5 and motor with secondary dish). No problem, but for motor I'm using 
patch in vdr (vdr-1.6.0-gotox.diff).

BR,
Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
