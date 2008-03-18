Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Mark A Jenks <Mark.Jenks@nsighttel.com>
In-Reply-To: <C82A808D35A16542ACB16AF56367E0580A79691D@exchange01.nsighttel.com>
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com>
	<c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com>
	<c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com>
	<c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com>
	<47DE9362.4050706@linuxtv.org>
	<C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com>
	<47DEB5EF.8010207@linuxtv.org>
	<C82A808D35A16542ACB16AF56367E0580A7968FF@exchange01.nsighttel.com>
	<C82A808D35A16542ACB16AF56367E0580A796900@exchange01.nsighttel.com>
	<1205794556.3444.12.camel@pc08.localdom.local>
	<C82A808D35A16542ACB16AF56367E0580A79691B@exchange01.nsighttel.com>
	<1205872663.3385.129.camel@pc08.localdom.local>
	<C82A808D35A16542ACB16AF56367E0580A79691D@exchange01.nsighttel.com>
Date: Tue, 18 Mar 2008 22:40:06 +0100
Message-Id: <1205876406.3385.140.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
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

Am Dienstag, den 18.03.2008, 16:02 -0500 schrieb Mark A Jenks:
> I don't see an hg on my system.  Where would I find it to check?
> 
> The CVS that I grabbed that did not work, until I updated to 2.6.24 was
> dated Mar 17th, 11:39AM CST.
> 
> -Mark

Ah, Mauro might have pulled from some other of his repos, so I'm not
sure if the date the fix has in v4l-dvb master is correct for when it
actually arrived there.

To use the "hg" commands you have to install "mercurial" which almost
all distros should provide.

Thanks for looking further into it,

Hermann

> -----Original Message-----
> From: hermann pitton [mailto:hermann-pitton@arcor.de] 
> Sent: Tuesday, March 18, 2008 3:38 PM
> To: Mark A Jenks
> Cc: Steven Toth; linux-dvb
> Subject: RE: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
> 
> Am Dienstag, den 18.03.2008, 12:41 -0500 schrieb Mark A Jenks:
> > I put a comment about having to install a new kernel if dvbscan hangs
> in
> > the WIKI.
> > 
> > -Mark  
> 
> Hi Mark,
> 
> for all other reports we have, it is not about to install 2.6.24.
> 
> It was broken in mercurial for some days and is fixed there for now.
> http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024575.html
> 
> Since you used previously v4l-dvb master and now again, you should check
> if you have changeset 7374. ("hg log > hg.log" - "hg export 7374")
> Risc memory did still hold PCI specific stuff directly, going back
> before this fix, you will have the problems again.
> 
> Cheers,
> Hermann
> 
> > -----Original Message-----
> > From: hermann pitton [mailto:hermann-pitton@arcor.de] 
> > Sent: Monday, March 17, 2008 5:56 PM
> > To: Mark A Jenks
> > Cc: Steven Toth; linux-dvb
> > Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints
> kernel.
> > 
> > Hi,
> > 
> > Am Montag, den 17.03.2008, 14:05 -0500 schrieb Mark A Jenks:
> > > SUCCESS!
> > > 
> > > Built 2.6.24-3 and installed it.  Recompiled CVS, and installed it.
> > > 
> > > Now it doesn't hang when it finds a signal.
> > > 
> > > -Mark 
> > 
> > Steve, the noise was not without reason.
> > 
> > You might see, that all your drivers within and out of the kernel have
> > been broken. Not to make any noise then, seems to me not a good idea.
> > 
> > Also, on LKML was some stuff, that there is a general problem
> > initializing PCI devices multiple times and eventually have problems
> on
> > shutdown/suspend then. But to late for the recent -rc.
> > 
> > So, as it stands, given that we are not that backward compatible as
> have
> > been previously anymore, to know that this change to 2.6.24 did
> anything
> > usefull, what I doubt, would be not bad to have in details.
> > 
> > Cheers,
> > Hermann 
> > 
> > 
> > > -----Original Message-----
> > > From: linux-dvb-bounces@linuxtv.org
> > > [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Mark A Jenks
> > > Sent: Monday, March 17, 2008 1:28 PM
> > > To: Steven Toth; linux-dvb
> > > Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints
> > kernel.
> > > 
> > > I'm compiling 2.4.24 right now to test it.
> > > 
> > > I've been running this box for over a year with a TV2000 card
> without
> > > issues.  I was just trying to upgrade into DTV.
> > > 
> > > So, I really don't think it's a memory issue.
> > > 
> > > The TV2000 was a pci, this is my first pcie card I'm using in this
> > box.
> > > 
> > > -Mark 
> > > 
> > > -----Original Message-----
> > > From: Steven Toth [mailto:stoth@linuxtv.org] 
> > > Sent: Monday, March 17, 2008 1:18 PM
> > > To: Mark A Jenks; linux-dvb
> > > Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints
> > kernel.
> > > 
> > > CC'ing the mailing list back in.
> > > 
> > > Mark A Jenks wrote:
> > > > Do you think I should push the kernel to 2.6.25? 
> > > 
> > > I maintain the driver on ubuntu 7.10, which I think has is 2.6.22-14
> -
> > 
> > > or close to.
> > > 
> > > I have another AMD system at home that the driver completely freezes
> > on,
> > > 
> > > no idea why, total system lockup. I don't trust the PCIe chipset on
> > it, 
> > > it's an early chipset and a little flakey.
> > > 
> > > Other than that the driver's been pretty reliable.
> > > 
> > > Lots of noise recently on the mailing lists about video_buf related 
> > > issues and potential race conditions.
> > > 
> > > Try running the system with a single cpu core and report back, also,
> 
> > > just for the hell of it, run memtest also.
> > > 
> > > - Steve
> > > 
> > 
> > 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
