Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41815 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753411Ab3HVXp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 19:45:29 -0400
Date: Fri, 23 Aug 2013 02:44:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 03/10] v4l2-compat-ioctl32: add g/s_matrix support.
Message-ID: <20130822234453.GA2114@valkosipuli.retiisi.org.uk>
References: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
 <8b4d154fc2351c7c1f2999bfec665011dd0afdb9.1377166147.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b4d154fc2351c7c1f2999bfec665011dd0afdb9.1377166147.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 22, 2013 at 12:14:17PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 49 +++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8f7a6a4..3e5a30f 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -777,6 +777,38 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
>  	return 0;
>  }
>  
> +struct v4l2_matrix32 {
> +	__u32 type;
> +	union {
> +		__u32 raw[4];
> +	} ref;

I sense untested code h(re. :-)

> +	struct v4l2_rect rect;
> +	compat_caddr_t matrix;
> +	__u32 reserved[12];
> +} __attribute__ ((packed));

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
