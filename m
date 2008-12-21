Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LEP6f-0003KW-Fk
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 15:16:38 +0100
Received: by ey-out-2122.google.com with SMTP id 25so169148eya.17
	for <linux-dvb@linuxtv.org>; Sun, 21 Dec 2008 06:16:30 -0800 (PST)
Date: Sun, 21 Dec 2008 15:16:18 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081221132637.GG12059@titan.makhutov-it.de>
Message-ID: <alpine.DEB.2.00.0812211444330.22383@ybpnyubfg.ybpnyqbznva>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<494E4176.2000003@verbraak.org>
	<20081221132637.GG12059@titan.makhutov-it.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
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

On Sun, 21 Dec 2008, Artem Makhutov wrote:

> I just checked it out. It looks interesing, but I need UDP streaming,
> as the STB can only receive UDP-Streams.

What sort of UDP do you need -- an RTP Transport Stream,
an RTP Program Stream, a simple raw Transport stream, or
what?

Unless you're using a different `dvbstream' than I, it
sends out RTP (partial or not) Transport Streams, with
UDP packet size equal to the TS frame size (I hacked this
to fill as much of an ethernet frame as possible).

I don't know if your `szap2' program simply sets up the
frontend to the desired frequency, or if it also sets
hardware PID filters on your card -- I've always been able
to use other utilities with bog-standard `t/szap' to work
on the entire TS.

If bandwidth is an issue, a HD H.264 stream is likely to
weigh in around 10 to 20Mbit/sec; a full S2 transport
stream is higher (DVB-S streams from Astra are on the
order of 36Mbit/sec; S2 will likely be slightly more).

Add the overhead for UDP encapsulation of the 188-byte
packets, and I wouldn't be surprised if you push close
to some hardware limits of a 100Mbit/sec network, given
the unreliable nature of UDP, and that a single dropped
or corrupt packet can appear as a video stream error.

Although, as you said, your 'Doze works, so the sum of
your hardware should be able to handle the traffic.

Something I just learned a few seconds ago, dvbstream:
-net ip:prt IP address:port combination to be followed by pids 
list. Can be repeated to generate multiple RTP streams

This will filter your ~50Mbit/sec transponder down to a
manageable size.  Be sure to specify all the PIDs for
ASTRA HD or whatever; for the DVB-S Eins Festival that
will start tomorrow (Mo) with non-upscaled 720p content
again, that should be
0  1600  -v 1601   -a 1602   1603  1606
(as arguments to standalone `dvbstream')


Just some additional things to keep in mind...


By the way, I also received some personal mail which I
don't think made it to the list, and this may be of use
to you, so I'll quote from that here, so that others may
benefit:
DUBOST Brice wrote:
``You can try mumudvb : http://mumudvb.braice.net, I think it will answer
your needs''


thankz
baz bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
