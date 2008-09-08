Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Kclwi-0005QI-EV
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 20:58:45 +0200
Date: Mon, 08 Sep 2008 20:58:10 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <27703.1220885470@kewl.org>
Message-ID: <20080908185810.177440@gmx.net>
MIME-Version: 1.0
References: <20080907230956.310620@gmx.net> <20080908000941.310670@gmx.net>
	<27703.1220885470@kewl.org>
To: Darron Broad <darron@kewl.org>, linux-dvb@linuxtv.org, stoth@linuxtv.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 scratchpad patch
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

> 
> Hi
> 
> Does it work as expected or do you have a problem?

It seems to be working fine for DVB-S, DVB-S2 and DVB-T :).
I wanted a minimal diff to easily scan through what is in it and what has
changed. I wasn't sure of the status anyway so I thought I would ask.
 
> The revision is 8628. The reason that you find this patch larger than
> expected is because when I was supplied with some fixes from a fellow user
> Carlo Scarfoglio the updates were against an older tree and when
> added to a more recent tree it meant that a whole bunch of stuff which
> had been added since his patch had to be reverted.

OK, I see.

> It's a bit messy but it ought to work and has been tested to work.
> 
> If you wish to provide a cleaner more up to date multi-frontend diff
> then please go ahead, you are welcome.

I'll send you one of the smaller diffs I mentioned -- the end result is identical.
As for more up-to-date I may do but I can't promise anything.

Would you mind saying what what will happen next with it?
I.e. will it be renamed from scratchpad to mfe_latest or are you going to make
further changes. And are there any fixes or changes already in it apart from
the ones necessary to work with 2.6.26 ?

Thanks,
Hans

-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
