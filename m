Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52773 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbbGCSIx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 14:08:53 -0400
Date: Fri, 3 Jul 2015 15:08:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-pm@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] [media] v4l2-core: Implement
 dev_pm_ops.prepare()
Message-ID: <20150703150846.4eb8b032@recife.lan>
In-Reply-To: <1428065887-16017-6-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
	<1428065887-16017-6-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Em Fri,  3 Apr 2015 14:57:54 +0200
Tomeu Vizoso <tomeu.vizoso@collabora.com> escreveu:

> Have it return 1 so that video devices that are runtime-suspended won't
> be suspended when the system goes to a sleep state. This can make resume
> times considerably shorter because these devices don't need to be
> resumed when the system is awaken.

I'm not a PM exprert, but that patch doesn't sound right. Not all devices
supported by v4l2-dev implement runtime suspend.

So, I guess this need to be done at driver level, not at core level.

> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index e2b8b3e..b74e3d3 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -219,9 +219,19 @@ static void v4l2_device_release(struct device *cd)
>  		v4l2_device_put(v4l2_dev);
>  }
>  
> +static int video_device_prepare(struct device *dev)
> +{
> +	return 1;
> +}
> +
> +static const struct dev_pm_ops video_device_pm_ops = {
> +	.prepare = video_device_prepare,
> +};
> +
>  static struct class video_class = {
>  	.name = VIDEO_NAME,
>  	.dev_groups = video_device_groups,
> +	.pm = &video_device_pm_ops,
>  };
>  
>  struct video_device *video_devdata(struct file *file)
