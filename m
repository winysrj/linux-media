Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2L2YsGR018576
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 22:34:54 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2L2YKqd028783
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 22:34:20 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1232508wfc.6
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 19:34:20 -0700 (PDT)
Message-ID: <bb26ec2c0803201934r5c037585h25882e2352c02a84@mail.gmail.com>
Date: Thu, 20 Mar 2008 22:34:20 -0400
From: "Bradford Boyle" <bradford.d.boyle@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: PCTV HD Card 800i Kernel Oops
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

I've been trying for the past week or two to get the 800i card working. I
extracted the firmware and put it in /lib/firmware/<kernel_version> and I've
downloaded and compiled the drivers for it (following the Linux TV wiki).
The problem I am having now is that whenever I try to run 'tvtime-scanner',
I get a kernel Oops.  The output from dmesg can be seen here:
http://pastebin.com/m34f5e27f. I'm not sure how to proceed from here so any
help would be greatly appreciated it.

bradford
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
