Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MAroeK016726
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 06:53:51 -0400
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MArc7l001040
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 06:53:39 -0400
Message-ID: <21808.62.70.2.252.1216724018.squirrel@webmail.xs4all.nl>
Date: Tue, 22 Jul 2008 12:53:38 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: RFC: Add support to query and change connections inside a
 media device
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

>> It's very similar. In fact, it's almost identical if it wasn't for some
>> V4L2 contraints. The main interesting feature I noticed in the
>> gstreamer concept is 'binning'. I'm wondering if that can be used to
>> group the related devices together, but I don't quite see how that
>> would work right now.
>
> Hans, what desktop are you using :) ? Just wonder.

FYI: it's KDE.

> This long proposal really makes me think a lot about the very bad
> interoperation between userspace developers and kernel ones. The
> gstreamer usage seems obvious and the question is what constrains are
> you talking about?

The fact that we cannot break the current API. In particular, things like
'elements' and 'pads' are all mixed together in the current API. E.g.
/dev/video0 can be seen as a pad (since you get the frames from the
devices), an element (you control hue, brightness, etc.) and another pad
(which input do you use: tuner, composite or S-Video in?).

> It will be quite easy for userspace developers to put
> audio and video streams in a bin, redirect it wherever you like and pass
> it through devices, probably hardware-based.

Not sure what your point is.

> Another issue is device enumeration. While increasing amount of apps use
> HAL to get information about system hardware why do we need to support
> v4l-specific ioctls? For example DVB manager in GNOME SoC project works
> with HAL.

Where do you think HAL gets its information from? From the point of view
of the driver HAL is just an application. One of the problems that right
now is that it is very difficult to piece together all the devices that a
single driver can create.

I can imagine that HAL would read the controller device to get all the
information it needs for a specific media board. Now, I admit I know next
to nothing about how HAL works, but that sounds reasonable :-)

Regards,

      Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
