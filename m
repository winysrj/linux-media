Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab0I3LzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 07:55:24 -0400
Message-ID: <4CA47AA9.8040403@redhat.com>
Date: Thu, 30 Sep 2010 08:55:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
References: <201009261425.00146.hverkuil@xs4all.nl>
In-Reply-To: <201009261425.00146.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-09-2010 09:25, Hans Verkuil escreveu:
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
> 	Hans
> 
> The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
>   Hans Verkuil (1):
>         V4L/DVB: tvaudio: remove obsolete tda8425 initialization
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl

Applied, thanks.

> Hans Verkuil (10):
>       v4l2-dev: after a disconnect any ioctl call will be blocked.
>       v4l2-dev: remove get_unmapped_area
>       v4l2: add core serialization lock.
>       videobuf: prepare to make locking optional in videobuf
>       videobuf: add ext_lock argument to the queue init functions
>       videobuf: add queue argument to videobuf_waiton()

You forgot two to add the extra parameter on two drivers that uses vmalloc,
noticed when I tried to compile it for i386 arch. I've already added them.

Could you please double check if everything is compiling fine on the other archs?

Thanks,
Mauro
