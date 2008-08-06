Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mythdev@telfort.nl>) id 1KQnT3-0005zc-4g
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 20:10:39 +0200
Received: from [82.170.13.196] (helo=daan.geda)
	by smtp-out3.tiscali.nl with esmtp id 1KQnSz-0003fI-TV
	for <linux-dvb@linuxtv.org>; Wed, 06 Aug 2008 20:10:33 +0200
To: linux-dvb@linuxtv.org
Content-Disposition: inline
From: Daan de Beer <mythdev@telfort.nl>
Date: Wed, 6 Aug 2008 20:10:33 +0200
MIME-Version: 1.0
Message-Id: <200808062010.33375.mythdev@telfort.nl>
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C PCI and the driver mantis
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

> Date: 2008-07-21 21:15:38 GMT (2 weeks, 1 day, 20 hours and 47 minutes ago)
>
> oscar perez wrote:
> > Hi there!
> > Is the latest driver mantis working fine for the card terratec cinergy
> > C DVB-C PCI. ??
> > According to the linuxtv wiki it seems that the issue with scan
> > freezing is solved in the latest release..:
> >
> > http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
> >
> > I am using kernel 2.6.24-19 with the latest mantis driver and I am
> > able to install the driver with modprobe. However, when I start
> > scanning for channels it freezes and I get the problem about "Slave
> > RACK fail".
> > Anybody has got it? and more importantly. Any solution to this? :)
>
> Yea, I get those as well. It just sits there for some seconds and there
> will be a few of these lines, but in the end the card works nice.
>
> Philipp

Hello all,

I also have the TerraTec Cinergy C and it works like a charm, without the CAM 
module. With the cam module I also get the "slave RACK fail" message. The 
system becomes sort of unusable until I do a rmmod mantis. That takes very, 
very long, but it succeeds.

I use 2.6.25-gentoo-r7 as kernel on a AMD64. I tried the latest driver.

What can I do to help debug this?

Thank you!

Regards,

Daan de Beer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
