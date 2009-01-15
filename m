Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FEgcns015998
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 09:42:38 -0500
Received: from dd18532.kasserver.com (dd18532.kasserver.com [85.13.139.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FEfCDu020352
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 09:41:13 -0500
Received: from tuvok (p4FCA72CF.dip.t-dialin.net [79.202.114.207])
	by dd18532.kasserver.com (Postfix) with ESMTP id E5339181C4A84
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 15:41:15 +0100 (CET)
Date: Thu, 15 Jan 2009 15:41:11 +0100
From: Carsten Meier <cm@trexity.de>
To: video4linux-list@redhat.com
Message-ID: <20090115154111.36cc25d1@tuvok>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: How to identify USB-video-devices
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

Hello list,

we recently had a discussion on the pvrusb2-list on how to identify a
video-device connected via USB from an userspace app. (Or more precisely
on how to associate config-data with a particular device). This led to
a patch which returned the device's serial-no. in v4l2_capability's
bus_info field. This one has been rejected, but I really feel that this
is the right way to go. Here's the thread:
http://www.isely.net/pipermail/pvrusb2/2009-January/002091.html

I think the meaning of the bus_info-field should be modified slightly
for USB-devices to reflect its dynamic nature. At least a string that
won't change on dis-/reconnect and standby/wake-up-cycles should be
returned. If a device has a unique serial-no. it is a perfect candidate
for this, if not, some USB-port-info should be returned that won't
change if the device is connected to the same port through the same hub.

What do you think?
(BTW: I'm not a kernel-hacker, I'm writing this from the perspective of
an app-developer)

Regards,
Carsten

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
