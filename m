Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JXT29-0008Au-0L
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 04:14:11 +0100
Received: by ti-out-0910.google.com with SMTP id y6so337064tia.13
	for <linux-dvb@linuxtv.org>; Thu, 06 Mar 2008 19:11:07 -0800 (PST)
Message-ID: <abf3e5070803061911y72643a85x69914bf39d2705c0@mail.gmail.com>
Date: Fri, 7 Mar 2008 14:11:06 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <abf3e5070803061857q7221639cp99492ef047e99a56@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803051928g645142c2id0ff2cfa9925d347@mail.gmail.com>
	<abf3e5070803061857q7221639cp99492ef047e99a56@mail.gmail.com>
Subject: Re: [linux-dvb] Leadtek Winfast DTV Dongle Gold
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

It looks like there is a driver, it's just not official yet, I'll try
that and see
what happens.

On Fri, Mar 7, 2008 at 1:57 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
> It appears that the driver is the AF9015 which is unsupported at the moment.
>  Quite a few devices appear to use this driver, is anyone planning on
>  supporting it anytime soon?
>  Looks like I'll be returning this one anyway, I'll get one that I know works.
>
>
>
>  On Thu, Mar 6, 2008 at 2:28 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
>  > I just bought a Leadtek Winfast DTV Dongle Gold, I thought it would be
>  >  the same as the DTV Dongle, but apparently it's not, it's a new model
>  >  fresh of the production line about a month ago. Of course it
>  >  doesn't work following the instructions for the older model, I even
>  >  recompiled the kernel so it would be recognised (changed the usb
>  >  id, similar to changing the 6f00 to 6f01 for the last model), and
>  >  got the firmware for the old one but it appears that it is quite different.
>  >
>  >  Does anyone have any plans for working on this one? Or can someone
>  >  give me some pointers about how all this stuff works, especially how
>  >  to get the firmware out of the windows driver or at least work
>  >  out which firmware and driver it should be using.
>  >
>  >  Jarryd.
>  >
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
