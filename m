Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KesjR-0000ra-0H
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 16:37:46 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K76008BBWLV2250@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:37:08 -0400 (EDT)
Date: Sun, 14 Sep 2008 10:37:07 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <516169.32534.qm@web28413.mail.ukl.yahoo.com>
To: horuljo@yahoo.de
Message-id: <48CD2193.2000106@linuxtv.org>
MIME-version: 1.0
References: <516169.32534.qm@web28413.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kernel integration of rtl2831u driver
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

Peter Mayer wrote:
> Hi,
> 
> i own a Freecom rev 4 DVB-T USB-stick using a rtl2831u chip inside. Since about February this year, drivers for that stick are available and a lot of discussion about the driver was done on this list. 
> 
> But it seems for quite some time that no further discussion happens anymore.. I am using debian SID (sidux) and the actual kernel there (2.6.26-5.slh.4-sidux-686) from some days ago still does not include the rtl2831u dvb-t driver. So, I wonder now what the next steps are to make this driver available in the linux kernel, and when it will probably happen.
> 
> Background of my question is that I would like to use the stick of course, but without patching and compiling a new kernel from source by myself.
> 
> So, what is the future plan of rtl2831u for kernel integration? I am not familiar with the standard procedure of the diffusion process into mainstream kernel versions, so I would appreciate any comments on this topic.

This has been on and off the mailing list since Jan.

I gather the tree has some significant merge issues, that's probably why 
it hasn't been merged. Generally if the drivers are legally clean, code 
clean they get merged in a couple of weeks.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
