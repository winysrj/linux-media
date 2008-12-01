Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7FUr-0005tF-3K
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 21:35:58 +0100
Received: by ey-out-2122.google.com with SMTP id 25so1874799eya.17
	for <linux-dvb@linuxtv.org>; Mon, 01 Dec 2008 12:35:53 -0800 (PST)
Message-ID: <412bdbff0812011235y5b32291cq604df2b11a78f1ef@mail.gmail.com>
Date: Mon, 1 Dec 2008 15:35:53 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228162425.30518.1287666879@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
	<412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
	<1228162425.30518.1287666879@webmail.messagingengine.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700 remote control support fixed
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

On Mon, Dec 1, 2008 at 3:13 PM, petercarm <linuxtv@hotair.fastmail.co.uk> wrote:
> The LIRC project provides drivers for otherwise unsupported RC hardware.
>  For dvb-usb receivers it just piggybacks off the /dev/input device
> file.  No driver from LIRC is used.  The LIRC involvement is purely in
> userspace.  This is not a LIRC problem.  The problem arises whether or
> not lircd is started.

I recognize that lirc is purely in userspace, but it would be
desirable to setup a comparable environment that polls the /dev/input
device so I can attempt to reproduce the behavior locally.

That's interesting that it occurs even if lircd is not running.

> The problem is suppressed if the disable_rc_polling parameter in dvb_usb
> is set to 1 but obviously this disables all RC support.

This whole situation is suspicious since the IR polling has no
interaction with the i2c subsystem.  In fact, it no longer even uses
the same request endpoint.

Can you provide any quantitative data as to the frequency of failure
and under what circumstances this occurs?  Does it prevent tuning from
succeeding, or do you lose lock after the device is capturing?  Do you
see i2c errors when not capturing?  How often do the errors occur?
Are you unable to get tuning lock in 100% of attempts?  Are the i2c
errors always against the mt2060, or are you seeing other i2c errors
as well?

You mentioned that "The Nova-T 500 and the Nova TD USB stick are the
two dibcom devices".  I realize this, but my question was, are you
seeing failure with both of these two devices, and are these the only
two devices you see errors with?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
