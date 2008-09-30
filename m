Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UFwfGd018505
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 11:58:41 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8UFwYjI024829
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 11:58:35 -0400
Received: by ey-out-2122.google.com with SMTP id 4so31219eyf.39
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 08:58:34 -0700 (PDT)
Date: Tue, 30 Sep 2008 17:00:22 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080930160022.GA3301@singular.sob>
References: <30353c3d0809291721o2a2858b1na0a930a1f75ac4f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0809291721o2a2858b1na0a930a1f75ac4f3@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] stk-webcam updates
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

El lun. 29 de sep. de 2008, a las 20:21:04 -0400, David Ellingsworth escribió:
> The following series of patches correct issues identified in
> stk-webcam. The patches are as follows:
> 
> 1. stkwebcam: fix crash on close after disconnect
> 2. stkwebcam: free via video_device release callback
> 3. stkwebcam: simplify access to stk_camera struct
> 
> The first patch in this series is a bug fix. If it is possible to
> merge this patch into 2.6.27 I highly recommend it as this bug has
> existed for quite some time. The second patch restructures the driver
> and removes the now unnecessary reference count on the stk_camera
> struct. The third patch simplifies the driver in several areas
> removing several unnecessary branches.
> 
> These patchs should apply cleanly against the working branch of the
> git v4l-dvb tree. Each of the patches will be submitted independently.
> 
> Regards,
> 
> David Ellingsworth

ACK

Regards,
Jaime

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
