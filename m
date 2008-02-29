Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV6T2-0004aL-Fo
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 15:44:08 +0100
Received: by wr-out-0506.google.com with SMTP id 68so6103511wra.13
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 06:44:04 -0800 (PST)
Message-ID: <d9def9db0802290637k5495258n7b6cff5700d94675@mail.gmail.com>
Date: Fri, 29 Feb 2008 15:37:42 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C8163E.5030009@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C7329F.7030705@powercraft.nl> <47C7360E.9030908@powercraft.nl>
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>
	<47C73A05.2050007@powercraft.nl>
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
	<47C74DF4.6040608@powercraft.nl> <1204246336.22520.57.camel@youkaida>
	<d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>
	<47C8163E.5030009@powercraft.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Going though hell here,
	please provide how to for Pinnacle PCTV Hybrid Pro Stick 330e
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

>
>  I spent several hours again to see if I could get it working on Debian
>  sid. I got a little bit further bit still got compilation errors.
>
>  Can you please look at my attachments.
>

 CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
In file included from /home/jelle/em28xx-userspace2/em28xx.h:42,
                from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in
a function)

ok this seems to come from a cleanup patch to remove some warnings. I
reverted that change again.
Can you download em28xx-userspace2 again and try to recompile it.

thanks,
Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
