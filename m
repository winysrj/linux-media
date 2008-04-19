Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JDpl6a012951
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:51:47 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3JDpXev008736
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:51:34 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZK002XORTSQU40@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Sat, 19 Apr 2008 09:51:28 -0400 (EDT)
Date: Sat, 19 Apr 2008 09:51:28 -0400
From: Steven Toth <stoth@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Message-id: <4809F8E0.40908@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Cc: Amitay Isaacs <amitay@gmail.com>
Subject: HVR1200 / HVR1700 / TDA10048 support
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

A couple of people have been asking about TDA10048 support, well it was 
merged into master this morning. You can get the driver (and support for 
the Hauppauge HVR1200 / HVR1700) here linuxtv.org/hg/v4l-dvb.

Firmware for the TDA10048 can be extract from the windows driver, 
everything you needs is here:

steventoth.net/linux/hvr1200 or steventoth.net/linux/hvr1700

Regards,

Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
