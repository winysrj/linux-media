Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1JSqwg-0005h9-LW
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 10:45:26 +0100
Received: from xp.homenet.telecomitalia.it (87.10.62.240) by
	relay-pt2.poste.it (7.3.122) (authenticated as Nicola.Sabbi@poste.it)
	id 47BF6249000033A0 for linux-dvb@linuxtv.org;
	Sat, 23 Feb 2008 10:45:22 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Feb 2008 10:39:33 +0100
References: <47BFBA0D.2080607@shikadi.net>
In-Reply-To: <47BFBA0D.2080607@shikadi.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802231039.33642.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] How do you stream the entire MPEG-TS with dvbstream?
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

Il Saturday 23 February 2008 07:15:41 Adam Nielsen ha scritto:
> Hi everyone,
> 
> I've just installed a new DViCO FusionHDTV dual digital 4 (which appears
> to the PC as two USB "Zarlink ZL10353 DVB-T" devices.)
> 
> I'm trying to set up dvbstream to send the whole transport stream across
> the network to another PC, but I can't get this to work.  If I do
> something like this:
> 
>   dvbstream -f 226500 -gi 16 -bw 7 512 650
> 
> Then it works fine, I get video and audio on the other PC and about
> 500kB/sec network use, but if I do this:
> 
>   dvbstream -f 226500 -gi 16 -bw 7 8192
> 
> Then the network use goes up to 1.7MB/sec but the picture and sound
> arrive corrupted, as if I have extremely bad reception.
> 
> Using an old version of dvbstream with a Hauppauge Nova-T this works
> fine, except in that case I have 3MB/sec of network traffic with the
> same channel.  It's almost as if the latest version of dvbstream doesn't
> correctly capture the whole MPEG-TS stream from the card.
> 
> Has anyone else gotten this to work?
> 
> Thanks,
> Adam.


with the same drivers and a different version of dvbstream?
In any case you should always try a fresh cvs checkout of dvbstream.
A simple test you should run  is this:

 dvbstream -f 226500 -gi 16 -bw 7 -o 8192 > dump.ts
and try to play the dump.ts from another terminal. If you see corruptions
then report back, please.
P.S. 1.7 and 3 MB/s are really low bandwidth usage that shouldn't cause any 
trouble


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
