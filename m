Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7FgU-0007es-IL
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 21:48:02 +0100
Received: by ey-out-2122.google.com with SMTP id 25so1877044eya.17
	for <linux-dvb@linuxtv.org>; Mon, 01 Dec 2008 12:47:55 -0800 (PST)
Message-ID: <412bdbff0812011247l600103bdn6b18bf0533b7a981@mail.gmail.com>
Date: Mon, 1 Dec 2008 15:47:54 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228164038.5106.1287670679@webmail.messagingengine.com>
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
	<1228164038.5106.1287670679@webmail.messagingengine.com>
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

On Mon, Dec 1, 2008 at 3:40 PM, petercarm <linuxtv@hotair.fastmail.co.uk> wrote:
> Hi Devin,
>
> I've just got lucky with running dmesg at the onset of the problem, so
> can see the initial messages rather than just the flood of read/write
> failures.
>
> Unfortunately I've only got it in my xterm buffer, so I've posted some
> screenshots here:
>
> http://linuxtv.hotair.fastmail.co.uk/Picture%203.jpg
> http://linuxtv.hotair.fastmail.co.uk/Picture%204.jpg
>
> It looks like it is crashing IRQ 10 which is assigned to the PCI bus.

Woah.  You didn't mention it was doing a panic.

I'm not sure what is going on there.  You're getting errors in
af9013/af9016, so it's not specific to the mt2060 like other people
were reporting issues.

I'll look at the backtrace tonight and see if I can figure out what
happened.  In the meantime, could you please update to the hg
immediately before and after the November 16th changeset and confirm
that IR change definitely caused the issue?

Thanks,

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
