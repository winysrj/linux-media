Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H22d96029767
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 22:02:39 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H22KjF003981
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 22:02:23 -0400
Received: from www.outflux.net (serenity-end.outflux.net [10.2.0.2])
	by mylar.outflux.net (8.13.8/8.13.8/Debian-3) with ESMTP id
	m3H2298L031003
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 19:02:14 -0700
Resent-Message-ID: <20080417020208.GJ18929@outflux.net>
Date: Wed, 16 Apr 2008 18:23:46 -0700
From: Kees Cook <kees@outflux.net>
To: video4linux-list@redhat.com
Message-ID: <20080417012346.GG18929@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 0/2] V4L: add "function" sysfs attribute to v4l devices
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

Hello!

Two patches follow, related to discussions[1][2] on the hotplug mailing
list, in an attempt to solve enumeration problems when multiple v4l
devices are present in a system and the resulting init order was not
guaranteed to be the same from boot-to-boot (video0 isn't always the
same device).  The goal is to create things like this with udev:
    pci-0000:01:06.0-video-mpeg-cap -> ../../video0
    pci-0000:01:07.0-video-yuv-cap -> ../../video1
    pci-0000:01:06.0-video-yuv-cap -> ../../video24

First patch is the sysfs infrastructure to support exporting a
"function" string.  This value is related to the existing "type" field,
but is singular in use and not designed for internal driver use, as
"type" seems to be.

Second patch is a first stab at providing "function" entries for
hardware I have access to.

Thanks,

-Kees

[1] http://marc.info/?t=118591155400012&r=1&w=2
[2] some recent discussion on the new hotplug list, but I can't find an
    archive link since it moved to vger...

-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
