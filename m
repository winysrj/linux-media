Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIANofP006132
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 05:23:50 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIANhRo031675
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 05:23:44 -0500
Message-ID: <494A2492.2050106@hhs.nl>
Date: Thu, 18 Dec 2008 11:23:14 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200812180109.51813.hverkuil@xs4all.nl>
In-Reply-To: <200812180109.51813.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Please test: using the device release() callback instead of the
 cdev release
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

<resend with reply to all>

Hans Verkuil wrote:
> Hi all,
> 
> My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev release code 
> in favor of using the refcounting and release callback from the device 
> struct. Based on the discussion on the kernel list regarding the use of 
> cdev refcounting it became clear that that was not the right solution, 
> hence this change.
> 

I haven't tested it, but I have reviewed it. In general it looks ok, but:

I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
videodev_lock in video_register_device_index until completely done? It is not
like these are functions which will get called many times a second. This will
also lead to cleaner code.

The correct return code in v4l2_open when cfd == NULL, so the device has been
removed underneath the open call is -ENODEV, not -EBUSY.

last, device_* seem to have the same problem as cdev_*, when
video_unregister_device and v4l2_release race, we can still end up with a
kref_put race. I see you've fixed this by taking videodev_lock around
device_unregister() and device_put(), but IMHO this really should happen in
drivers/base/core.c, other drivers might vary well hit the same issue. Seems
you need to hit gkh a bit more with that clue stick of yours :) (note this last
one is not a blocker, but would be nice to get fixed eventually).

Regards,

Hans (the other Hans)


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
