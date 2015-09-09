Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45911 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342AbbIIGxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 02:53:55 -0400
Date: Wed, 9 Sep 2015 09:53:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH] v4l2-compat-ioctl32: replace pr_warn by pr_debug
Message-ID: <20150909065351.GH3175@valkosipuli.retiisi.org.uk>
References: <55EFD467.2030208@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55EFD467.2030208@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 09, 2015 at 08:40:39AM +0200, Hans Verkuil wrote:
> Every time compat32 encounters an unknown ioctl it will call pr_warn.
> However, that's very irritating since it is perfectly normal that this
> happens. For example, applications often try to call an ioctl to see if
> it exists, and if that's used with an older kernel where compat32 doesn't
> support that ioctl yet, then it starts spamming the kernel log.
> 
> So replace pr_warn by pr_debug.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af63543..ba26a19 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1033,8 +1033,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  		ret = vdev->fops->compat_ioctl32(file, cmd, arg);
>  
>  	if (ret == -ENOIOCTLCMD)
> -		pr_warn("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
> -			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
> +		pr_debug("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
> +			 _IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_compat_ioctl32);

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
