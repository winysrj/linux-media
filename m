Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38EStNk011340
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 10:28:55 -0400
Received: from mail.harktech.com (rrcs-70-61-214-222.midsouth.biz.rr.com
	[70.61.214.222])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38EShdH028850
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 10:28:43 -0400
Received: from localhost (fs2.harktech.com [127.0.0.1])
	by mail.harktech.com (Postfix) with ESMTP id 30E83D5B40
	for <video4linux-list@redhat.com>; Tue,  8 Apr 2008 10:28:37 -0400 (EDT)
Received: from mail.harktech.com ([127.0.0.1])
	by localhost (mail.harktech.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5WM1Up7KZbTD for <video4linux-list@redhat.com>;
	Tue,  8 Apr 2008 10:28:36 -0400 (EDT)
Received: from david3.harktech.com (unknown [10.100.1.100])
	by mail.harktech.com (Postfix) with ESMTP id 6FE12D5B3B
	for <video4linux-list@redhat.com>; Tue,  8 Apr 2008 10:28:36 -0400 (EDT)
Message-ID: <47FB8114.6010504@thegeorges.us>
Date: Tue, 08 Apr 2008 10:28:36 -0400
From: David George <david@thegeorges.us>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Hauppauge HD-PVR driver?
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

I just heard back from Hauppauge that they are expecting[1] the Linux 
community to produce their own driver for this device.  I was wondering 
if any of the v4l developers have received a prerelease unit or 
documentation to aid in the driver development.  For those that may not 
be familiar with the device it is a high-definition component video 
capture device.  It outputs an H.264/AVC stream (not sure what the 
actual container format is) over USB 2.0 high speed.  Here is a link to 
their product page: http://www.hauppauge.com/site/products/hd_pvr.html .

[1] Exact text of reply: "Linux drivers will not be available for this 
product at the time of it's release. All Linux support for Hauppauge 
hardware is 3rd party, so in time, there likely will be a Linux driver 
available from the Linux community like most of the other Hauppauge 
products, but nothing in the short term."

-- 
David

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
