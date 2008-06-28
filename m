Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SF0LYk012617
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 11:00:21 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SF0AdB029627
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 11:00:11 -0400
Received: by fg-out-1718.google.com with SMTP id e21so533074fga.7
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 08:00:10 -0700 (PDT)
Message-ID: <30353c3d0806280800n3d6da97ewc84e1af83852197e@mail.gmail.com>
Date: Sat, 28 Jun 2008 11:00:10 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com
In-Reply-To: <20080628140639.GA4089@singular.sob>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806271636k31f1fac7r90d1dccafde99f1b@mail.gmail.com>
	<20080628140639.GA4089@singular.sob>
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

[snip]
>
> I recall working around a similar bug in the past, but the workaround
> don't seem very good now ;), and I haven't touch the driver in a while,
> so I'm not sure where is the problem. It seems that
> video_unregister_device cannot be called when the device is open.
>
> Regards,
> Jaime

Thanks for testing, I believe the the error you reported above is
indeed a result of an issue I reported on list a few days ago.
According to the API, the video_device struct is not to be freed until
it is no longer being used, thus the reason for the release callback
in the video_device struct. Currently, video_unregister_device always
causes the video_device struct to be freed despite the fact that it
may still in use. To me, this is a serious bug in the videodev driver,
since it doesn't behave as expected. The videodev driver should
reference count the video_device struct and call the release callback
only once it is no longer being used. I can work on this if no one
objects.

You are right, video_{get|set}_drvdata is obsolete as is
video_device->priv. I will replace all references to
video_{get|set}_drvdata with usb_{get|set}_drvdata(video_device->dev)
instead as suggested in v4l2-dev.h

I will hold off on this patch until videodev has been corrected to
call the callback at the appropriate time.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
