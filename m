Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JMRso-0005KF-E6
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 18:46:58 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JVS009UD1DD2H60@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 05 Feb 2008 12:46:27 -0500 (EST)
Date: Tue, 05 Feb 2008 12:46:24 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <5c080cd10802050804i3cb8e2b4saebb8aee7fd2ca1c@mail.gmail.com>
To: Stanley burghardt <stburghardt@gmail.com>
Message-id: <47A8A0F0.6090201@linuxtv.org>
MIME-version: 1.0
References: <5c080cd10802050804i3cb8e2b4saebb8aee7fd2ca1c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1600
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Stanley burghardt wrote:
> I got this card and compiled latest cx18 drivers and get it recognized 
> by linux. Now are there any patches for it so it can be recognized as 
> event interface for remote ? I belive it should be realy simple patch. 
> What values need to be added to drivers in order for  event interface be 
> recognized ?

This has the Zilog IR Blaster on board, which is already supported in 
some of the ivtv drivers via lirc (iirc).

Try googling for PVR150/500 + IRBlaster + Linux, this will likely lead 
to the same solution.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
