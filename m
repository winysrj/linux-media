Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKIvhQL013833
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 13:57:43 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAKIvVFL014844
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 13:57:32 -0500
Received: by fk-out-0910.google.com with SMTP id e30so620884fke.3
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 10:57:30 -0800 (PST)
Message-ID: <30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
Date: Thu, 20 Nov 2008 13:57:30 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1227205179.1708.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
	<1227205179.1708.47.camel@localhost>
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

On Thu, Nov 20, 2008 at 1:19 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Wed, 2008-11-19 at 22:56 +0100, Mariusz Kozlowski wrote:
>> > Here is a patch fixing this by using the ref counting already built
>> > into the
>> > v4l2-core. Jean-Francois, this is to be applied after reverting your
>> > fix for this.
>>
>> Not sure I understand what should be applied where. I applied your -
>> Hans - patch to
>> 2.6.28-rc5-00117-g7f0f598. As you see my HEAD in linux-2.6 is at
>> 7f0f598a0069d1ab072375965a4b69137233169c and I can reproduce the oops
>> easily.
>> I turned on all possible debuging in gspca as well. If it should be
>> applied to
>> some other tree which contains some more fixes for this - my fault.
>> Please let me know.
>
> Hi Hans (de Goede) and Hans (Verkuil),
>
> As you saw, the patch does not work.
>
> Looking at the modules, when a webcam is streaming, the module refcount
> of the gspca_main is 3: 1 for the subdriver dependancies, and 2 for one
> open. Why 2?
>
> I did not look carefully at the I/O system, but it seems there are two
> objects / operations associated to the device. When a disconnection
> occurs while the device is opened, at close time, there is:
> - a first object put of the device which makes it to be released,
> - this release should do a first module_put and then
> - calls the gspca_release (see the patch) which frees the gspca device
>  (and also the video device which is embedded),
> - then, the close job is not finished: a second module_put is called
>  with the fops of the device,
> - as this one is in a non allocated memory and as the slab debug is
>  active: oops!
>
> All this is may be found in the function __fput of fs/file_table.c.
>
> I was wondering if the gspca device could not be freed by the release of
> the video device, i.e. what happens if there is no 'kfree(gspca_dev)' in
> the gspca_release()?

I'm not entirely sure what's going on in the gspca driver. It seems as
though the module count is wrong. Unfortunately, I don't have a camera
which uses this driver so it's a little hard for me to do any
debugging with it at this time. Technically though, freeing the
gspca_dev in the release callback of the video_device struct should be
possible and that is how it was intended to be used. The stk-webcam
driver has no issues using it this way either.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
