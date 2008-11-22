Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM72ujH026303
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 02:02:56 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM72ic4026159
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 02:02:45 -0500
Date: Sat, 22 Nov 2008 08:02:40 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Jonathan Lafontaine <jlafontaine@ctecworld.com>
In-Reply-To: <09CD2F1A09A6ED498A24D850EB101208165C85C823@Colmatec004.COLMATEC.INT>
Message-ID: <alpine.DEB.1.10.0811220758210.29402@bakacsin.ki.iif.hu>
References: <09CD2F1A09A6ED498A24D850EB101208165C85C823@Colmatec004.COLMATEC.INT>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>
Subject: RE: [video4linux] Attention em28xx users
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

> You have to put 200-300 mb of sniff log
> 
> Whats your windows machine

XP on a Pentium 4 hardware.
(For the records: it's not mine! I'd never use M$ vindoze. :-)

> 
> Prefer use wxp but if it's a old machine u could try W2000 less memory usage
> 
> Remove max services, applications running with msconfig or taskmgr.
> 
> Its normal usbsniff freeze your pc, it focus on I/O northbrigde chipset interruption operations witch have priority on cpu usage
> 
> 
> Make your tv app or usbsniff priority process in taskmgr under normal priority , ( try this after)
> 
> Or if u got a dua lcopre set affinity of both process ( tv and usb sniff) each on different core
> 
> IF nothing better comeback to me, im busy right now

I ask my colleague if he can spend more time with testing.
Thanks for your hints.

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
