Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JUzeE-0005DO-Pq
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 08:27:15 +0100
Received: by wr-out-0506.google.com with SMTP id 68so5820210wra.13
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 23:27:10 -0800 (PST)
Message-ID: <d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>
Date: Fri, 29 Feb 2008 08:27:09 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1204246336.22520.57.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C7329F.7030705@powercraft.nl> <47C73457.1030901@powercraft.nl>
	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>
	<47C7360E.9030908@powercraft.nl>
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>
	<47C73A05.2050007@powercraft.nl>
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
	<47C74DF4.6040608@powercraft.nl> <1204246336.22520.57.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

On 2/29/08, Nicolas Will <nico@youplala.net> wrote:
> hmmm...
>
> guys.
>
> First thing: on a Debian or Ubuntu system, I never needed the full Linux
> sources to compile a v4l-dvb tree. The headers were always enough.
>
> Second thing: when you compile a v4l-dvb tree on the side, I do not
> think that it is adding anything in the headers.
> So, if you subsequently need to compile a driver that needs stuff from a
> recent v4l-dvb tree, it won't find it.
>
> Third thing: That weird driver of yours is probably looking for its
> stuff either int the headers (were there will not be anything good to
> find because of the point made above) or in an available kernel source
> tree (where it will probably not find anything that will make it happy
> because your recent v4l-dvb tree is elsewhere).
>
> May I suggest to get a kernel source tree (from the appropriate
> package), incorporate the v4l-dvb tree in it, then try to compile your
> weird driver against this.
>
> Getting rid of the headers may help.
>

When you compile the v4l-dvb or v4l-dvb-experimental tree it will
update your whole v4l and dvb subsystem.
As soon as you do so it won't work to install any other external media
drivers anymore, beside that v4l-dvb is much bigger than the snipped
out em28xx driver.
em28xx-userspace2 and userspace-drivers only contains the drivers for
em28xx based devices and won't affect any other drivers on the system.
Since the uvc driver is also out of tree it won't break
compiling/using the uvc driver against the current running kernel.

The kernel sources are needed because some internal headers are needed
for the em28xx to build an alternative tuning system for hybrid
radio/analogue TV/DTV devices. It should work flawlessly with older
kernel releases where v4l-dvb already fails to compile.

It's also easier to keep backward compatibility while not breaking any
other drivers on the system that way (and this is seriously needed)

Beside all that:
There's a .deb package available I posted the link very early already
compiling from source can always introduce some mess so you better
know what you do otherwise you have to learn how it works...
The build scripts already do alot work there for several different distributions

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
