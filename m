Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4C8AJAl032566
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 04:10:19 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4C8A5E3024898
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 04:10:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JvT6g-0002kp-Q5
	for video4linux-list@redhat.com; Mon, 12 May 2008 08:10:02 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 08:10:02 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 08:10:02 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Mon, 12 May 2008 10:58:18 +0300
Message-ID: <g08tjl$uqt$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [RFC] driver model for camera sensors
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

Hi all,

in 2.6.26-rc1 today we have soc-camera driver and two drivers for Micron 
cameras in this new driver model. But there are few old drivers for 
OmniVision cameras, and they do not work with soc-camera driver model.
In other side, these two new Micron drivers does not work with old 
interface.
So, we have the same sensors on different busses (soc, usb) and we need 
two different drivers for the same sensor. I thing it's a good idea to 
make all camera sensor drivers in unified model, that would be able to 
work on both busses (usb, soc).
Now I need driver for OV7670 sensor and I want to write it correct form.
I think sensor driver should be universal and configurable. It should be 
able interface with v4l2 through soc-camera or usb bus.
I suggest to put all sensor drivers in separate directory in kernel tree.

Am I rigth? Please comment my opinion.

BR,
Darius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
