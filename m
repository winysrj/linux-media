Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LE5L7-0001Zd-K0
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 18:10:10 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Eric GRAMMATICO <e.grammatico@gmail.com>
In-Reply-To: <77649f260812200330g3b76fb31jb7b16c4e6a4c5443@mail.gmail.com>
References: <77649f260812200330g3b76fb31jb7b16c4e6a4c5443@mail.gmail.com>
Date: Sat, 20 Dec 2008 18:04:02 +0100
Message-Id: <1229792642.3111.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Unable to lock signal on FlyDVB-T
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

Hi,

Am Samstag, den 20.12.2008, 12:30 +0100 schrieb Eric GRAMMATICO:
> Hello All,
> 
> I am trying desperately to lock signal on a FlyDVB-T. My system is
> # uname -a
> Linux mythtv 2.6.27.5-117.fc10.i686 #1 SMP Tue Nov 18 12:19:59 EST
> 2008 i686 athlon i386 GNU/Linux
> 
> It's like there is no data coming from... But my TV set is able to lock...
> 
> I left all interesting information on
> http://e.grammatico.free.fr/linuxDVB/
> 
> Any help is very welcome,
> 

there is a slight chance that the transmitter uses a positive offset of
about 167000Hz. It is quite common in France and the tda10046 can't find
this on its own.

Modify the initial scan file like this.

#### Cannes - Vallauris ####
#R1
T 490167000 8MHz AUTO NONE QAM64 8k AUTO NONE
#R2
T 514167000 8MHz AUTO NONE QAM64 8k AUTO NONE
#R3
T 578167000 8MHz AUTO NONE QAM64 8k AUTO NONE
#R4
T 730167000 8MHz AUTO NONE QAM64 8k AUTO NONE
#R5
T 690167000 8MHz AUTO NONE QAM64 8k AUTO NONE
#R6
T 642167000 8MHz AUTO NONE QAM64 8k AUTO NONE

Copy and paste and try with "scan" again.

Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
