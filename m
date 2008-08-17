Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HMRSQS028991
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 18:27:28 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HMRHHm009136
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 18:27:17 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1445449fga.7
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:27:17 -0700 (PDT)
Message-ID: <30353c3d0808171527n6c4c6546iddf8f55253373508@mail.gmail.com>
Date: Sun, 17 Aug 2008 18:27:17 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200808172340.02280.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808171709.51258.hverkuil@xs4all.nl>
	<200808172146.45683.hverkuil@xs4all.nl> <48A8981E.3060808@hhs.nl>
	<200808172340.02280.hverkuil@xs4all.nl>
Cc: Mike Isely <isely@isely.net>, v4l <video4linux-list@redhat.com>,
	linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L2: switch to register_chrdev_region: needs testing/review of
	release() handling
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

I like what you've done with this, it's very close to the patch I had
in mind. I especially like the way you hijacked cdev's kobj release..
I hadn't considered that. I would have sent you my version, but it was
based on the old videodev.c and needed to be redone after the videodev
split. The associated patch which moves cdev_del to video_release is
definitely the right thing to do. I don't know if it means much, but I
ACK this patch with the associated patch that moves cdev_del to
video_release.

ACKed by David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
