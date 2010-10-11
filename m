Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0JKOpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 10:45:47 -0400
Received: by fxm4 with SMTP id 4so455561fxm.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 07:45:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>
References: <201009261425.00146.hverkuil@xs4all.nl>
	<AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>
Date: Mon, 11 Oct 2010 10:45:45 -0400
Message-ID: <AANLkTinuip0vHe9WOpy_YuTQd-oVDtzxQx6Xpdbn9YyT@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 10, 2010 at 1:33 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> Hans,
>
> On Sun, Sep 26, 2010 at 8:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Mauro,
>>
>> These are the locking patches. It's based on my previous test tree, but with
>> more testing with em28xx and radio-mr800 and some small tweaks relating to
>> disconnect handling and video_is_registered().
>>
>> I also removed the unused get_unmapped_area file op and I am now blocking
>> any further (unlocked_)ioctl calls after the device node is unregistered.
>> The only things an application can do legally after a disconnect is unmap()
>> and close().
>>
>> This patch series also contains a small em28xx fix that I found while testing
>> the em28xx BKL removal patch.
>>
>> Regards,
>>
>>        Hans
>>
>> The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
>>  Hans Verkuil (1):
>>        V4L/DVB: tvaudio: remove obsolete tda8425 initialization
>>
>> are available in the git repository at:
>>
>>  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl
>>
>> Hans Verkuil (10):
>>      v4l2-dev: after a disconnect any ioctl call will be blocked.
>>      v4l2-dev: remove get_unmapped_area
>>      v4l2: add core serialization lock.
>>      videobuf: prepare to make locking optional in videobuf
>>      videobuf: add ext_lock argument to the queue init functions
>>      videobuf: add queue argument to videobuf_waiton()
>>      vivi: remove BKL.
>>      em28xx: remove BKL.
>>      em28xx: the default std was not passed on to the subdevs
>>      radio-mr800: remove BKL
>
> Did you even test these patches? The last one in the series clearly
> breaks radio-mr800 and the commit message does not describe the
> changes made. radio-mr800 has been BKL independent for quite some
> time. Hans, you of all people should know that calling
> video_unregister_device could result in the driver specific structure
> being freed. The mutex must therefore be unlocked _before_ calling
> video_unregister_device. Otherwise you're passing freed memory to
> mutex_unlock in usb_amradio_disconnect.
>

To reiterate, the video_device struct is part of the amradio_device
struct. When video_device_unregister is called, it can cause the
release callback of the video_device struct to be called. In this
case, that results in usb_amradio_video_device_release being called
which frees the amradio_device struct. Therefore any use of the
amradio_device struct after calling video_device_unregister is a
potential use after free error. In this particular case you are trying
to access the amradio_device.lock member which has potentially been
freed already.

Regards,

David Ellingsworth
