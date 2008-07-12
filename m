Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CJpNBF012270
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:51:23 -0400
Received: from vsmtp4.tin.it (vsmtp4.tin.it [212.216.176.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CJpBnD018871
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:51:12 -0400
Received: from [192.168.3.11] (77.103.126.124) by vsmtp4.tin.it (8.0.016.5)
	(authenticated as aodetti@tin.it)
	id 485F5E7500FF7C55 for video4linux-list@redhat.com;
	Sat, 12 Jul 2008 21:51:06 +0200
Message-ID: <48790AC4.2070606@tiscali.it>
Date: Sat, 12 Jul 2008 20:49:24 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: wrong permission for /dev/videoX with vivi 
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

I think this is more a udev issue with Fedora 9, but who knows?

When I modprobe vivi I get a /dev/videoX device.
The same happens when I plug in a webcam.
But the permissions are not the same

crw-rw----  1 root root 81, 0 2008-07-12 20:41 /dev/video0
crw-rw----  1 root root 81, 1 2008-07-12 20:41 /dev/video1
crw-rw----  1 root root 81, 2 2008-07-12 20:41 /dev/video2
crw-rw----+ 1 root root 81, 3 2008-07-12 20:42 /dev/video3

In this case I did

modprobe vivi n_devs=3  (for video0-2)
then I plugged in a USB webcam.

This way a normal user is not allowed to read /dev/video0.

Does anybody know where the permissions/ACL for vivi are held?

In udev rules I can only find

[andrea@thinkpad rules.d]$ grep video0 50-udev-default.rules
KERNEL=="video0",               SYMLINK+="video"

Cheers

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
