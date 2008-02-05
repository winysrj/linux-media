Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15HkQpW006959
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:26 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m15Hjmoa016434
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:45:55 -0500
Date: Tue, 5 Feb 2008 18:46:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802051820450.5882@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6] soc_camera V4L2 interface for directly connected cameras
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

Hi

This is version 4 of the soc-camera patch-set. A few patches, that are 
required by this patche-set, but are not directly connected with it I've 
already sent to this and other related lists. I've hopefully taken into 
account all suggestiong from the precious 3 postings, thanks again to 
reviewers. This patch-set is now based on the top of the v4l-dvb/master 
tree. The mt9m001 and mt9v022 cameras use the gpiolib interface to talk to 
the pca9536 i2c GPIO extender. At the moment gpiolib as a separate 
drivers/gpio directory is still not in the mainline, only in -mm, but 
hopefully it'll get promoted for 2.6.25. So far this patchset only 
supports the PXA270 Xscale processor, support for i.MX27 and i.MX31 is 
also planned. More cameras might get added too.

Patches now verified with checkpatch.pl, only a few "longer than 80" 
warnings are left. Also the PXA-specific part has been modified according 
to suggestions on the ARM-kernel mailing list: renamed PXA27X to PXA27x 
for consistency, "cif" in structures, functions and macros to "camera" 
(apart from register names), platform device is now in devices.c, its name 
adapted to match conventions.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
