Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SKttC0015601
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 16:55:55 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SKtf2g015183
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 16:55:42 -0400
Received: by fg-out-1718.google.com with SMTP id e21so577888fga.7
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 13:55:41 -0700 (PDT)
Message-ID: <30353c3d0806281355p5c88d265ibab48f3f67c69930@mail.gmail.com>
Date: Sat, 28 Jun 2008 16:55:41 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com, "Jaime Velasco Juan" <jsagarribay@gmail.com>
In-Reply-To: <30353c3d0806280800n3d6da97ewc84e1af83852197e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806271636k31f1fac7r90d1dccafde99f1b@mail.gmail.com>
	<20080628140639.GA4089@singular.sob>
	<30353c3d0806280800n3d6da97ewc84e1af83852197e@mail.gmail.com>
Cc: 
Subject: Re: stk-webcam: [RFT] Fix video_device handling
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

On Sat, Jun 28, 2008 at 11:00 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
[snip]
> According to the API, the video_device struct is not to be freed until
> it is no longer being used, thus the reason for the release callback
> in the video_device struct. Currently, video_unregister_device always
> causes the video_device struct to be freed despite the fact that it
> may still in use. To me, this is a serious bug in the videodev driver,
> since it doesn't behave as expected. The videodev driver should
> reference count the video_device struct and call the release callback
> only once it is no longer being used. I can work on this if no one
> objects.

Upon looking at video_open in videodev.c I noticed that the file_ops
were being replaced with those provided by modules calling
video_register_device. Since most modules use a const static
file_operations structure, it is impossible to overwrite the release
callback to call one within the videodev module. Thus in it's current
state, we cannot properly reference count the video_device struct. At
the moment, I see two possibilities. (1)  return an err in
__video_do_ioctl when video_devdata returns NULL or (2) implement all
possible file_operations in the videodev driver which then call the
associated file_operations in video_device.fops where defined.

Option 1 is easier to implement, but does not reference count the
video_device struct and therefore causes the release callback to occur
at inappropriate times. Option 2 requires some serious work to be done
in the videodev driver, but allows proper reference counting of the
video_device struct. By reference counting the video_device struct,
the free of the struct and the setting of video_device[minor]=NULL can
be delayed until the device is no longer in use, which may occur
during video_unregister_device or in the file_operations release
callback.

What are your opinions on this matter?

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
