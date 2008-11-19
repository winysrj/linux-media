Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJDqpYQ020084
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 08:52:51 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJDqbbi020503
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 08:52:37 -0500
Received: by ug-out-1314.google.com with SMTP id j30so537580ugc.13
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 05:52:35 -0800 (PST)
Message-ID: <30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:52:35 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1227090732.2998.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<200811162224.47885.m.kozlowski@tuxland.pl>
	<1227034668.1703.4.camel@localhost>
	<200811182219.38925.m.kozlowski@tuxland.pl>
	<1227090732.2998.8.camel@localhost>
Cc: v4l-dvb-maintainer@linuxtv.org, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	video4linux-list@redhat.com
Subject: Re: [BUG] zc3xx oopses on unplug: unable to handle kernel paging
	request
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

> Hi Mariusz,
>
> You have the oops thanks to poison and it is not enabled in my kernel.
>
> I found the real bug: the device structure was part of the gspca device
> and it was freed on close after webcam unplug while streaming.

Jean-Francois,

I reviewed your patch and in my opinion it is the wrong thing to do.
With the recent modifications to v4l2 it is very safe and practical to
embed the video_device struct within a driver struct. The containing
structure however should not be freed until the release callback in
the video_device structure is called. This callback is called after
all open handles have been closed, it is no longer called immediately
after video_unregister_device is called.

The v4l2 subsystem was changed since every driver using v4l2 would
have needed to implement a reference count in order to properly insure
any structure containing the video_device struct was not freed at
inappropriate times. Removing this responsibility from every
sub-driver was a very practical thing to do since it helped reduce
redundant code and increase readability.

For an example of how this should be done, please review the
stk-webcam driver in the v4l-dvb hg repository. I updated it not to
long ago to take advantage of the changes made to the v4l2 subsystem.
The net effect of the changes was a reduction of about 80 lines of
code from the stk-webcam driver, while far less than that were needed
in the v4l2 subsystem.

Regards,

David Ellingsworth

>
> I join a patch I merged from the linux-2.6.28-rc5 source (not compiled -
> the original patch is the last one in my mercurial repository).
>
> Thanks again.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
