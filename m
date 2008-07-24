Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from beefcafe.de ([217.172.188.96] helo=hamburg096.server4you.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <markus@beefcafe.de>) id 1KM5uZ-00068B-Ua
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 20:51:36 +0200
Received: from dslb-084-063-061-083.pools.arcor-ip.net ([84.63.61.83]
	helo=[192.168.1.100]) by hamburg096.server4you.de with esmtpsa
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.63)
	(envelope-from <markus@beefcafe.de>) id 1KM5uS-0004Fg-Ef
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 20:51:31 +0200
Message-ID: <4888CF31.4010203@beefcafe.de>
Date: Thu, 24 Jul 2008 20:51:29 +0200
From: Markus Schneider <markus@beefcafe.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
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

Hello Marko,

I am also experiencing freezes that are caused by my TerraTec Cinergy
DVB-C. On my box this only happens during channel scanning, not when
viewing or switching channels. Still, it's quite annoying as scanning
crashes very often and I never managed to get a full channel list  :-( 

It's good to see that someone is working on the instabilities. I applied
you're patch, but unfortunately it didn't work for me  :-( 

Is there anything else that I can try? Do you have any ideas how to find
the reason for the crashes?

Best regards,
Markus


> > Here is a patch that implements the mentioned DMA transfer improvements.
> > I hope that these contain also the needed fix for you.
> > You can apply it into jusst.de/mantis Mercurial branch.
> > It modifies linux/drivers/media/dvb/mantis/mantis_dma.c only.
> > I have compiled the patch against 2.6.25.9-76.fc9.x86_64.
> >
> > cd mantis
> > patch -p1 < mantis_dma.c.aligned_dma_trs.patch
> >
> > Please tell us whether my patch helps you or not: if it helps, some of 
> > my patch might get into jusst.de as
> > a fix for your problem.
> >
> >
> >   
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
