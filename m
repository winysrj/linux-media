Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JopGf-00082j-GV
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 02:24:54 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZS0076YZSEMQJ0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 23 Apr 2008 20:24:16 -0400 (EDT)
Date: Wed, 23 Apr 2008 20:24:14 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <eff910420804231521g202e0fdbi970e0970298781ce@mail.gmail.com>
To: Michael Granda <microvon@bu.edu>
Message-id: <480FD32E.5060105@linuxtv.org>
MIME-version: 1.0
References: <eff910420804231320x495a6d88h55af7f1c14d38a00@mail.gmail.com>
	<eff910420804231323l7b956fe4g94791bf9944fe9f1@mail.gmail.com>
	<480FA292.60603@linuxtv.org>
	<eff910420804231521g202e0fdbi970e0970298781ce@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HP Analog TV Tuner
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

Michael Granda wrote:
> The card shows up on the USB bus. Here is the output of lsusb -v for the 
> card:
> 


...

> 
> 
> On Wed, Apr 23, 2008 at 4:56 PM, Steven Toth <stoth@linuxtv.org 
> <mailto:stoth@linuxtv.org>> wrote:
> 
>     Michael Granda wrote:
> 
>         My HP Pavillion dv5000 laptop came with an "HP Analog TV Tuner."
>         I've been searching endlessly for any support for it, or the
>         supposed OEM supplier model, the Yuan EC680. The tuner is an
>         XCeive 2028, and I've noticed that it interfaces with the
>         computer as a USB device, despite being an ExpressCard device.
>         I've also given the development tuner-xc2028 module a try, and
>         still no luck. Does anyone have any idea how to get this working
>         in Linux?
> 
> 
>     You stand a reasonably good change that the HVR1500 driver will just
>     work with the current repo.
> 
>     Show us the lspci -vn output to be sure.

Nope, bad luck, we don't have a driver for that.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
