Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3K9GBCr008411
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 05:16:12 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3K9FW0j002078
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 05:15:33 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 90722121C620
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 10:15:26 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9vEYqOHAGHzP for <video4linux-list@redhat.com>;
	Sun, 20 Apr 2008 10:15:26 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 12F35A94B9F
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 10:15:25 +0100 (BST)
Message-ID: <480B09A9.20204@pickworth.me.uk>
Date: Sun, 20 Apr 2008 10:15:21 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
CC: Linux and Kernel Video <video4linux-list@redhat.com>
References: <480A5CC3.6030408@pickworth.me.uk>
	<1208652474.14680.8.camel@pc10.localdom.local>
In-Reply-To: <1208652474.14680.8.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
Reply-To: ian@pickworth.me.uk
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

(Should have posted CC to the list - I really am rusty! sorry.)

Hello Hermann,

hermann pitton wrote:
 > Hi Ian,
 >
 > Am Samstag, den 19.04.2008, 21:57 +0100 schrieb Ian Pickworth:
 >> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
for    the Hauppauge WinTV appear to have suffered some regression 
between the two kernel versions.
......
 > nice to hear from you!

Likewise! Same old gang on cx88 then :-) .

 >
 > I don't have that tuner in any box currently and the variant I had was
 > always a _little_ bit critical in standard PCI slots.
 >
 > Ian, are you sure that it is the released 2.6.25 showing that?

I'm not sure how to pin down the version Gentoo provides. The syslog on 
bootup says:

Linux version 2.6.25-gentoo (root@ian2) (gcc version 4.1.2 (Gentoo 4.1.2 
p1.0.2)) #1 PREEMPT Sat Apr 19 09:29:59 BST 2008

The gentoo-sources changelog doesn't say which version of the Kernel 
they picked up to make the release. I can see from the package manifest 
that they use linux-2.6.25.tar.bz2 as the base source, but then apply 
patches to make the Gentoo release. I've dug around the
drivers/media/video/cx88 source a bit, but all the version comments 
appear to be stripped out.

Gentoo usually provide a "masked" version of the kernel for several 
iterations before making it "stable" in their package tree, so I would 
guess that this is probably an early kernel source release, if that helps.

I'm a bit rusty at this stuff, sorry.

 >
 > Than we should have some alert around.
 >
 > Cheers,
 > Hermann
 >

I'd be happy to do whatever is needed to pin down the problem. As I say 
though, I am a bit rusty. If you tell me what to do I'll have a go.

Thanks
Regards
Ian


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
