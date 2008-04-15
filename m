Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JlZFy-0002fe-4B
	for linux-dvb@linuxtv.org; Tue, 15 Apr 2008 02:42:43 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: timf <timf@iinet.net.au>
In-Reply-To: <480365DC.3030901@iinet.net.au>
References: <47FE3ECC.8020209@iinet.net.au>	<47FE8FD1.3050004@t-online.de>
	<1207870241.17744.8.camel@pc08.localdom.local>
	<47FFA5C5.7000704@iinet.net.au>	<47FFE2CC.3090405@t-online.de>
	<4801A18D.3090401@iinet.net.au>	<4801BD4D.7090708@iinet.net.au>
	<48022CB7.1040006@iinet.net.au> <48023E17.1070103@iinet.net.au>
	<4802576F.1070106@t-online.de> <48025E28.8020704@iinet.net.au>
	<48026BBB.5030201@t-online.de> <48027653.1000001@iinet.net.au>
	<48027E03.5010704@t-online.de> <48028513.5010208@iinet.net.au>
	<48028EF9.6030209@t-online.de>  <480365DC.3030901@iinet.net.au>
Date: Tue, 15 Apr 2008 02:42:30 +0200
Message-Id: <1208220150.3446.5.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Am Montag, den 14.04.2008, 22:10 +0800 schrieb timf:
> Hartmut Hackmann wrote:
> > Hi
> > <snip>
> Just to be sure:
> > - you are aware that you can't use analog and dvb simultanously?
> > - you are aware that after stopping a dvb application it takes about a
> >   second before the dvb driver releases the card and the analog tuner 
> > can be used?
> > - did you mix up the antenna inputs?
> >
> > Hartmut
> >
> 
> OK, start completely new again.
> 
> This is exactly as it was when I asked for your help:
> need to start analog-tv before can use dvb-t
> 
> timf@ubuntu:~$ hg clone http://linuxtv.org/hg/v4l-dvb
> timf@ubuntu:~$ cd v4l-dvb
> timf@ubuntu:~$ make
> timf@ubuntu:~$ sudo make install
> 
> -> shutdown
> -> power-cycle (1 hour no power)
> 
> timf@ubuntu:~$ sudo -s -H
> root@ubuntu:/home/timf# tzap -r "TEN HD"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 788500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 000117e6 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 0000 | ber 00011902 | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 00012076 | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 000120d6 | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 00011abe | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 0000 | ber 00011938 | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 0001198a | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 01 | signal ffff | snr 0000 | ber 00011e5c | unc ffffffff |
> status 1f | signal ffff | snr 0000 | ber 00011a14 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 0000 | ber 00011962 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 0000 | ber 00011cf4 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 0000 | ber 00011906 | unc ffffffff | 
> FE_HAS_LOCK
> status 00 | signal ffff | snr 0000 | ber 0001fffe | unc 00000000 |
> status 1f | signal ffff | snr 0000 | ber 000118f2 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal ffff | snr 3030 | ber 00013348 | unc ffffffff | 
> FE_HAS_LOCK
> 
> -> start tvtime -> viewing SBS -> stop tvtime
> 
> root@ubuntu:/home/timf# tzap -r "TEN HD"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 788500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal 9b9b | snr 6060 | ber 0001fffe | unc 00000000 |
> status 1f | signal 9b9b | snr fdfd | ber 00000248 | unc ffffffff | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 00000294 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 000002f6 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 000002a0 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 00000264 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 0000024a | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 0000027a | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 0000020c | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9a9a | snr fefe | ber 00000218 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9b9b | snr fefe | ber 000001c6 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9b9b | snr fefe | ber 00000188 | unc 00000000 | 
> FE_HAS_LOCK
> 
> 
> Regards,
> Tim


Hi,

I have no idea yet, same goes for Frederic reporting the same kernel
2.6.24 once working and after a distribution upgrade not anymore.

For sure the gpio antenna and mode switching for me works on both type
of cards.

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[0]/dvb: setting GPIO21 to 0 (TV antenna?)
saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[1]/dvb: setting GPIO21 to 1 (Radio antenna?)
saa7133[1]/dvb: setting GPIO21 to 0 (TV antenna?)
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]

saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0200000 [Radio]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0200000 [Radio]
saa7133[1]: gpio: mode=0x0200000 in=0x0000000 out=0x0200000 [Radio]
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xe8000000 irq 19 registered as card -1
saa7133[1]/alsa: saa7133[1] at 0xe8001000 irq 18 registered as card -1
saa7133[2]/alsa: saa7133[2] at 0xe8002000 irq 17 registered as card -1

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
