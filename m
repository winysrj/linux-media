Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2M159Yc030076
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 21:05:09 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2M14ZNa031074
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 21:04:36 -0400
Date: Sat, 22 Mar 2008 02:04:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bradford Boyle <bradford.d.boyle@gmail.com>
In-Reply-To: <bb26ec2c0803201934r5c037585h25882e2352c02a84@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803212104330.8208@axis700.grange>
References: <bb26ec2c0803201934r5c037585h25882e2352c02a84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: PCTV HD Card 800i Kernel Oops
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

On Thu, 20 Mar 2008, Bradford Boyle wrote:

> I've been trying for the past week or two to get the 800i card working. I
> extracted the firmware and put it in /lib/firmware/<kernel_version> and I've
> downloaded and compiled the drivers for it (following the Linux TV wiki).
> The problem I am having now is that whenever I try to run 'tvtime-scanner',
> I get a kernel Oops.  The output from dmesg can be seen here:
> http://pastebin.com/m34f5e27f. I'm not sure how to proceed from here so any
> help would be greatly appreciated it.

I do not know how you've built the drivers, but the Oops looks exactly 
like the ones reported earlier on this list and fixed by the patch

http://marc.info/?l=linux-video&m=120550519726950&w=2

which is already in v4l-dvb/devel

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
