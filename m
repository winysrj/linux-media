Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALEsfit030112
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 09:54:41 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALEsUGo004856
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 09:54:30 -0500
Received: by ug-out-1314.google.com with SMTP id j30so136135ugc.13
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 06:54:29 -0800 (PST)
Message-ID: <30353c3d0811210654l693c4c4evc4ae9212de35ceae@mail.gmail.com>
Date: Fri, 21 Nov 2008 09:54:29 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1227207831.1708.58.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
	<1227205179.1708.47.camel@localhost>
	<30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
	<1227207831.1708.58.camel@localhost>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [BUG] zc3xx oopses on unplug: unable to
	handle kernel paging request
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

On Thu, Nov 20, 2008 at 2:03 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Thu, 2008-11-20 at 13:57 -0500, David Ellingsworth wrote:
>> I'm not entirely sure what's going on in the gspca driver. It seems as
>> though the module count is wrong. Unfortunately, I don't have a camera
>
> No, the module count is correct, the problem is that it is incremented /
> decremented by 2 at each open / close. Don't you have the same behaviour
> with stk-webcam?
>
>> which uses this driver so it's a little hard for me to do any
>> debugging with it at this time. Technically though, freeing the
>> gspca_dev in the release callback of the video_device struct should be
>> possible and that is how it was intended to be used. The stk-webcam
>> driver has no issues using it this way either.
>
> I looked at your code, and the only difference I see is that I
> increment / decrement explicitly the subdriver module count (OK, step 1
> - this module is not the main driver which has the file operations and
> the problem!).

The v4l2-core uses a cdev struct, which is embedded in the
video_device struct. The cdev struct has a reference count that is
incremented during video_register_device and all calls to open. This
reference count is then decremented during video_unregister_device and
all calls to close. Once the reference count reaches 0 the
video_device release callback is called to free the structure as the
device is no longer in use. This is the exact same behavior given by
the kref that gspca implemented and the reason that it could be
removed.

>From looking at your repository, it appears you didn't entirely remove
your previous patch. This may in fact be the cause of the problem
since the cdev struct embedded in the video_device struct uses the
video_device's fops->owner. Before your patch this value pointed to
the gspca sub-module, it now refers to the gspca module. I don't
believe this is the right behavior since the gspca is more or less a
supporting driver that provides a set of functions for other drivers.
The sub-module is the true owner of the file_operations since it owns
the device being operated on. This may be the cause of the issue.

>
> Did you activate the slab debug and check the disconnect while
> streaming?

I didn't debug the changes to stk-webcam that I made, the driver's
maintainer did. You'll have to defer this question to him to receive
an answer. However, I don't believe stk-webcam has any issues at this
time for the reasons stated above as to how the v4l2-core works.

The ibmcam driver I had been working on uses the same implementation
seen in stk-webcam and I haven't experienced any issues with slab
debug on and disconnecting the device while it was streaming.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
