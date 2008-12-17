Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHJdMpL026002
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:39:22 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHJdAaj018518
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:39:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 17 Dec 2008 20:39:03 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<20081217181645.GA26161@kroah.com>
	<200812172030.32535.hverkuil@xs4all.nl>
In-Reply-To: <200812172030.32535.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172039.03436.hverkuil@xs4all.nl>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
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

On Wednesday 17 December 2008 20:30:32 Hans Verkuil wrote:
>
> This solves this particular problem. But this will certainly break v4l as
> it is right now, since the spin_lock means that the kref's release cannot
> do any sleeps, which is possible in v4l. If we want to allow that in
> cdev, then the spinlock has to be replaced by a mutex. But I have the
> strong feeling that that's not going to happen :-)

Note that if we ever allow drivers to hook in their own release callback, 
then we certainly should switch to a mutex in the cdev struct, rather than 
a global mutex. It obviously makes life more complicated for cdev, but much 
easier for drivers.

Regards,

 	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
