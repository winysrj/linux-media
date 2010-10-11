Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0JKSFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 14:05:38 -0400
Received: by fxm4 with SMTP id 4so593320fxm.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:05:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010111740.14658.hverkuil@xs4all.nl>
References: <201009261425.00146.hverkuil@xs4all.nl>
	<AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>
	<201010111740.14658.hverkuil@xs4all.nl>
Date: Mon, 11 Oct 2010 14:05:37 -0400
Message-ID: <AANLkTimA-JKRYAxin6cco2VD9-D7rJ+J_JrSEQhYZTb0@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 11, 2010 at 11:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sunday, October 10, 2010 19:33:48 David Ellingsworth wrote:
>> Hans,
>>
>> On Sun, Sep 26, 2010 at 8:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > Hi Mauro,
>> >
>> > These are the locking patches. It's based on my previous test tree, but with
>> > more testing with em28xx and radio-mr800 and some small tweaks relating to
>> > disconnect handling and video_is_registered().
>> >
>> > I also removed the unused get_unmapped_area file op and I am now blocking
>> > any further (unlocked_)ioctl calls after the device node is unregistered.
>> > The only things an application can do legally after a disconnect is unmap()
>> > and close().
>> >
>> > This patch series also contains a small em28xx fix that I found while testing
>> > the em28xx BKL removal patch.
>> >
>> > Regards,
>> >
>> >        Hans
>> >
>> > The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
>> >  Hans Verkuil (1):
>> >        V4L/DVB: tvaudio: remove obsolete tda8425 initialization
>> >
>> > are available in the git repository at:
>> >
>> >  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl
>> >
>> > Hans Verkuil (10):
>> >      v4l2-dev: after a disconnect any ioctl call will be blocked.
>> >      v4l2-dev: remove get_unmapped_area
>> >      v4l2: add core serialization lock.
>> >      videobuf: prepare to make locking optional in videobuf
>> >      videobuf: add ext_lock argument to the queue init functions
>> >      videobuf: add queue argument to videobuf_waiton()
>> >      vivi: remove BKL.
>> >      em28xx: remove BKL.
>> >      em28xx: the default std was not passed on to the subdevs
>> >      radio-mr800: remove BKL
>>
>> Did you even test these patches?
>
> Yes, I did test. And it works for me. But you are correct in that it shouldn't
> work since the struct will indeed be freed. I'll fix this and post a patch.
>
> I'm not sure why it works fine when I test it.
>
> There is a problem as well with unlocking before unregistering the device in
> that it leaves a race condition where another app can open the device again
> before it is registered. I have to think about that some more.

Actually, no this problem did not exist. The previous version of the
driver cleared the USB device member to indicate that the device had
been disconnected. During open, if the USB device member was null, it
aborted with -EIO. If there's a race there now, it's only because you
introduced it.

One thing I noticed while looking at this driver is that there's a
call to usb_autopm_put_interface in usb_amradio_close. I'm not sure if
it's a problem or not, but is it valid to call that after the device
has been disconnected? I only ask, because it wasn't called in
previous versions if the driver was disconnected before all handles to
the device were closed. If it's incorrect to call it within this
context, then this introduces another bug as well. It seems logical
that for every get there should be a put, but I don't know in this
case.

>
>>
>> Mauro, you should be ashamed for accepting a series that obviously has issues.
>
> Hardly obvious, and definitely not his fault.
>

This comment was more general, since Mauro admitted having to make
changes to your series to get it to compile under i386 architectures.

Regards,

David Ellingsworth
