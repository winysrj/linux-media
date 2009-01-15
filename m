Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FFYOeq023204
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:34:24 -0500
Received: from dd18532.kasserver.com (dd18532.kasserver.com [85.13.139.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FFXofa015471
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:33:50 -0500
Date: Thu, 15 Jan 2009 16:33:48 +0100
From: Carsten Meier <cm@trexity.de>
To: "Markus Rechberger" <mrechberger@gmail.com>
Message-ID: <20090115163348.5da9932a@tuvok>
In-Reply-To: <d9def9db0901150720n53ca549dobaa0034b9a21072a@mail.gmail.com>
References: <20090115154111.36cc25d1@tuvok>
	<d9def9db0901150720n53ca549dobaa0034b9a21072a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: How to identify USB-video-devices
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

Am Thu, 15 Jan 2009 16:20:23 +0100
schrieb "Markus Rechberger" <mrechberger@gmail.com>:

> On Thu, Jan 15, 2009 at 3:41 PM, Carsten Meier <cm@trexity.de> wrote:
> > Hello list,
> >
> > we recently had a discussion on the pvrusb2-list on how to identify
> > a video-device connected via USB from an userspace app. (Or more
> > precisely on how to associate config-data with a particular
> > device). This led to a patch which returned the device's serial-no.
> > in v4l2_capability's bus_info field. This one has been rejected,
> > but I really feel that this is the right way to go. Here's the
> > thread:
> > http://www.isely.net/pipermail/pvrusb2/2009-January/002091.html
> >
> > I think the meaning of the bus_info-field should be modified
> > slightly for USB-devices to reflect its dynamic nature. At least a
> > string that won't change on dis-/reconnect and
> > standby/wake-up-cycles should be returned. If a device has a unique
> > serial-no. it is a perfect candidate for this, if not, some
> > USB-port-info should be returned that won't change if the device is
> > connected to the same port through the same hub.
> >
> > What do you think?
> > (BTW: I'm not a kernel-hacker, I'm writing this from the
> > perspective of an app-developer)
> >
> 
> write a few shellscripts and parse sysfs, or attach your application
> to sysfs that it will
> be notified if a device gets added. dbus is also a tip. no need to
> hook up drivers
> with some special things there.
> 
> regards,
> Markus

But according to the docs, the bus_info-field is intended for the
purpose of identifying particular devices. Other solutions may be
possible, but they are much more complex and much more sensible to
other kernel-changes. By using bus_info, there is a simple and clean
solution that only depends on the V4L2-API and it also reflects the
primary intention of the field.

Other USB-device-drivers aren't required to change to the new policy,
their current bus_info-string (if implemented like in pvrusb2) changes
on every reconnect and standby/wake-up-cycle and is of no use anyway
for any app.

I really think that current behaviour is broken.

Regards,
Carsten

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
