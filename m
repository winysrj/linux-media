Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44491 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbcCJPge (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 10:36:34 -0500
Date: Thu, 10 Mar 2016 12:36:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix !CONFIG_MEDIA_CONTROLLER compile error for
 v4l_change_media_source()
Message-ID: <20160310123628.7a6fa3a7@recife.lan>
In-Reply-To: <1457621422-3187-1-git-send-email-shuahkh@osg.samsung.com>
References: <1457621422-3187-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Mar 2016 07:50:22 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> This error is a result of not defining v4l_change_media_source() stub
> in include/media/v4l2-mc.h for !CONFIG_MEDIA_CONTROLLER case.
> 
> Fix the following compile error:
> 
> url:    https://github.com/0day-ci/linux/commits/Shuah-Khan/media-add-change_source-handler-support/20160310-131140
> base:   git://linuxtv.org/media_tree.git master
> config: x86_64-rhel (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/media/usb/au0828/au0828-video.c: In function 'vidioc_s_input':
> >> drivers/media/usb/au0828/au0828-video.c:1474:2: error: implicit declaration of function 'v4l_change_media_source' [-Werror=implicit-function-declaration]  
>      return v4l_change_media_source(vfd);
>      ^
>    cc1: some warnings being treated as errors

If the patch was not merged upstream yet, please, instead, fold
the fix with the patch that broke the build.

> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
> 
> This patch applies on top of:
> https://lkml.org/lkml/2016/3/10/7
> 
>  include/media/v4l2-mc.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 884b969..50b9348 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -237,6 +237,11 @@ static inline int v4l_enable_media_source(struct video_device *vdev)
>  	return 0;
>  }
>  
> +static inline int v4l_change_media_source(struct video_device *vdev)
> +{
> +	return 0;
> +}
> +
>  static inline void v4l_disable_media_source(struct video_device *vdev)
>  {
>  }


-- 
Thanks,
Mauro
