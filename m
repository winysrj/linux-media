Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JZCgg-0006lo-EM
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 23:11:11 +0100
Received: from [11.11.11.138] (user-5af0e527.wfd96.dsl.pol.co.uk
	[90.240.229.39])
	by mail.youplala.net (Postfix) with ESMTP id DBD61D88130
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 23:10:08 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47D701A7.40805@philpem.me.uk>
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<47D701A7.40805@philpem.me.uk>
Date: Tue, 11 Mar 2008 22:10:04 +0000
Message-Id: <1205273404.20608.2.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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


On Tue, 2008-03-11 at 22:03 +0000, Philip Pemberton wrote:
> ivor@ivor.org wrote:
> > Not sure if this helps or adds that much to the discussion... (I
> think this was concluded before)
> > But I finally switched back to kernel 2.6.22.19 on March 5th (with
> current v4l-dvb code) and haven't had any problems with the Nova-t 500
> since. Running mythtv with EIT scanning enabled.
> 
> Is this a distribution kernel, or one built from virgin (i.e.
> unmodified from 
> www.kernel.org or one of the mirrors) source code?
> 
> Is there any possibility of you uploading your .config file somewhere?
> I'm 
> curious what kernel options you have set.. especially USB_SUSPEND
> (USB 
> autosuspend -- not sure if this was added to 2.6.24 or if .22 had it
> as well; 
> I don't have a .22 source tree at the moment).
> 
> I'm building a kernel from the 2.6.24.2 virgin source on Ubuntu to do
> some 
> testing; I'd like to prove that the problem exists in 2.6.24 proper
> before 
> screaming "kernel bug". But if 2.6.22 works, a bug is looking more and
> more 
> likely.
> 

My Ubuntu-provided 2.6.22 works fine.

And I am not losing any tuner. Not even with the Multirec of MythTV
0.21.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
