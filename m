Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQHm8b4022437
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 12:48:08 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQHlLBq002287
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 12:47:21 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, v4l <video4linux-list@redhat.com>
Date: Wed, 26 Nov 2008 23:17:08 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904E83D@dbde02.ent.ti.com>
In-Reply-To: <200811242309.37489.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: v4l2_device/v4l2_subdev: please review
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


Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Hans Verkuil
> Sent: Tuesday, November 25, 2008 3:40 AM
> To: v4l
> Subject: v4l2_device/v4l2_subdev: please review
> 
> Hi all,
> 
> I've finally tracked down the last oops so I could make a new tree
> with
> all the latest changes.
> 
> My http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng tree contains the
> following:
> 
> 
[Hiremath, Vaibhav] Some quick comments I came across -

	- No support for enumerating/getting the input/output list. We do have entry for s_routing, but how master driver will be able to know about the input and output supported for sub-devices?
I believe the input and output supported should come from board specific file (from bridge).

Although I am not aware of sa7115 driver, but after looking to code it looks like master driver knows about the indexes (input and output) part. That should not be the case.

	- Again, in my opinion it would carry more information if we use v4l2_input struct for input and output.

What is your opinion here?

Still looking into it, may get some more points while migrating to it.

> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
