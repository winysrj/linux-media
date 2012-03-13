Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:38232 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483Ab2CMDcY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 23:32:24 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 13 Mar 2012 11:31:31 +0800
Subject: RE: [PATCH] media: Initialize the media core with subsys_initcall()
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA2BA2212@EAPEX1MAIL1.st.com>
References: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
 <1331560967-32396-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331560967-32396-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, March 12, 2012 7:33 PM
> To: linux-media@vger.kernel.org
> Cc: Bhupesh SHARMA
> Subject: [PATCH] media: Initialize the media core with
> subsys_initcall()
> 
> Media-related drivers living outside drivers/media/ (such as the UVC
> gadget driver in drivers/usb/gadget/) rely on the media core being
> initialized before they're probed. As drivers/usb/ is linked before
> drivers/media/, this is currently not the case and will lead to crashes
> if the drivers are not compiled as modules.
> 
> Register media_devnode_init() as a subsys_initcall() instead of
> module_init() to fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/media-devnode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

> Bhupesh, do you plan to send a pull request with your "V4L/v4l2-dev:
> Make
> 'videodev_init' as a subsys initcall" patch, or would you like me to
> take it
> in my tree ? I'd like both patches to go in at the same time, with this
> one
> coming first to avoid any risk of bisection issue.

I would prefer that you take my patch also in your tree and have
a single pull request for both the patches as they solve the same
issue and hence must be pulled at the same time.

For your patch:
Acked-By: Bhupesh Sharma <bhupesh.sharma@st.com>

> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-
> devnode.c
> index 7b42ace..421cf73 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -312,7 +312,7 @@ static void __exit media_devnode_exit(void)
>  	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
>  }
> 
> -module_init(media_devnode_init)
> +subsys_initcall(media_devnode_init);
>  module_exit(media_devnode_exit)
> 
>  MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> --

Regards,
Bhupesh
