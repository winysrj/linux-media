Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JV6w0-00081S-HF
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 16:14:04 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JX000LR6AABYB10@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 29 Feb 2008 10:13:24 -0500 (EST)
Date: Fri, 29 Feb 2008 10:13:22 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <9c21eeae0802282219r4280de1ex6d47a5be2759fb52@mail.gmail.com>
To: David Brown <dmlb2000@gmail.com>
Message-id: <47C82112.3080404@linuxtv.org>
MIME-version: 1.0
References: <9c21eeae0802282219r4280de1ex6d47a5be2759fb52@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx23885 status?
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


> I also know of this repository
> http://linuxtv.org/hg/~stoth/cx23885-video. However, it hasn't changed
> in a month either. What is the state of the driver? will it be
> considered for integration in to 2.6.25? or 2.6.26? has it been
> dropped all together?

Dropped? No, I just hasn't changed in a month.

~stoth/cx23885-video is my primary repository.

Mauro nack'd by last pull request for merge, he wants to see some ioctl 
changes before he merged into master. I'm busy on other projects so I 
just don't have the time to work on it right now. My suggestion is that 
you use the cx23885-video tree.

All patches welcome, just submit them to this list.

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
