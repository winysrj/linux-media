Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BCojLv029006
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 08:50:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BCmurH003530
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 08:48:56 -0400
Date: Sat, 11 Oct 2008 09:48:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "David Ellingsworth" <david@identd.dyndns.org>
Message-ID: <20081011094844.3dfa49d3@pedra.chehab.org>
In-Reply-To: <30353c3d0810101229l3a73acb7mb7c220ac9e8c5b03@mail.gmail.com>
References: <30353c3d0809291721o2a2858b1na0a930a1f75ac4f3@mail.gmail.com>
	<20080930160022.GA3301@singular.sob>
	<30353c3d0810101229l3a73acb7mb7c220ac9e8c5b03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>
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

Hi David,

On Fri, 10 Oct 2008 15:29:15 -0400
"David Ellingsworth" <david@identd.dyndns.org> wrote:

> On Tue, Sep 30, 2008 at 12:00 PM, Jaime Velasco Juan
> <jsagarribay@gmail.com> wrote:
> > El lun. 29 de sep. de 2008, a las 20:21:04 -0400, David Ellingsworth escribió:
> >> The following series of patches correct issues identified in
> >> stk-webcam. The patches are as follows:
> >>
> >> 1. stkwebcam: fix crash on close after disconnect
> >> 2. stkwebcam: free via video_device release callback
> >> 3. stkwebcam: simplify access to stk_camera struct
> >>
> >> The first patch in this series is a bug fix. If it is possible to
> >> merge this patch into 2.6.27 I highly recommend it as this bug has
> >> existed for quite some time. The second patch restructures the driver
> >> and removes the now unnecessary reference count on the stk_camera
> >> struct. The third patch simplifies the driver in several areas
> >> removing several unnecessary branches.
> >>
> >> These patchs should apply cleanly against the working branch of the
> >> git v4l-dvb tree. Each of the patches will be submitted independently.

There were some API changes at V4L that also touched at stkwebcam. Due to that,
I'm getting some rejects on your patch series (this is at the first patch):

 patch -p1 -i /tmp/editdiff.CvlYZA/patch.diff -d linux
patching file drivers/media/video/stk-webcam.c
Hunk #1 succeeded at 561 (offset -15 lines).
Hunk #2 FAILED at 703.
1 out of 2 hunks FAILED -- saving rejects to file drivers/media/video/stk-webcam.c.rej

Could you please re-generate it?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
