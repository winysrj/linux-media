Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63GqxZf031219
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 12:52:59 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63GqcnD014873
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 12:52:38 -0400
Received: by fg-out-1718.google.com with SMTP id e21so443327fga.7
	for <video4linux-list@redhat.com>; Thu, 03 Jul 2008 09:52:37 -0700 (PDT)
Message-ID: <30353c3d0807030952i3152e9acsca530afabbfe5f7a@mail.gmail.com>
Date: Thu, 3 Jul 2008 12:52:37 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0807020839r6e18978dqc0b38f6c8d9c177@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
	<200807012350.53604.laurent.pinchart@skynet.be>
	<30353c3d0807011528v561d4de8ycb7c3f1d8afc82f9@mail.gmail.com>
	<200807020104.52122.laurent.pinchart@skynet.be>
	<30353c3d0807011649n5b225ef7t11bbf36217427647@mail.gmail.com>
	<30353c3d0807012026n60815935g82a6746e5ca67b1a@mail.gmail.com>
	<30353c3d0807012115i6f53cf2l3bf615e526a3a3c@mail.gmail.com>
	<30353c3d0807020839r6e18978dqc0b38f6c8d9c177@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix sysfs kobj ref count
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

OK, here's my analysis of the locking situation:

video_open and video_close are both called with the BKL held and are
therefore non-preemptable. This means that video_open and video_close
will always run from beginning to end without interruption by any of
the other functions. Keeping this in mind, lets evaluate the following
sequences:

video_register_device (preempted)
 video_open

video_register_device (preempted)
 video_close

video_unregister_device (preempted)
 video_open

video_unregister_device (preempted)
 video_close

In all of the above sequences, videodev_lock is obtained by
video_register_device or video_unregister_device. video_open and
video_close will then deadlock while waiting to obtain the lock. Since
video_open and video_close can not be preempted, the lock will never
be obtained. The first and third above currently exist without this
patch. The second and fourth are a result of this patch.

Due to the use of the BKL, I cannot currently think of any viable
solutions to these issues. These issues might be solvable once the BKL
is removed, but it will also present a whole range of other
challenges.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
