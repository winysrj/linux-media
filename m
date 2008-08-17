Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HFBNkq009670
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 11:11:23 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HFB9w5006722
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 11:11:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Sun, 17 Aug 2008 17:09:51 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171709.51258.hverkuil@xs4all.nl>
Cc: Mike Isely <isely@isely.net>, david@identd.dyndns.org,
	linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: V4L2: switch to register_chrdev_region: needs testing/review of
	release() handling
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

Hi all,

As part of my ongoing cleanup of the v4l subsystem I've been looking 
into converting v4l from register_chrdev to register_chrdev_region. The 
latter is more flexible and allows for a larger range of minor numbers. 
In addition it allows us to intercept the release callback when the 
char device's refcount reaches 0.

This is very useful for hotpluggable devices like USB webcams. Currently 
usb video drivers need to do the refcounting themselves, but with this 
patch they can rely on the release callback since it will only be 
called when the last user has closed the device. Since current usb 
drivers do the refcounting in varying degrees of competency (from 'not' 
to 'if you're lucky' to 'buggy' to 'perfect') it would be nice to have 
the v4l framework take care of this.

So on a disconnect the driver can call video_unregister_device() even if 
an application still has the device open. Only when the application 
closes as well will the release be called and the driver can do the 
final cleanup.

In fact, I think with this change it should even be possible to 
reconnect the webcam even while some application is still using the old 
char device. In that case a new minor number will be chosen since the 
old one is still in use, but otherwise the webcam should just work as 
usual. This is untested, though.

Note that right now I basically copy the old release callback as 
installed by cdev_init() and install our own v4l callback instead (to 
be precise, I replace the ktype pointer with our own kobj_type).

It would be much cleaner if chardev.c would allow one to set a callback 
explicitly. It's not difficult to do that, but before doing that I 
first have to know whether my approach is working correctly.

The v4l-dvb repository with my changes is here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/

To see the diff in question:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/rev/98acd2c1dea1

I have tested myself with the quickcam_messenger webcam. For this driver 
this change actually fixed a bug: disconnecting while a capture was in 
progress and then trying to use /dev/video0 would lock that second 
application.

I also tested with gspca: I could find no differences here, it all 
worked as before.

There are a lot more USB video devices and it would be great if people 
could test with their devices to see if this doesn't break anything. 
Having a release callback that is called when it is really safe to free 
everything should make life a lot easier I think.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
