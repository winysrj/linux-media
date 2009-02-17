Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HLqUrG027229
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 16:52:30 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1HLpQIk024058
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 16:51:26 -0500
Received: by fg-out-1718.google.com with SMTP id 19so539798fgg.7
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 13:51:23 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Feb 2009 21:51:23 +0000
Message-ID: <286e6b7c0902171351rf92b458idca8e3c7bc2c1e5e@mail.gmail.com>
From: D <d.a.nstowell+v4l@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: v4l2, setting frame rate (frame interval)
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

Hi -

The v4l2 api seems to have a facility for enumerating available
framerates (ioctl VIDIOC_ENUM_FRAMEINTERVALS), but not for requesting
a particular framerate. (The feature is still experimental and
incomplete?) Or have I overlooked it?

Thanks
Dan
-- 
http://www.mcld.co.uk

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
