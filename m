Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NC06Ov003592
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 08:00:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n3NBxpBH006786
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 07:59:51 -0400
Message-ID: <49F0482D.7000707@gmx.de>
Date: Thu, 23 Apr 2009 12:51:25 +0200
From: Stefan Sassenberg <stefan.sassenberg@gmx.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Bug solved in which version?
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

Hello,

I have a problem with my MSI Starcam 370i. Searching the internet I 
found a kernel bugzilla entry that matches my bug quite well. It is 
<http://bugzilla.kernel.org/show_bug.cgi?id=11946>. At that time I was 
using kernel "kernel-2.6.28-gentoo-r4". I read that the bug is fixed in 
the current tree, so I upgraded to kernel "kernel-2.6.29-gentoo-r1" 
still having the same bug.

Is the problem supposed to be fixed in that kernel version? If so, what 
can I do to find the cause for it?

ds9 ~ # uname -a
Linux ds9 2.6.29-gentoo-r1 #1 SMP Wed Apr 22 00:54:45 CEST 2009 x86_64 
AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ AuthenticAMD GNU/Linux

Regards

Stefan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
