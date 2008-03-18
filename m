Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b9c06d2e3da2f0ede24a+1668+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jbbub-00051x-Oy
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 14:31:29 +0100
Date: Tue, 18 Mar 2008 10:30:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080318103044.4363fefd@gaivota>
In-Reply-To: <1205573636.5941.1.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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

On Sat, 15 Mar 2008 18:33:56 +0900
timf <timf@iinet.net.au> wrote:

> [   15.000000] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> TV/Radio (A16D) [card=137,autodetected]


> [   15.296000] tuner' 2-0061: Setting mode_mask to 0x0e
> [   15.296000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> [   15.296000] tuner' 2-0061: tuner 0x61: Tuner type absent

The above is not right. It should be using type=71 for the tuner.

I think I found the bug: the tuner addresses should be set to ADDR_UNSET,
instead of keeping it blank.

Please do an "hg pull -u" and try again, recompiling and re-installing the modules:
	hg pull -u
	make rmmod
	make
	make install
	modprobe saa7134

> 8) The chip on my card is xc3018. Why does module xc5000 load?

This is an issue on the way cards are attached, at tuner_core. Since they
directly access xc5000 code, with:

                if (!xc5000_attach(&t->fe, t->i2c->adapter, &xc5000_cfg)) {

xc5000 module will be loaded, even if not used. It shouldn't be hard to fix
this, by using the macro dvb_attach().



Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
