Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38101 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab0JJRdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 13:33:50 -0400
Received: by fxm4 with SMTP id 4so126619fxm.19
        for <linux-media@vger.kernel.org>; Sun, 10 Oct 2010 10:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009261425.00146.hverkuil@xs4all.nl>
References: <201009261425.00146.hverkuil@xs4all.nl>
Date: Sun, 10 Oct 2010 13:33:48 -0400
Message-ID: <AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

On Sun, Sep 26, 2010 at 8:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Mauro,
>
> These are the locking patches. It's based on my previous test tree, but with
> more testing with em28xx and radio-mr800 and some small tweaks relating to
> disconnect handling and video_is_registered().
>
> I also removed the unused get_unmapped_area file op and I am now blocking
> any further (unlocked_)ioctl calls after the device node is unregistered.
> The only things an application can do legally after a disconnect is unmap()
> and close().
>
> This patch series also contains a small em28xx fix that I found while testing
> the em28xx BKL removal patch.
>
> Regards,
>
>        Hans
>
> The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
>  Hans Verkuil (1):
>        V4L/DVB: tvaudio: remove obsolete tda8425 initialization
>
> are available in the git repository at:
>
>  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl
>
> Hans Verkuil (10):
>      v4l2-dev: after a disconnect any ioctl call will be blocked.
>      v4l2-dev: remove get_unmapped_area
>      v4l2: add core serialization lock.
>      videobuf: prepare to make locking optional in videobuf
>      videobuf: add ext_lock argument to the queue init functions
>      videobuf: add queue argument to videobuf_waiton()
>      vivi: remove BKL.
>      em28xx: remove BKL.
>      em28xx: the default std was not passed on to the subdevs
>      radio-mr800: remove BKL

Did you even test these patches? The last one in the series clearly
breaks radio-mr800 and the commit message does not describe the
changes made. radio-mr800 has been BKL independent for quite some
time. Hans, you of all people should know that calling
video_unregister_device could result in the driver specific structure
being freed. The mutex must therefore be unlocked _before_ calling
video_unregister_device. Otherwise you're passing freed memory to
mutex_unlock in usb_amradio_disconnect.

If each patch had been properly posted to the list, others might have
caught issues like this earlier. Posting a link to a repository is no
substitute for this process.

Mauro, you should be ashamed for accepting a series that obviously has issues.

Regards,

David Ellingsworth
