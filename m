Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7dUv-0002Af-U1
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 23:13:38 +0100
Received: by ug-out-1314.google.com with SMTP id x30so3149936ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 14:13:34 -0800 (PST)
Message-ID: <412bdbff0812021413s52ddcf3r8595b55182b798bf@mail.gmail.com>
Date: Tue, 2 Dec 2008 17:13:34 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228254543.23353.1287906941@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
	<412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
	<1228162425.30518.1287666879@webmail.messagingengine.com>
	<1228164038.5106.1287670679@webmail.messagingengine.com>
	<500CD7A3A0%linux@youmustbejoking.demon.co.uk>
	<1228239571.26312.1287857857@webmail.messagingengine.com>
	<1228254543.23353.1287906941@webmail.messagingengine.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

On Tue, Dec 2, 2008 at 4:49 PM, petercarm <linuxtv@hotair.fastmail.co.uk> wrote:
> I've been busy testing and I have an apology to make.
>
> It looks like the problem is with a riser card.  When I moved the Nova-T
> 500 to an identical VIA SP8000 in a case that allowed a direct fitting
> PCI card, the problems stabilized.
>
> This does explain why I was the only one seeing these problems.  Curious
> that the card was stable for DVB functions if the RC polling was
> disabled.  I will amend the wiki to make sure it reflects the current
> status of the driver.

Well, I'm just breathing a sigh of relief - I had no idea how I was
going to debug this issue.

My only guess is that there is probably little or no recurring traffic
on the bus when idle, but that changes with the addition of the RC
polling (requests every 50ms).

Thanks for taking the time to isolate the cause of the problem.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
