Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61JgQlW016479
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 15:42:26 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61JgFTr019265
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 15:42:16 -0400
Received: by fg-out-1718.google.com with SMTP id e21so17364fga.7
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 12:42:15 -0700 (PDT)
Message-ID: <30353c3d0807011242r559f87ak8c8049b7ca4d2677@mail.gmail.com>
Date: Tue, 1 Jul 2008 15:42:10 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jaime Velasco Juan" <jsagarribay@gmail.com>
In-Reply-To: <20080701171321.GA6159@singular.sob>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281840y76796eebh3beae577a24f6049@mail.gmail.com>
	<30353c3d0806291534y3b79d27aob9c4955b6d4ecb9c@mail.gmail.com>
	<20080701171321.GA6159@singular.sob>
Cc: video4linux-list@redhat.com
Subject: Re: [RFT v2] stk-webcam: Fix video_device handling
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

On Tue, Jul 1, 2008 at 1:13 PM, Jaime Velasco Juan
<jsagarribay@gmail.com> wrote:
> Hi David,
>
> it seems to work ok now with your other patch, but if the video_device
> struct is going to be ref. counted, wouldn't it make sense to drop the
> kref in the driver and free all resources in the release callback? With
> these changes there are two krefs which are created, get and put at the
> same time and for the same purpose.
>
I noticed this as well and was actually working on a patch which would
have removed the kref from the stk_camera since it would no longer
have been needed.

> I also like better the video_device struct embedded in the main
> stk_camera struct (as it is now), but if people prefer having it
> referenced with a pointer, so be it.
>
Agreed. The next patch I submit will keep the video_device struct in
the stk_camera struct as it really doesn't need to be allocated using
video_device_alloc().

> Regards,
>
> Jaime

I'm currently working to correct the kobject reference count in
videodev which was previously patched by using a kref. The resulting
behavior should be the same, but the code will be much simpler to
understand. Once I have this working I will submit a proper patch for
stk-webcam as well.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
