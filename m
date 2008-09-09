Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kd4av-0000wF-Hi
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 16:53:30 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6X00DKFO050X41@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 09 Sep 2008 10:52:53 -0400 (EDT)
Date: Tue, 09 Sep 2008 10:52:53 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C659C5.8000902@magma.ca>
To: Patrick Boisvenue <patrbois@magma.ca>
Message-id: <48C68DC5.1050400@linuxtv.org>
MIME-version: 1.0
References: <48C659C5.8000902@magma.ca>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

Patrick Boisvenue wrote:
> I cannot get my new HVR-1500Q to work at all even though it's recognized 
> as such.  The best I was able to figure out was it does not like the 
> eeprom.  After enabling the debug mode on tveeprom, I got the following 
> when loading cx23885:

...

> cx23885[0]: warning: unknown hauppauge model #0
> cx23885[0]: hauppauge eeprom: model=0
> cx23885[0]: cx23885 based dvb card

...

> Did a hg pull -u http://linuxtv.org/hg/v4l-dvb earlier today so running 
> off recent codebase.

Fixed it, see linuxtv.org/hg/~stoth/v4l-dvb.

Pull the topmost patch and try again, please post your results back here.

Thanks,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
