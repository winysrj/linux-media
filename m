Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59849 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2CLKE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 06:04:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: linux-media@vger.kernel.org, spear-devel@list.st.com
Subject: Re: [PATCH 1/1] V4L/v4l2-dev: Make 'videodev_init' as a subsys initcall
Date: Mon, 12 Mar 2012 11:04:51 +0100
Message-ID: <2051000.HEIejvjnKb@avalon>
In-Reply-To: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
References: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

Thanks for the patch.

On Monday 12 March 2012 14:39:02 Bhupesh Sharma wrote:
> As the V4L2 based UVC webcam gadget (g_webcam) expects the
> 'videodev' to present when the 'webcam_bind' routine is called,
> so 'videodev' should be available as early as possible.
> 
> Now, when 'g_webcam' is built as a module (i.e. not a part of
> kernel) the late availability of 'videodev' is OK, but if
> 'g_webcam' is built statically as a part of the kernel,
> the kernel crashes (a sample crash dump using Designware 2.0 UDC
> is provided below).
> 
> To solve the same, this patch makes 'videodev_init' as a subsys initcall.
> 
> Kernel Crash Dump:
> ------------------

[snip]

> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> ---
>  drivers/media/video/v4l2-dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 96e9615..041804b 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -788,7 +788,7 @@ static void __exit videodev_exit(void)
>  	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
>  }
> 
> -module_init(videodev_init)
> +subsys_initcall(videodev_init);
>  module_exit(videodev_exit)
> 
>  MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");

Shouldn't drivers/media/media-devnode.c then use subsys_initcall() as well ?

-- 
Regards,

Laurent Pinchart

