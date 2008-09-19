Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JKRwQO018255
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:27:58 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JKRg3f026965
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:27:42 -0400
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	m8JKRflQ019749
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:27:42 -0400
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1KgmZk-0005WH-00
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 16:27:36 -0400
Date: Fri, 19 Sep 2008 16:27:35 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
Message-ID: <alpine.DEB.1.10.0809191623050.19977@vegas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Subject: tm6000 load errors
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

I'm attempting to get a Diamond VC500 USB capture device working. I opened 
the device and it has a TM5600 chipset so I grabbed the experimental 
drivers from http://linuxtv.org/hg/~mchehab/tm6010. I copied my kernel 
.conf to the v4l directory and did "make kernel-links, make, make 
install" but when I do a "modprobe tm6000" I get the following output in 
dmesg:

tm6000: disagrees about version of symbol video_ioctl2
tm6000: Unknown symbol video_ioctl2
tm6000: disagrees about version of symbol v4l2_type_names
tm6000: Unknown symbol v4l2_type_names
tm6000: disagrees about version of symbol video_unregister_device
tm6000: Unknown symbol video_unregister_device
tm6000: disagrees about version of symbol video_device_alloc
tm6000: Unknown symbol video_device_alloc
tm6000: disagrees about version of symbol video_register_device
tm6000: Unknown symbol video_register_device
tm6000: disagrees about version of symbol video_device_release
tm6000: Unknown symbol video_device_release

Did I build the module incorrectly?

I'm also having trouble finding the firmware file for the device, can 
anyone point me in the right direction for that?

TIA,
Keith.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
