Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1LEAaI-0000PH-I8
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 23:46:11 +0100
Date: Sat, 20 Dec 2008 23:45:57 +0100
From: Artem Makhutov <artem@makhutov.org>
To: linux-dvb@linuxtv.org
Message-ID: <20081220224557.GF12059@titan.makhutov-it.de>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] How to stream DVB-S2 channels over network?
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

Hello,

I would like to stream a DVB-S2, H264 channel over my network to an STB.

I an using the TT 3200 DVB-S2 card with multiproto drivers from Igors repository.

So faar I have tried 3 different solutions:

1. Using szap2 & dvbstream

# szap2 -r -p 'ASTRA HD'
# dvbstream -udp -i 239.255.0.1 -r 1234

2. Using szap2 and VLC

# szap2 -r -p 'ASTRA HD'
and setup VLC using the GUI to read from
/dev/dvb/adapter0/dvr0 and stream to 239.255.0.1

3. Use Windows with ProgDVB and stream to 239.255.0.1

Basically only the solution using Windows is working.

The streams from linux are all broken.
The video and audio stops every 5 seconds for 1 second.

So I can imagine 2 scenarios:

1. The stb0899 driver is broken and is producing a bad stream
2. The network streaming of VLC and dvbstream is broken

Do you know any other methods to stream a DVB-S2 channel over network?

Thanks, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
