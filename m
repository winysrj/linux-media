Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41264 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbbCZQsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 12:48:51 -0400
Message-ID: <5514386C.2020305@xs4all.nl>
Date: Thu, 26 Mar 2015 09:48:44 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC] v4l2-ctl: don't exit on VIDIOC_QUERYCAP error for subdevices
References: <1427361704-32456-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427361704-32456-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2015 02:21 AM, Philipp Zabel wrote:
> Subdevice nodes don't implement VIDIOC_QUERYCAP. This check doesn't
> allow any operations on v42-subdev nodes, such as setting EDID.

Nack because I'm going to create a proper VIDIOC_SUBDEV_QUERYCAP for
subdevs. I'm planning to work on this next week.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  utils/v4l2-ctl/v4l2-ctl.cpp | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index b340af7..211372b 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -1149,10 +1149,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	verbose = options[OptVerbose];
> -	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
> -		fprintf(stderr, "%s: not a v4l2 node\n", device);
> -		exit(1);
> -	}
> +	doioctl(fd, VIDIOC_QUERYCAP, &vcap);
>  	capabilities = vcap.capabilities;
>  	if (capabilities & V4L2_CAP_DEVICE_CAPS)
>  		capabilities = vcap.device_caps;
> 

