Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1KJS6T-0004RX-HM
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 13:57:12 +0200
Message-ID: <487F3365.4070306@chaosmedia.org>
Date: Thu, 17 Jul 2008 13:56:21 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
In-Reply-To: <3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S2-3200 driver
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



Remy Bohmer wrote:
> The two of you seem to have it working, so maybe you can give me some hints:
> What sources (what version) do I need?
>   
i use current multiproto hg sources
> What version of szap2 (and scan) should I use? and where can I find it ?
v4l dvb-apps hg has a multiproto compatible szap2 version in the test 
directory (v4l/dvb-apps/test)

you just have to set the delivery system option properly using -t 2 for 
dvb-s2

for example to tune to Eurosport HD on HB13.0E i use : ./szap2 -t 2 ESHD

with the following line in your szap channels.conf file : 
~/.szap/channels.conf

ESHD:11278:v:0:27500:3000:3201:0

you should then get some output from szap2 as follows if it tunes and 
locks :

status 1a | signal 05aa | snr 0033 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

the first :0: sets the diseqc switch position but i've had some problems 
with that an to access the second diseqc position on my 2 positions 
switch i have to set the diseqc value to something like 11111, although 
it doesn't seem to make any sense..

with szap2 you also can tune to FTA channels using the option "-p" and 
read the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with 
mplayer for example..

good luck,

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
