Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4Hwfpt025526
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 12:58:41 -0500
Received: from web51804.mail.re2.yahoo.com (web51804.mail.re2.yahoo.com
	[206.190.38.235])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB4HvuoB020221
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 12:57:57 -0500
Date: Thu, 4 Dec 2008 09:57:55 -0800 (PST)
From: Ori Pessach <mail@oripessach.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <510940.57134.qm@web51804.mail.re2.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Subject: bttv timeouts
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

I'm trying to diagnose an issue I'm seeing pretty frequently on multiple systems when using a generic, Kodicom 8800 clone capture card (with 8 bt878 chips.) After running for a while, the logs starts showing:

bttv2: timeout: drop=0 irq=24104841/44746684, risc=3787b03c, bits: VSYNC HSYNC RISCI
bttv2: reset, reinitialize
bttv3: timeout: drop=0 irq=27822078/51658940, risc=3785903c, bits: VSYNC HSYNC RISCI
bttv3: reset, reinitialize


over and over again, and the capture code times out when waiting for a frame. No frames are captured after that point.

Unloading and reloading the bttv module fixes that for a while. This is happening with kernel build 2.6.18-53.el5 on a CentOS system. I've seen references to this behavior on the web, but no solution or even speculation as to what might be causing this. Has anyone seen this before? Any ideas what could be the cause of this, or how to fix it?

Thanks,

--Ori Pessach
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
