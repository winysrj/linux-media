Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:49013 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbcFOGJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 02:09:31 -0400
Subject: Re: [PATCH] [media] v4l2-ioctl.c: fix warning due wrong check in
 v4l_cropcap()
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1465935497-30002-1-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5760F114.6010809@xs4all.nl>
Date: Wed, 15 Jun 2016 08:09:24 +0200
MIME-Version: 1.0
In-Reply-To: <1465935497-30002-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2016 10:18 PM, Javier Martinez Canillas wrote:
> Commit 95dd7b7e30f3 ("[media] v4l2-ioctl.c: improve cropcap compatibility
> code") tried to check if both .vidioc_cropcap and .vidioc_g_selection are
> NULL ops and warn if that was the case, but unfortunately the logic isn't
> correct and instead checks for .vidioc_cropcap == NULL twice.
> 
> So the v4l2 core will print the following warning if a driver has the ops
> .vidioc_g_selection set but no .vidioc_cropcap callback:

This fix is already queued up for 4.7.

Regards,

	Hans

> 
> WARNING: CPU: 2 PID: 4058 at drivers/media/v4l2-core/v4l2-ioctl.c:2174 v4l_cropcap+0x188/0x198 [videodev]
> [<c010e1ac>] (unwind_backtrace) from [<c010af38>] (show_stack+0x10/0x14)
> [<c010af38>] (show_stack) from [<c032481c>] (dump_stack+0x88/0x9c)
> [<c032481c>] (dump_stack) from [<c011a82c>] (__warn+0xe8/0x100)
> [<c011a82c>] (__warn) from [<c011a8f4>] (warn_slowpath_null+0x20/0x28)
> [<c011a8f4>] (warn_slowpath_null) from [<bf04a9ec>] (v4l_cropcap+0x188/0x198 [videodev])
> [<bf04a9ec>] (v4l_cropcap [videodev]) from [<bf04c728>] (__video_do_ioctl+0x298/0x30c [videodev])
> [<bf04c728>] (__video_do_ioctl [videodev]) from [<bf04c110>] (video_usercopy+0x174/0x4e8 [videodev])
> [<bf04c110>] (video_usercopy [videodev]) from [<bf0475c8>] (v4l2_ioctl+0xc4/0xd8 [videodev])
> [<bf0475c8>] (v4l2_ioctl [videodev]) from [<c01efa78>] (do_vfs_ioctl+0x9c/0x8e4)
> [<c01efa78>] (do_vfs_ioctl) from [<c01f02f4>] (SyS_ioctl+0x34/0x5c)
> [<c01f02f4>] (SyS_ioctl) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)
> 
> Fixes: 95dd7b7e30f3 ("[media] v4l2-ioctl.c: improve cropcap compatibility code")
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 28e5be2c2eef..528390f33b53 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2171,7 +2171,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>  	 * The determine_valid_ioctls() call already should ensure
>  	 * that this can never happen, but just in case...
>  	 */
> -	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
> +	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
>  		return -ENOTTY;
>  
>  	if (ops->vidioc_cropcap)
> 
