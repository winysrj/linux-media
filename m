Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KuWJ7-0003BU-Ox
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 18:55:15 +0100
Received: by ey-out-2122.google.com with SMTP id 25so900985eya.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Oct 2008 10:55:10 -0700 (PDT)
Date: Mon, 27 Oct 2008 18:54:51 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0810261537420.8807@pub2.ifh.de>
Message-ID: <alpine.DEB.2.00.0810271752490.29514@ybpnyubfg.ybpnyqbznva>
References: <200810251101.11569@centrum.cz> <200810251102.1298@centrum.cz>
	<200810251103.27574@centrum.cz> <200810251103.16869@centrum.cz>
	<alpine.LRH.1.10.0810261537420.8807@pub2.ifh.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API: Future support for DVB-T2
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

On Sun, 26 Oct 2008, Patrick Boettcher wrote:

> Adding support to the API is only part of the job. The question is which
> currently available receiver hardware is supporting DVB-T2 and where can we

Apparently the following were used at a recent demo in Amsterdam:
Tuner chip TDA18211HN, prototype demodulator TDA10055, both from
NXP.



> get a driver for this hardware?

Won't it be that some poor sucker signs away their soul for NDA
access to the specifics of the chips, or is it possible that
the chip manufacturer might deliver already-written drivers
(though looking at the existing TDAxxxxx frontend code, the
former seems most likely, and I don't know how well this one
manufacturer is generally with linux support) ?

Support for the tuner chip above seems to have been attempted
about a year ago.


The above chips might make their way into set-top-boxen in
half a year or so; whether they'd also be found eventually
in PC-cards or USB-sticks so soon is hard to say -- but
possibly by the time DVB-T2 starts for real, there may be
some other cards based on other chipsets presently on the
drawing board as well.



And speaking of chipsets used in available hardware, does
anyone know what might be used in the recently-released
Hauppauge HVR-930C, a USB 2.0 stick with DVB-C as well as
DVB-T support?


thanks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
