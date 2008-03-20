Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yosemite.cellcom.com ([206.40.111.98])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Mark.Jenks@nsighttel.com>) id 1JcK5D-0005kV-EX
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 13:41:26 +0100
Received: from exchange01.Nsighttel.com (exchange01.nsighttel.com
	[10.70.91.215])
	by yosemite.cellcom.com (Postfix) with ESMTP id B4E2D4ECA1
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 06:40:44 -0600 (CST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Thu, 20 Mar 2008 07:40:44 -0500
Message-ID: <C82A808D35A16542ACB16AF56367E0580A796930@exchange01.nsighttel.com>
In-Reply-To: <27249D94-72C3-4D56-B2F6-30A497D3BFC8@gmail.com>
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com><c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com><c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com><c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com><47DE9362.4050706@linuxtv.org><C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com><47DEB5EF.8010207@linuxtv.org><C82A808D35A16542ACB16AF56367E0580A7968FF@exchange01.nsighttel.com><C82A808D35A16542ACB16AF56367E0580A796900@exchange01.nsighttel.com><1205794556.3444.12.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A79691B@exchange01.nsighttel.com><1205872663.3385.129.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A79691D@exchange01.nsighttel.com><1205876406.3385.140.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A796920@exchange01.nsighttel.com>
	<944EB4AD-46F5-45AF-B30F-E3DE14E61D68@gmail.com>
	<C82A808D35A16542ACB16AF56367E0580A79692E@exchange01.nsighttel.com>
	<1EA91EA8 -9BCA- 4E C6-ABB2-F B458830518C@gmail.com>
	<C82A808D35A16542ACB16AF56367E0580A79692F@exchange01.nsighttel.com>
	<27249D94-72C3-4D56-B2F6-30A497D3BFC8@gmail.com>
From: "Mark A Jenks" <Mark.Jenks@nsighttel.com>
To: "Jon" <jon.the.wise.gdrive@gmail.com>
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

Getting the list back into it.

Looks like this issue still exists in the latest build, at least this is
what Jon saw.

-Mark 

> -----Original Message-----
> From: Jon [mailto:jon.the.wise.gdrive@gmail.com] 
> Sent: Thursday, March 20, 2008 7:24 AM
> To: Mark A Jenks
> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, 
> taints kernel.
> 
> This is the one that is working.
>   v4l-dvb-f24051885fe9
> 
> I formatted the system between loads, so I don't remember what the  
> other ones were, but they were all pre- kernel upgrade.
> 
> On Mar 19, 2008, at 6:09 PM, Mark A Jenks wrote:
> 
> > When you extracted the tip.tar.gz, what is the foldername that was
> > created?
> >
> > That will help determine which version of v4l you downloaded.
> >
> >
> >> -----Original Message-----
> >> From: Jon [mailto:jon.the.wise.gdrive@gmail.com]
> >> Sent: Wednesday, March 19, 2008 7:50 PM
> >> To: Mark A Jenks
> >> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs,
> >> taints kernel.
> >>
> >> Version of?
> >> I am running openSUSE 10.3. I had it updated with the online repos.
> >> The kernel was 2.6.22.
> >>
> >> I tried various v4l driver releases (just from the web interface,
> >> downloaded the bz2) the oldest from 2 weeks ago, but it was the
> >> current (3/15 I think ~12pm) release that started all my troubles,
> >> and this morning I downloaded the latest again, and along with the
> >> kernel update all is well.
> >>
> >> ~Jon
> >>
> >> On Mar 19, 2008, at 5:33 PM, Mark A Jenks wrote:
> >>
> >>> Which version did you load?
> >>>
> >>>> -----Original Message-----
> >>>> From: linux-dvb-bounces@linuxtv.org
> >>>> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Jon
> >>>> Sent: Wednesday, March 19, 2008 7:05 PM
> >>>> To: linux-dvb
> >>>> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs,
> >>>> taints kernel.
> >>>>
> >>>>>>
> >>>>>>> -----Original Message-----
> >>>>>>> From: hermann pitton [mailto:hermann-pitton@arcor.de]
> >>>>>>> Sent: Monday, March 17, 2008 5:56 PM
> >>>>>>> To: Mark A Jenks
> >>>>>>> Cc: Steven Toth; linux-dvb
> >>>>>>> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan 
> hangs, taints
> >>>>>> kernel.
> >>>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> Am Montag, den 17.03.2008, 14:05 -0500 schrieb Mark A Jenks:
> >>>>>>>> SUCCESS!
> >>>>>>>>
> >>>>>>>> Built 2.6.24-3 and installed it.  Recompiled CVS, 
> and installed
> >>>>> it.
> >>>>>>>>
> >>>>>>>> Now it doesn't hang when it finds a signal.
> >>>>>>>>
> >>>>>>>> -Mark
> >>>>>>>
> >>>>>>> Steve, the noise was not without reason.
> >>>>>>>
> >>>>>>> You might see, that all your drivers within and out of
> >>>> the kernel
> >>>>>>> have
> >>>>>>> been broken. Not to make any noise then, seems to me 
> not a good
> >>>>>>> idea.
> >>>>>>>
> >>>>>>> Also, on LKML was some stuff, that there is a general problem
> >>>>>>> initializing PCI devices multiple times and eventually have
> >>>>>>> problems on
> >>>>>>> shutdown/suspend then. But to late for the recent -rc.
> >>>>>>>
> >>>>>>> So, as it stands, given that we are not that backward 
> compatible
> >>>>>>> as have
> >>>>>>> been previously anymore, to know that this change to 
> 2.6.24 did
> >>>>>>> anything
> >>>>>>> usefull, what I doubt, would be not bad to have in details.
> >>>>>>>
> >>>>>>> Cheers,
> >>>>>>> Hermann
> >>>>>>>
> >>>>
> >>>> FWIW, compiling the 2.6.24-3 kernel also solved my issue 
> with (dvb)
> >>>> scan hanging. As noted in previous messages, I have a fresh 10.3
> >>>> install of suse, updated everything and installed the latest
> >>>> v4l-dvb.
> >>>> Every time I scanned for channels, it'd hang as soon as it
> >>>> found one,
> >>>> and wouldn't release the card or the process (not even 
> if I killed
> >>>> it). After doing yet another fresh install, and then building the
> >>>> 2.6.24 (as opposed to the 2.6.22 incldued with suse) kernel, scan
> >>>> worked fine, and resulted in finding all my available channels.
> >>>>
> >>>>
> >>>>
> >>>> _______________________________________________
> >>>> linux-dvb mailing list
> >>>> linux-dvb@linuxtv.org
> >>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>>
> >>
> >>
> 
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
