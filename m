Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBI9Gq4f007013
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:16:52 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBI9GbZQ031806
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:16:38 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1LDEzr-0001Hg-Cl
	for video4linux-list@redhat.com; Thu, 18 Dec 2008 10:16:43 +0100
Date: Thu, 18 Dec 2008 10:16:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812180949460.3963@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: partial linux kernel repository and backwards compatibility for
 platform-based video devices
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

Hi all,

I know I'm pretty new to the v4l world and still learning and I am sure 
the currently established development model has its good reasons (yes, I 
know some of them) and its important advantages, but I'd like to ask if it 
were not possible to adjust / extend it in some way to make it more 
convenient for developers and testers working with platform-based video 
devices.

The issue is, AFAIU, until recently v4l dealt only with PCI and USB 
devices, with which the APIs are most of the time _relatively_ well 
defined and stable, and v4l development is mostly isolated, i.e., it 
certainly happened in the past, but most likely not very often, that while 
working on some v4l code one had to modify USB / PCI code simultaneously. 
Whereas in most cases the development takes place only under drivers/media 
and respective include directories and files.

This is not the case with platform-based v4l devices, which are currently 
represented in the kernel by int-device (omap, more?) and soc-camera (pxa, 
sh, i.mx31, i.mx27 - latter two not yet in the mainline) APIs. These video 
devices (at least the host part) are closely coupled to the rest of the 
kernel, e.g., to respective arch/ directories by means of platform data. 
And development _most_ usually takes place globally, i.e., while 
developing video code one also adjusts platform code. Same holds for 
testing - one would most usually test drivers with the kernel together, I 
do not think there are many (if any) developers / testers out there, that 
use out-of-tree compilation of v4l drivers with platform-based video 
devices. Please, correct me if I am wrong. Which means, the value of this 
possibility and the backwards-compatibility code in v4l mercurial 
repositories is virtually 0 for this group of developers and testers. OTOH 
the cost of supporting this model is clearly > 0. I think I will not be 
mistaken if I say, that most developers in this group verify their work 
with some snapshot of the -next or at least of Linus' tree, whether they 
use git or not. So, what they end up doing is

1. develop / test and produce patches in the complete kernel tree
2. convert them to format suitable for hg
3. merge them into hg if they do not apply cleanly immediately, e.g., 
   because of the backwards-compatibility code
4. do _not_ test results of their merge
5. submit those results, hoping they still work
6. those results get stripped down to get rid of compatibility code before 
   re-exporting them and re-importing them into git
7. if nothing broke down in the process, they might still work...

Yes, most of the overhead tasks above are scriptable, maybe only apart 
from (3), but still - is it all worth it?

Could we maybe come up with some adjustment / extension to the current 
development model to make the process more simple? This would mean either 
skipping the hg stage completely, or at least removing all 
backwards-compatibility code from platform-based drivers?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
