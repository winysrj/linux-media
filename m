Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yosemite.cellcom.com ([206.40.111.98])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Mark.Jenks@nsighttel.com>) id 1Jc8j4-0005ng-As
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 01:33:49 +0100
Received: from exchange01.Nsighttel.com (exchange01.nsighttel.com
	[10.70.91.215])
	by yosemite.cellcom.com (Postfix) with ESMTP id 7527A4ECA5
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 18:33:09 -0600 (CST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 19 Mar 2008 19:33:08 -0500
Message-ID: <C82A808D35A16542ACB16AF56367E0580A79692E@exchange01.nsighttel.com>
In-Reply-To: <944EB4AD-46F5-45AF-B30F-E3DE14E61D68@gmail.com>
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com><c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com><c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com><c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com><47DE9362.4050706@linuxtv.org><C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com><47DEB5EF.8010207@linuxtv.org><C82A808D35A16542ACB16AF56367E0580A7968FF@exchange01.nsighttel.com><C82A808D35A16542ACB16AF56367E0580A796900@exchange01.nsighttel.com><1205794556.3444.12.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A79691B@exchange01.nsighttel.com><1205872663.3385.129.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A79691D@exchange01.nsighttel.com><1205876406.3385.140.camel@pc08.localdom.local><C82A808D35A16542ACB16AF56367E0580A796920@exchange01.nsighttel.com>
	<944EB4AD-46F5-45AF-B30F-E3DE14E61D68@gmail.com>
From: "Mark A Jenks" <Mark.Jenks@nsighttel.com>
To: "Jon" <jon.the.wise.gdrive@gmail.com>, "linux-dvb" <linux-dvb@linuxtv.org>
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

Which version did you load?  

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org 
> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Jon
> Sent: Wednesday, March 19, 2008 7:05 PM
> To: linux-dvb
> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, 
> taints kernel.
> 
> >>
> >>> -----Original Message-----
> >>> From: hermann pitton [mailto:hermann-pitton@arcor.de]
> >>> Sent: Monday, March 17, 2008 5:56 PM
> >>> To: Mark A Jenks
> >>> Cc: Steven Toth; linux-dvb
> >>> Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints
> >> kernel.
> >>>
> >>> Hi,
> >>>
> >>> Am Montag, den 17.03.2008, 14:05 -0500 schrieb Mark A Jenks:
> >>>> SUCCESS!
> >>>>
> >>>> Built 2.6.24-3 and installed it.  Recompiled CVS, and installed
> > it.
> >>>>
> >>>> Now it doesn't hang when it finds a signal.
> >>>>
> >>>> -Mark
> >>>
> >>> Steve, the noise was not without reason.
> >>>
> >>> You might see, that all your drivers within and out of 
> the kernel  
> >>> have
> >>> been broken. Not to make any noise then, seems to me not a good  
> >>> idea.
> >>>
> >>> Also, on LKML was some stuff, that there is a general problem
> >>> initializing PCI devices multiple times and eventually have  
> >>> problems on
> >>> shutdown/suspend then. But to late for the recent -rc.
> >>>
> >>> So, as it stands, given that we are not that backward compatible  
> >>> as have
> >>> been previously anymore, to know that this change to 2.6.24 did  
> >>> anything
> >>> usefull, what I doubt, would be not bad to have in details.
> >>>
> >>> Cheers,
> >>> Hermann
> >>>
> 
> FWIW, compiling the 2.6.24-3 kernel also solved my issue with (dvb) 
> scan hanging. As noted in previous messages, I have a fresh 10.3  
> install of suse, updated everything and installed the latest 
> v4l-dvb.  
> Every time I scanned for channels, it'd hang as soon as it 
> found one,  
> and wouldn't release the card or the process (not even if I killed  
> it). After doing yet another fresh install, and then building the  
> 2.6.24 (as opposed to the 2.6.22 incldued with suse) kernel, scan  
> worked fine, and resulted in finding all my available channels.
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
