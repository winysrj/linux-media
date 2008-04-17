Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HFpvtd010231
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 11:52:07 -0400
Received: from mxout2.netvision.net.il (mxout2.netvision.net.il [194.90.9.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HFoJUY023593
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 11:50:40 -0400
Received: from [192.168.2.100] ([85.250.225.146]) by mxout2.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTPA id <0JZH008DT7ZFU210@mxout2.netvision.net.il> for
	video4linux-list@redhat.com; Thu, 17 Apr 2008 18:50:04 +0300 (IDT)
Date: Thu, 17 Apr 2008 18:50:03 +0300
From: amir sher <amir_in@netvision.net.il>
To: video4linux-list@redhat.com
Message-id: <480771AB.1030005@netvision.net.il>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
Subject: support for Leadtek WinFast PxTV1200
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

I have a pci express card, the Leadtek WinFast PxTV1200 which has a 
CX23885 chip set and Xceive 2028 silicon tuner. As I understand the 
latest kernel (2.6.25) has support for all of those components on other 
cards but not specific to this one. Is it possible to add this support 
for this card as well? I guess it shouldn't be too hard.

Thank you,
Amir

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
