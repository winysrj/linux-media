Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ptb-relay01.plus.net ([212.159.14.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KE4NF-0003eq-Sk
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 17:36:02 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by ptb-relay01.plus.net with esmtp (Exim) id 1KE4Mi-0006bk-9A
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 16:35:28 +0100
Message-ID: <486BA03D.4040904@adslpipe.co.uk>
Date: Wed, 02 Jul 2008 16:35:25 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
References: <486A6F0F.7090507@adslpipe.co.uk> <486B9630.1080100@adslpipe.co.uk>
	<200807021712.53659.zzam@gentoo.org>
In-Reply-To: <200807021712.53659.zzam@gentoo.org>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
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

On 02/07/2008 16:12, Matthias Schwarzott wrote:

> I have no real insight into the saa7134 core, but at least my card does have a 
> memory region of 2K.

Thanks, I only have one type of card, I'll try to investigate the best 
way to programatically determine the size of the memory region and use 
that instead of a hard-coded value, then resubmit a new patch.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
