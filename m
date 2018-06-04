Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42756 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753563AbeFDOei (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 10:34:38 -0400
Message-ID: <3706c4e9a9cdadfac4a40fdd9c3b15c94a338de1.camel@collabora.com>
Subject: Re: [PATCH 0/2] rockchip/rga: A fix and a cleanup
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
Date: Mon, 04 Jun 2018 11:34:30 -0300
In-Reply-To: <20180601194952.17440-1-ezequiel@collabora.com>
References: <20180601194952.17440-1-ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ccing Jacob at the right address.

Perhaps we should fix the MAINTAINERS file.

On Fri, 2018-06-01 at 16:49 -0300, Ezequiel Garcia wrote:
> Decided to test v4l2transform filters and found these two
> issues.
> 
> Without the first commit, start_streaming fails. The second
> commit is just a cleanup, removing a seemingly redundant
> operation.
> 
> Tested on RK3288 Radxa Rock2 with these kind of pipelines:
> 
> gst-launch-1.0 videotestsrc ! video/x-
> raw,width=640,height=480,framerate=30/1,format=RGB !
> v4l2video0convert ! video/x-
> raw,width=1920,height=1080,framerate=30/1,format=NV16 ! fakesink
> 
> gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-
> raw,width=640,height=480,framerate=30/1,format=RGB !
> v4l2video0convert ! video/x-
> raw,width=1920,height=1080,framerate=30/1,format=NV16 ! kmssink
> 
> Ezequiel Garcia (2):
>   rockchip/rga: Fix broken .start_streaming
>   rockchip/rga: Remove unrequired wait in .job_abort
> 
>  drivers/media/platform/rockchip/rga/rga-buf.c | 44 +++++++++------
> ----
>  drivers/media/platform/rockchip/rga/rga.c     | 13 +-----
>  drivers/media/platform/rockchip/rga/rga.h     |  2 -
>  3 files changed, 23 insertions(+), 36 deletions(-)
> 
