Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALNll3o010908
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 18:47:47 -0500
Received: from joan.kewl.org (joan.kewl.org [212.161.35.248])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALNlZkS003979
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 18:47:36 -0500
From: Darron Broad <darron@kewl.org>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
In-reply-to: <200811211511.14193.vanessaezekowitz@gmail.com> 
References: <200811211511.14193.vanessaezekowitz@gmail.com>
Date: Fri, 21 Nov 2008 23:47:35 +0000
Message-ID: <32121.1227311255@kewl.org>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: cx88 IRQ loop runaway 
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

In message <200811211511.14193.vanessaezekowitz@gmail.com>, Vanessa Ezekowitz wrote:

hi.

>I'm not sure whose 'department' this is, so I'm sending this email to the v4l/dvb lists...
>
>About a week ago, my machine started locking up randomly.  Eventually figured out the problem and ended up replacing my dead primary SATA disk with a co
>uple of older IDE disks.  A reinstall of Ubuntu Hardy, and a couple of days of the usual setup and personalizing tweaks later, my system is back up and 
>running.  
>
>There is still one other SATA disk in my system and it is behaving normally.  While adding the replacement disks, I moved it to the port formerly occupi
>ed by the dead disk.
>
>My system, for reasons beyond my understanding, insists on sharing IRQ's among the various PCI devices, despite my explicit settings in the BIOS to assi
>gn fixed IRQ's to my PCI slots.   One of those IRQ's is being shared between my capture card and SATA controller.  Normally, this would not be an issue,
> but I seem to have found a nasty bug in the cx88xx driver.
>
>Without trying to use my capture card at all, every time I access the other SATA disk in my system, the cx88 driver spits out a HORRENDOUS number of wei
>rd messages, filling my system logs so fast that after two days, I'd used over 6 GB just in the few logs that sysklogd generates.
>
>That was enough log data to max out my / partition and grind my system to a halt.  Not exactly a good thing.   I don't know how long this has been happe
>ning, but it is possible that my previous (now dead) drive was simply large enough to contain these huge logs without running out of space.
>
>I am using the 2.6.27.6 kernel (from kernel.org), and using the v4l/dvb code contained within it, since it supports my card.  If necessary, I'll install
> the v4l-dvb repository instead.
>
>My only solution so far is to unload the cx88 driver modules.  This is a showstopper - I cannot use or even enable my capture card until this is resolve
>d.
>
>Log excerpt below.  I haven't the faintest clue what's causing that garbage at the end of the excerpt.  I didn't keep the older logs for obvious reasons
>, but that garbage appears multiple times, so it is reproduceable.
>
>HELP!!

>----- Text Import Begin -----
>
<snip>
>----- Text Import End -----
>
>That last "IRQ loop detected" gets dumped to the console thousands of times - enough so that the console is completely unusable while the card's driver 
>is loaded, if the SATA disk is also being used.  For example, doing a 'du' on its mount point is enough to send the cx88 driver into a tizzy.

There is a bug in the IRQ handler.

Please see if this fixes this for you:
	hg clone http://hg.kewl.org/v4l-dvb/
	
If this still doesn't solve your issue then we may look
at this off list if necessary.

Thanks.

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
