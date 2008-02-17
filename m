Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtprelay05.ispgateway.de ([80.67.18.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hsteinhaus@gmx.de>) id 1JQqeT-0004ki-0V
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 22:02:21 +0100
Received: from [91.15.111.30] (helo=tarsonis.home)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <hsteinhaus@gmx.de>) id 1JQqeS-0002wu-7g
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 22:02:20 +0100
From: Holger Steinhaus <hsteinhaus@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 17 Feb 2008 22:02:19 +0100
References: <B9DD88E0-E3EA-4E57-BABE-5FD4E520D6F4@admin.grnet.gr>
In-Reply-To: <B9DD88E0-E3EA-4E57-BABE-5FD4E520D6F4@admin.grnet.gr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802172202.19922.hsteinhaus@gmx.de>
Subject: Re: [linux-dvb] Hauppauge WinTV-HVR4000 and DVB-S2...
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

Hi Zenon,

your patching and compilation procedure looks completely ok. The dmesg output 
looks very well, too. 

> I am working on a Debian testing/lenny system. I have tried the above
> with kernels 2.6.22 and 2.6.24. The sample kernel output on the wiki
> says 2.6.26.1. What is the minimum kernel version that must be used
> with multiproto in order for DVB-S2 to work?
I think your only problem is that you did not use a multiproto-aware client 
application. The classical szap is not able to tune any non-DVB-S channel, as 
it simply doesnt know anything about DVB-S2 and its addtional tuning 
parameters.

As an alternative to szap2, you could also try VDR 1.5.14. But beware of the 
format of the channels.conf file. It is not fully compatible with the format 
understood by szap(2) or older VDR versions. 

The kernel version should be not that critical, I'm using versions from 2.6.22 
to 2.6.24. 

Regards,
  Holger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
