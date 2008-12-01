Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7Ezp-0002T2-72
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 21:03:55 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 6F9971C948C
	for <linux-dvb@linuxtv.org>; Mon,  1 Dec 2008 15:03:48 -0500 (EST)
Message-Id: <1228161828.28118.1287661397@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
Date: Mon, 01 Dec 2008 20:03:48 +0000
Subject: Re: [linux-dvb] dib0700 remote control support fixed
Reply-To: linuxtv@hotair.fastmail.co.uk
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

On Mon, 1 Dec 2008 13:54:19 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> Hello Peter,
> 
> Of the devices that you have, which are the ones that are failing?
> Both of the dibcom devices?
> 
> I am not familiar with how lirc interacts with the dib0700 driver,
> since the driver polls the bulk endpoint every 50ms and injects the
> keys directly.  I will have to look at the driver and see how this
> hooks into lirc.
> 
> I suspect that most people are not using lirc at all, since the device
> works without it.  This would explain why you are the only person I
> know of still reporting these problems.
> 
> Could you please send my your lirc configuration so I can attempt to
> reproduce the issue locally?  If I can get an environment that
> reproduces the issue, I can almost certainly fix it.
> 
> Thanks,
> 
> Devin
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

The Nova-T 500 and the Nova TD USB stick are the two dibcom devices.

What output should I be getting from the remote control?  Having
previously seen RC signals coming through on /dev/input I need some
clues for where to look if things have changed.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
