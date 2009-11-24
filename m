Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAODkIXu011481
	for <video4linux-list@redhat.com>; Tue, 24 Nov 2009 08:46:18 -0500
Received: from mail-qy0-f182.google.com (mail-qy0-f182.google.com
	[209.85.221.182])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAODk20q011862
	for <video4linux-list@redhat.com>; Tue, 24 Nov 2009 08:46:02 -0500
Received: by qyk12 with SMTP id 12so3125216qyk.6
	for <video4linux-list@redhat.com>; Tue, 24 Nov 2009 05:46:02 -0800 (PST)
Message-ID: <4B0BE393.2080904@gmail.com>
Date: Tue, 24 Nov 2009 14:45:55 +0100
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: V4L-Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Camera sensor
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

I have implemented a driver for the LZ0P374 Sharp CCD camera sensor. I 
have been using an old kernel, and now i am updating to the new 
soc_camera framework. My question is, is there anyone using this sensor? 
We bought the sensor with absolutely no documents, support to be found 
(lucky to get driver running).

It was found on the Sandgate 2P Sophia Systems development kit. The 
sensor is mainly (only) sold in Asia. But at the time of our product 
release (~2006), this was the only CCD camera sensor to be found in 
quantities less than millions.

Thanks,
Ryan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
