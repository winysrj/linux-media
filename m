Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FFLAUE011574
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:21:10 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0FFKNna026669
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:20:24 -0500
Received: by bwz13 with SMTP id 13so3248949bwz.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 07:20:23 -0800 (PST)
Message-ID: <d9def9db0901150720n53ca549dobaa0034b9a21072a@mail.gmail.com>
Date: Thu, 15 Jan 2009 16:20:23 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Carsten Meier" <cm@trexity.de>
In-Reply-To: <20090115154111.36cc25d1@tuvok>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090115154111.36cc25d1@tuvok>
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

On Thu, Jan 15, 2009 at 3:41 PM, Carsten Meier <cm@trexity.de> wrote:
> Hello list,
>
> we recently had a discussion on the pvrusb2-list on how to identify a
> video-device connected via USB from an userspace app. (Or more precisely
> on how to associate config-data with a particular device). This led to
> a patch which returned the device's serial-no. in v4l2_capability's
> bus_info field. This one has been rejected, but I really feel that this
> is the right way to go. Here's the thread:
> http://www.isely.net/pipermail/pvrusb2/2009-January/002091.html
>
> I think the meaning of the bus_info-field should be modified slightly
> for USB-devices to reflect its dynamic nature. At least a string that
> won't change on dis-/reconnect and standby/wake-up-cycles should be
> returned. If a device has a unique serial-no. it is a perfect candidate
> for this, if not, some USB-port-info should be returned that won't
> change if the device is connected to the same port through the same hub.
>
> What do you think?
> (BTW: I'm not a kernel-hacker, I'm writing this from the perspective of
> an app-developer)
>

write a few shellscripts and parse sysfs, or attach your application
to sysfs that it will
be notified if a device gets added. dbus is also a tip. no need to
hook up drivers
with some special things there.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
