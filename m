Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IE21tn028940
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 10:02:01 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IE1aEV018367
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 10:01:37 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KJqWU-0007hg-4x
	for video4linux-list@redhat.com; Fri, 18 Jul 2008 14:01:26 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 14:01:26 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 14:01:26 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Fri, 18 Jul 2008 17:01:15 +0300
Message-ID: <4880A22B.1050002@teltonika.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [RFC] Rename soc_camera to camera_bus
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

I suggest to rename soc_camera to camera_bus or something similar.
This should be done, because soc_camera framework can (IMHO should)
be used with USB webcams (not uvc), SoC camera interfaces, PCI device 
(like cafe) and any other devices where it is possible to control camera
bus and i2c separately.

BR,
Paulius Zaleckas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
