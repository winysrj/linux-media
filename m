Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1Jadum-0008LI-6l
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 22:27:41 +0100
Message-ID: <47DC3F65.8090407@philpem.me.uk>
Date: Sat, 15 Mar 2008 21:28:05 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <20080311110707.GA15085@mythbackend.home.ivor.org>	<47D701A7.40805@philpem.me.uk>
	<1205273404.20608.2.camel@youkaida>
In-Reply-To: <1205273404.20608.2.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

Nicolas Will wrote:
> My Ubuntu-provided 2.6.22 works fine.
> 
> And I am not losing any tuner. Not even with the Multirec of MythTV
> 0.21.

Right, well I've had enough of Ubuntu 8.04a2 (and I've learned a valuable 
lesson about not using alpha OSes on "production" systems). This is mostly 
down to my own actions, though -- the kernel is utterly hosed, the nVidia 
driver won't load, and the HVR-3000 is refusing to talk (instead insisting 
that the demux chip isn't talking).

I've backed the system off to 7.10 (Gutsy) and it seems stable -- I had to 
modify the patch from http://dev.kewl.org/hauppauge/ to apply on the latest Hg 
source... Much fun. It seems to work, so I'll probably publish the repository 
tomorrow some time (after the day I've had I don't feel like doing much of 
anything).

Plus I'd rather like to see if it works before I go unleashing it on the 
masses at large.

I'm just waiting for ScanDVB to finish making a channels.conf for ASTRA 28.2E, 
after that I'll see if I can crash the T500 :)

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
