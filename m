Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3F5hbq007546
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 10:05:43 -0500
Received: from sk.insite.com.br (sk.insite.com.br [66.135.32.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3F4een014047
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 10:04:40 -0500
Received: from [201.82.105.195] (helo=[192.168.1.100])
	by sk.insite.com.br with esmtps (TLSv1:AES256-SHA:256) (Exim 4.69)
	(envelope-from <diniz@wimobilis.com.br>) id 1L7tHK-0003mb-VH
	for video4linux-list@redhat.com; Wed, 03 Dec 2008 13:04:40 -0200
From: Rafael Diniz <diniz@wimobilis.com.br>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 3 Dec 2008 13:12:11 -0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031312.11642.diniz@wimobilis.com.br>
Subject: VBI capture failing for saa7134
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

Hello people,
I'm w/ a problem for capturing VBI data (closed caption) using a Pinnacle PCTV 
(worked w/ some older kernel). 
Using the sliced-vbi-test.c (inside v4l2-apps/test), I get the error in the 
following ioctl:

ioctl(fh, VIDIOC_S_FMT, &fmt);
vbi: Invalid argument

What function handles that ioctl?
I'm looking at linux/drivers/media/video/saa7134 directory, but I could not 
figure out what function takes care of the VIDIOC_S_FMT ioctl.

Thanks,
Rafael Diniz
WiMobilis

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
