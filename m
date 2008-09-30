Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U0LFRQ000318
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:21:16 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U0L5Sv008827
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:21:05 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1710012fga.7
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 17:21:04 -0700 (PDT)
Message-ID: <30353c3d0809291721o2a2858b1na0a930a1f75ac4f3@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:21:04 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [PATCH 0/3] stk-webcam updates
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

The following series of patches correct issues identified in
stk-webcam. The patches are as follows:

1. stkwebcam: fix crash on close after disconnect
2. stkwebcam: free via video_device release callback
3. stkwebcam: simplify access to stk_camera struct

The first patch in this series is a bug fix. If it is possible to
merge this patch into 2.6.27 I highly recommend it as this bug has
existed for quite some time. The second patch restructures the driver
and removes the now unnecessary reference count on the stk_camera
struct. The third patch simplifies the driver in several areas
removing several unnecessary branches.

These patchs should apply cleanly against the working branch of the
git v4l-dvb tree. Each of the patches will be submitted independently.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
