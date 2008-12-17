Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHHDI6v001810
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 12:13:18 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHHCjLo013986
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 12:12:45 -0500
Date: Wed, 17 Dec 2008 18:12:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812171809030.5465@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: "fix compilation for pre-2.6.26 kernels" - backwards compatibility
 breaks patches
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

Hi,

I've got a case, where a patch doesn't apply to the hg tree because of 
such a backwards-compatibility fix. To be precise, the patch applies but 
with a "fuzz 2", I think, hg will not accept this. but even if it will, it 
will then be difficult to re-export it to mainline git. What does one do 
in such situations? Specifically this is the ov772x.c driver and the 
conflicting commit is

# User Hans Verkuil <hverkuil@xs4all.nl>
# Date 1225375034 -3600
# Node ID 85a17c64ef0ae476bb2e7cc3c43190db04a39ca2
# Parent  3ed7439469cdd5d66b1cc2a053ae617bff56bb92
ov772x: fix compilation for pre-2.6.26 kernels

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
