Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBICaSdg014060
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 07:36:28 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBICa7B9009423
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 07:36:08 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Thu, 18 Dec 2008 13:36:09 +0100
References: <200812180109.51813.hverkuil@xs4all.nl> <494A2492.2050106@hhs.nl>
In-Reply-To: <494A2492.2050106@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181336.09846.laurent.pinchart@skynet.be>
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

On Thursday 18 December 2008, Hans de Goede wrote:
> <resend with reply to all>
>
> Hans Verkuil wrote:
> > Hi all,
> >
> > My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev release
> > code in favor of using the refcounting and release callback from the
> > device struct. Based on the discussion on the kernel list regarding the
> > use of cdev refcounting it became clear that that was not the right
> > solution, hence this change.
>
> I haven't tested it, but I have reviewed it. In general it looks ok, but:
>
> I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
> videodev_lock in video_register_device_index until completely done? It is
> not like these are functions which will get called many times a second.
> This will also lead to cleaner code.
>
> The correct return code in v4l2_open when cfd == NULL, so the device has
> been removed underneath the open call is -ENODEV, not -EBUSY.
>
> last, device_* seem to have the same problem as cdev_*, when
> video_unregister_device and v4l2_release race, we can still end up with a
> kref_put race. I see you've fixed this by taking videodev_lock around
> device_unregister() and device_put(), but IMHO this really should happen in
> drivers/base/core.c, other drivers might vary well hit the same issue.
> Seems you need to hit gkh a bit more with that clue stick of yours :) (note
> this last one is not a blocker, but would be nice to get fixed eventually).

That would be a performance killer. We need a global lock to prevent races, 
and I'm pretty sure a single global lock across all devices will be rejected 
(especially if it's a mutex). Handling locking at the subsystem level still 
requires a global lock, but we will have one per subsystem.

Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
