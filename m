Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JUlHS-0002QF-Kx
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 17:06:46 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
Date: Thu, 28 Feb 2008 17:06:08 +0100
References: <617be8890802270124q55872b13n5819914996312c53@mail.gmail.com>
In-Reply-To: <617be8890802270124q55872b13n5819914996312c53@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802281706.08815.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any improvements on the Avermedia DVB-S Pro (A700)?
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

On Mittwoch, 27. Februar 2008, Eduard Huguet wrote:
> Hi, Matthias
Hi Eduard!

>     I've seen that you have new patches for the card on the folder
> referenced in the wiki. Unfortunately none of them seems to work with my
> card. I'm startint to think that I'm doing something fundamentally wrong...
> But anyway, neither Kaffeine nor dvbscan seems to be able to lock to the
> satellite signal coming from the antennae (Windows can, though...).
>
For now I also dont get a lock :(
Even if I use the unchanged code that did work some time ago.

> So far I've tried all the available patches, both using use_frontend=0 and
> use_frontend=1 options in saa7134-dvb module. In neither case the card
> can't lock...
>
Same for me for now.

> Did you received my message posting the GPIO status and data from Windows
> driver? Apparently is different from what you entered in the wiki, I don't
> know why. Anyway, I tried to use my values saa7134 initialisation with no
> difference...

Yeah I got your mail, but can't interprete it. You need to tell what setting 
was used while doing the register snapshots. Like selected input 
(svideo/composite/dvb-s).

Matthias

-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
