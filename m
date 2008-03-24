Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out28.alice.it ([85.33.2.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sarkiaponius@alice.it>) id 1Jdu92-0001JE-DS
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 22:23:55 +0100
Message-ID: <47E81B90.8060903@alice.it>
Date: Mon, 24 Mar 2008 22:22:24 +0100
From: Andrea Giuliano <sarkiaponius@alice.it>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <47E56272.8050307@alice.it>	<3cc3561f0803230425p60486919m9685f4a145df7635@mail.gmail.com>	<47E7731D.7000706@alice.it>
	<200803241027.47981.Nicola.Sabbi@poste.it>
In-Reply-To: <200803241027.47981.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help needed...
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

Nico Sabbi wrote:
> Il Monday 24 March 2008 10:23:41 Andrea Giuliano ha scritto:
>> My practical conclusion is: "11804 V" stands for "11875 H" and "11766 V" 
>> stands for "11747 H". No other way to get things working.
> 
> this sounds very much like a bug in the drivers. What card is it and what
> tuner and demodulator does it use?

My card is a KWorld DVB-S 100, sold in Italy as Empire DVB-S 100. As for 
tuner and demodulator, I'm not an expert so I can only provide this 
slice of dmesg:

cx2388x dvb driver version 0.0.6 loaded
CORE cx88[0]: subsystem: 17de:08b2, board: KWorld DVB-S 100 
[card=39,autodetected]
TV tuner 4 at 0x1fe, Radio tuner -1 at 0x1fe
cx2388x v4l2 driver version 0.0.6 loaded
irda_init()
NET: Registered protocol family 23
logips2pp: Detected unknown logitech mouse model 127
ACPI: PCI Interrupt 0000:01:02.2[A] -> GSI 23 (level, low) -> IRQ 193
cx88[0]/2: found at 0000:01:02.2, rev: 5, irq: 193, latency: 32, mmio: 
0xfd000000
cx88[0]/2: cx2388x based dvb card
DVB: registering new adapter (cx88[0]).
DVB: registering frontend 0 (Conexant CX24123/CX24109)...
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 23 (level, low) -> IRQ 193
cx88[0]/0: found at 0000:01:02.0, rev: 5, irq: 193, latency: 32, mmio: 
0xfc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
ZORAN: 1 card(s) found
DC30plus[0]: zr36057_init() - initializing card[0], zr=f8a37c60
cx2388x blackbird driver version 0.0.6 loaded

The Zoran card you see mentioned above has no DVB capabilities: it's a 
rather old MJPEG card (and a rather good one, indeed).

I hope this helps.

Best regards.

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
