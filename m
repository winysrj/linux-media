Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sboyce@blueyonder.co.uk>) id 1JafMm-0006Eg-Nf
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 00:00:42 +0100
Received: from [172.23.170.137] (helo=anti-virus01-08)
	by smtp-out5.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JafMi-0006Wp-Rs
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 23:00:36 +0000
Received: from [82.47.98.230] (helo=[192.168.10.10])
	by asmtp-out1.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1JafMi-00052z-9o
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 23:00:36 +0000
Message-ID: <47DC5515.6030701@blueyonder.co.uk>
Date: Sat, 15 Mar 2008 23:00:37 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <20080311110707.GA15085@mythbackend.home.ivor.org>	<47D701A7.40805@philpem.me.uk>	<1205273404.20608.2.camel@youkaida>
	<47DC3F65.8090407@philpem.me.uk>
In-Reply-To: <47DC3F65.8090407@philpem.me.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
Reply-To: sboyce@blueyonder.co.uk
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

Philip Pemberton wrote:
> Nicolas Will wrote:
>> My Ubuntu-provided 2.6.22 works fine.
>>
>> And I am not losing any tuner. Not even with the Multirec of MythTV
>> 0.21.
> 
> Right, well I've had enough of Ubuntu 8.04a2 (and I've learned a valuable
> lesson about not using alpha OSes on "production" systems). This is mostly
> down to my own actions, though -- the kernel is utterly hosed, the nVidia
> driver won't load, and the HVR-3000 is refusing to talk (instead insisting
> that the demux chip isn't talking).
> 
> I've backed the system off to 7.10 (Gutsy) and it seems stable -- I had to
> modify the patch from http://dev.kewl.org/hauppauge/ to apply on the latest Hg
> source... Much fun. It seems to work, so I'll probably publish the repository
> tomorrow some time (after the day I've had I don't feel like doing much of
> anything).
> 
> Plus I'd rather like to see if it works before I go unleashing it on the
> masses at large.
> 
> I'm just waiting for ScanDVB to finish making a channels.conf for ASTRA 28.2E,
> after that I'll see if I can crash the T500 :)
> 

Regarding the NVidia module, NVidia themselves haven't yet conjured up a 
fix for the latest kernels. I hope they do so as one kernel symbol 
(init_mm) that is needed was temporarily reexported and will again not 
be exported  from 2.6.26-rc. That seems to be the holdup at NVidia, 
hopefully will be sorted by the time 2.6.25 final appears.
NVIDIA_2.6.25.patch.txt can be downloaded from the NVidia Linux forum 
which works with later 2.6.24-git kernels and 2.6.25-rc. Here I have 
been  running it with kernels up to current 2.6.25-rc5-git5.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
