Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7F9S-0003Kq-3x
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 21:13:51 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id E14011C9FF9
	for <linux-dvb@linuxtv.org>; Mon,  1 Dec 2008 15:13:45 -0500 (EST)
Message-Id: <1228162425.30518.1287666879@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "Linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
	<412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
In-Reply-To: <412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
Date: Mon, 01 Dec 2008 20:13:45 +0000
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

Just to add a bit more clarity.

The LIRC project provides drivers for otherwise unsupported RC hardware.
 For dvb-usb receivers it just piggybacks off the /dev/input device
file.  No driver from LIRC is used.  The LIRC involvement is purely in
userspace.  This is not a LIRC problem.  The problem arises whether or
not lircd is started.

The problem is suppressed if the disable_rc_polling parameter in dvb_usb
is set to 1 but obviously this disables all RC support.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
