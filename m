Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <daniel.isenmann@gmx.de>) id 1KARLg-0004hS-GU
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 17:19:25 +0200
Date: Sun, 22 Jun 2008 17:18:49 +0200
From: Daniel Isenmann <daniel.isenmann@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080622171849.6c7023fe@fuckup-ng.localdomain>
In-Reply-To: <485E6299.6030002@iki.fi>
References: <20080622161411.722de7a7@fuckup-ng.localdomain>
	<485E6299.6030002@iki.fi>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Afatech 9015 problems on i686
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

On Sun, 22 Jun 2008 17:32:57 +0300
Lauri Tischler <lwgt@iki.fi> wrote:

> Daniel Isenmann wrote:
> > Hi,
> > 
> > I have some problems to get the module af9015 to run under i686. I
> > checked out the afatech9015 development repo from here:
> > http://linuxtv.org/hg/~anttip/af9015/
> > 
> > Compiling the source on my x86_64 box, everything runs fine and
> > smooth. But under i686 there is following warning, which prevents
> > the module from loading:
> > ----------
> > WARNING:
> > "__fixdfsi" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
> > undefined! 
> > WARNING:
> > "__divdf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
> > undefined! 
> > WARNING:
> > "__adddf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
> > undefined! 
> > WARNING:
> > "__muldf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
> > undefined! 
> > WARNING:
> > "__floatsidf" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
> > undefined!
> > ----------
> > The compilation runs until the end. But loading the module fails
> > with errors, that it can't find the functions listed above. Loading
> > the firmware works on both boxes without problems.
> > 
> > GCC: 4.3.1
> > Kernel: 2.6.25.6 
> > Distribution: ArchLinux
> > 
> > Has anyone a hint or know something more, why the compiler warnings
> > appears? Complete build log with V=1 can be found here: 
> > http://dev.archlinux.org/~daniel/afatech9015-eee-hg-8102-1-i686.log
> 
> I had same errors with Mythbuntu 8.04, downloaded older tree
> http://linuxtv.org/hg/~anttip/af9015-t/
> that seems to work.

Thanks for posting this. Now it works also on i686 (great...totally
happy), but that didn't solve the main problem, that the current repo
doesn't work on i686 (at least for us).

Let me know if you (developer/maintainer of af9015) needs more
information for this topic. I will provide as much as I can.

Daniel

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
