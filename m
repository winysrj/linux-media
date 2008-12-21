Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp08.online.nl ([194.134.42.53])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1LEO9l-0006Yq-I7
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 14:15:43 +0100
Message-ID: <494E4176.2000003@verbraak.org>
Date: Sun, 21 Dec 2008 14:15:34 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>, linux-dvb@linuxtv.org
References: <20081220224557.GF12059@titan.makhutov-it.de>
In-Reply-To: <20081220224557.GF12059@titan.makhutov-it.de>
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

Artem Makhutov schreef:
> Hello,
>
> I would like to stream a DVB-S2, H264 channel over my network to an STB.
>
> I an using the TT 3200 DVB-S2 card with multiproto drivers from Igors repository.
>
> So faar I have tried 3 different solutions:
>
> 1. Using szap2 & dvbstream
>
> # szap2 -r -p 'ASTRA HD'
> # dvbstream -udp -i 239.255.0.1 -r 1234
>
> 2. Using szap2 and VLC
>
> # szap2 -r -p 'ASTRA HD'
> and setup VLC using the GUI to read from
> /dev/dvb/adapter0/dvr0 and stream to 239.255.0.1
>
> 3. Use Windows with ProgDVB and stream to 239.255.0.1
>
> Basically only the solution using Windows is working.
>
> The streams from linux are all broken.
> The video and audio stops every 5 seconds for 1 second.
>
> So I can imagine 2 scenarios:
>
> 1. The stb0899 driver is broken and is producing a bad stream
> 2. The network streaming of VLC and dvbstream is broken
>
> Do you know any other methods to stream a DVB-S2 channel over network?
>
> Thanks, Artem
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Artem,

Have a look at my tvpump program which is part of my set of programs I 
use to view livetv (http://www.verbraak.org/wiki/index.php/TVSuite).
I use ffplay to view HD content but I currently also have problems 
viewing HD content because my computer for viewing is a bit to slow.

Regards,

Michel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
