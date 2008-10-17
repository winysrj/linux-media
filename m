Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HDfQ8v025411
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 09:41:26 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HDfFHN022111
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 09:41:15 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id E9B4E12E89BD
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 14:41:13 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zmTLaOpOUZIw for <video4linux-list@redhat.com>;
	Fri, 17 Oct 2008 14:41:13 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 9873B12CF9BD
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 14:41:13 +0100 (BST)
Message-ID: <48F895F9.5010205@pickworth.me.uk>
Date: Fri, 17 Oct 2008 14:41:13 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: How to force the device assignment with V4l V2.0?
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

I'm having a play with the latest code from hg on the 2.6.27 kernel,
Gentoo installation. This is triggered by the gspca driver being
absorbed into the main tree (which is a great move by the way).

I have two devices - a CX88 based Hauppauge TV PCI card, and a USB
webcam. In the "old" style drivers, I could force the loading of the two
modules (cx8800 and gspca) in a set sequence, using blacklist and
modules.autoload. This is enough to ensure that cx88 gets /dev/video0,
and the usb webcam gets /dev/video1.

However, when trying a recent hg snapshot, the sequence of loading the
modules does not change what the V4l driver is doing when loaded.
Looking at dmesg, I see that the new drivers are doing quite a lot of
detecting work themselves - it looks like they pick up the USB device
first regardless of the module blacklist/load sequence I have specified.

So, question is: Is there a preferred way of forcing the sequence of
device assignment in V4L these days? I need the cx88 to be /dev/video0
and the USB webcam to be /dev/video1 - otherwise all sorts of programs
get confused.

Many thanks
Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
