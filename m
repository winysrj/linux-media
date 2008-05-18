Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway01.websitewelcome.com ([69.93.115.19])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1Jxpss-0006q8-5I
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 22:53:35 +0200
Message-ID: <48309746.3080803@kipdola.com>
Date: Sun, 18 May 2008 22:53:26 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>, linux-dvb@linuxtv.org
References: <482CC0F0.30005@kipdola.com>	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>	<482D1AB7.3070101@kipdola.com>
	<20080518121250.7dc0eaac@bk.ru>	<482FF520.4070303@kipdola.com>	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>	<4830158C.2030309@kipdola.com>	<854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>	<483027AE.6020107@kipdola.com>
	<1211139899.3380.15.camel@palomino.walls.org>
In-Reply-To: <1211139899.3380.15.camel@palomino.walls.org>
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
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


Andy Walls schreef:
> On Sun, 2008-05-18 at 14:57 +0200, Jelle De Loecker wrote:
>   
> This "just worked" for me using mplayer with a digital video broadcast
> from my HVR-1600 with the cx18 driver (I'm in ATSC country):
>   
Apparently /dev/dvb/adapter0/dvr0 is a very sensitive "file" - when I 
directly open it using mplayer, or even cat, it won't output to anything 
else afterwards.

I'm using Faruk's solution to stream it like this:

dvbstream 8192 -i 192.168.1.2 -r 1234

and then opening that stream with VLC - which works rather well (even if I have to always manually change the frequency using szap)


By the way, I scribbled down my notes in a small tutorial on how to get 
the "old drivers" working again (using an older revision made the scan 
tool work again!) If any other beginner needs any help it can be found here:

http://skerit.kipdola.com/?p=5&language=en

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
