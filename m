Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0UKHUZe028531
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 15:17:30 -0500
Received: from mx38.mail.ru (mx38.mail.ru [194.67.23.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0UKHClr004714
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 15:17:13 -0500
Received: from [78.85.222.214] (port=21212 helo=[78.85.222.214])
	by mx38.mail.ru with asmtp id 1LSznb-000G00-00
	for video4linux-list@redhat.com; Fri, 30 Jan 2009 23:17:11 +0300
From: Graph <graphdark@inbox.ru>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Sat, 31 Jan 2009 00:17:23 +0400
Message-Id: <1233346643.9007.11.camel@graph-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: XPERT TV - PVR 883
Reply-To: graphdark@inbox.ru
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

Hi, v4l.

I have some trouble in installing XPERT TV - PVR 883.
lspci take this:
05:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder (rev 05)
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at ef000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

dmesg take this:
[   32.296345] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   32.296392] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 21 (level,
low) -> IRQ 21
[   32.296433] cx88[0]: Your board has no valid PCI Subsystem ID and
thus can't
[   32.296434] cx88[0]: be autodetected.  Please pass card=<n> insmod
option to
[   32.296435] cx88[0]: workaround that.  Redirect complaints to the
vendor of
[   32.296435] cx88[0]: the TV card.  Best regards,
[   32.296436] cx88[0]:         -- tux
[   32.296438] cx88[0]: Here is a list of valid choices for the card=<n>
insmod option:

I try change number of card, but not have any result.

tnx for help. Sorry about my very bad english.


-- 
Graph <graphdark@inbox.ru>
MgM

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
