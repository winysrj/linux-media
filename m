Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 27 Oct 2008 11:47:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andreas Oberritter <obi@linuxtv.org>
Message-ID: <20081027114737.1c2786e5@pedra.chehab.org>
In-Reply-To: <4905C1E0.5050107@linuxtv.org>
References: <1130eaa20810262014x1198875dldb6dec672ae16c3e@mail.gmail.com>
	<4905C1E0.5050107@linuxtv.org>
Mime-Version: 1.0
Cc: everybody <linux-dvb@linuxtv.org>, hbomb ustc <hbomb.ustc@gmail.com>
Subject: Re: [linux-dvb] How to contribute my driver code to V4L-DVB or
 Kernel
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

On Mon, 27 Oct 2008 14:28:00 +0100
Andreas Oberritter <obi@linuxtv.org> wrote:

> Hello,
> 
> hbomb ustc wrote:
> > I have written the V4L-DVB driver of DTV/ATV receiver for my company.
> > And I want to contribute the soure code of it to V4L-DVB or linux
> > kernel. Could someone tell me how to do this?  Thanks.
> 
> You can either set up a public repository, where your source code can
> be pulled from, or you can send your patches to this mailing list. If
> they are large, it might be preferrable to put them on a web server
> instead and send a link to the mailing list.
> 
> If you'd like to set up a repository on linuxtv.org, I'm sure there's
> someone out there, who can create an account for you. Mauro?

We could create an account at Linuxtv. I'm now using some tools for handling
patches that I receive. So, sending via email works fine. 

Please c/c me on the patches, especially when you think you have a version that
you think it is ready. A very good practice is to first submit an initial
version at the ML, as a RFC at the mailing list, for people to comment, before
sending them to me for merging. After having everybody happy, then you send
they to me for merge.

> Contributions to the Linux kernel require a statement that you are
> entitled to publish the source code under the terms of the license
> of Linux. Please use your real name.

Yes. The driver needs to be released at least under GPLv2 license. If you want,
you may also allow more than one licensing, like GPLv2 or later and dual BSD/GPL.

> Here are some documents that might give you some hints about proper
> submission of a driver:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/CodingStyle
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingDrivers
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches

You may also find some useful info at:

	http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

The README.patches contains the current procedures we use for V4L/DVB drivers
and points to a few other documentation inside kernel tree.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
