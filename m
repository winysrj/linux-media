Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:44764 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752738AbeADLbq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 06:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180104103215.15591-3-arnd@arndb.de>
References: <20180104103215.15591-1-arnd@arndb.de> <20180104103215.15591-3-arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 4 Jan 2018 12:31:45 +0100
Message-ID: <CAK8P3a1r_1k-Ei5DPTWba6ZjuFoE13H8sJGL-R4zu0q520KMag@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: au0828: add VIDEO_V4L2 dependency
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 11:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> After the move of videobuf2 into the common directory, selecting the
> au0828 driver with CONFIG_V4L2 disabled started causing a link failure,
> as we now attempt to build videobuf2 but it still requires v4l2:
>
> ERROR: "v4l2_event_pending" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
> ERROR: "v4l2_fh_release" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
> ERROR: "video_devdata" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
> ERROR: "__tracepoint_vb2_buf_done" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!
> ERROR: "__tracepoint_vb2_dqbuf" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!
> ERROR: "v4l_vb2q_enable_media_source" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!
>
> This adds the same dependency in au0828 that the other users of videobuf2
> have.
>
> Fixes: 03fbdb2fc2b8 ("media: move videobuf2 to drivers/media/common")
> Fixes: 05439b1a3693 ("[media] media: au0828 - convert to use videobuf2")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

On a further look, this prevents us from building the RC driver without the V4L2
driver, which was the reason this driver is split. I'll send a v2, but
it needs more
randconfig testing than this version.

        Arnd
