Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1LHfwR-0007xv-65
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 15:51:32 +0100
Received: from [192.168.1.116] (79.32.6.6) by relay-pt3.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 4959650100003BCD for linux-dvb@linuxtv.org;
	Tue, 30 Dec 2008 15:51:26 +0100
From: Nico Sabbi <nicola.sabbi@poste.it>
To: linux-dvb@linuxtv.org
In-Reply-To: <alpine.DEB.2.00.0812211444330.22383@ybpnyubfg.ybpnyqbznva>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<494E4176.2000003@verbraak.org>
	<20081221132637.GG12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812211444330.22383@ybpnyubfg.ybpnyqbznva>
Date: Tue, 30 Dec 2008 15:45:50 +0100
Message-Id: <1230648350.3863.3.camel@linux-wcrt.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
Reply-To: nicola.sabbi@poste.it
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

Il giorno dom, 21/12/2008 alle 15.16 +0100, BOUWSMA Barry ha scritto:
> On Sun, 21 Dec 2008, Artem Makhutov wrote:
> 
> > I just checked it out. It looks interesing, but I need UDP streaming,
> > as the STB can only receive UDP-Streams.
> 
> What sort of UDP do you need -- an RTP Transport Stream,
> an RTP Program Stream, a simple raw Transport stream, or
> what?
> 
> Unless you're using a different `dvbstream' than I, it
> sends out RTP (partial or not) Transport Streams, with
> UDP packet size equal to the TS frame size (I hacked this
> to fill as much of an ethernet frame as possible).

-udp sends plain UDP packets with ~1500 bytes of payload




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
