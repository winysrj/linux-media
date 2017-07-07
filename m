Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52303
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750778AbdGGOiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 10:38:10 -0400
Subject: Re: [PATCH 04/12] [media] uvc: enable subscriptions to other events
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-5-gustavo@padovan.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <c49b13ab-3fd9-e5f2-1a8f-59f72e2e12b8@osg.samsung.com>
Date: Fri, 7 Jul 2017 08:38:07 -0600
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-5-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 01:39 AM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Call v4l2_ctrl_subscribe_event to subscribe to more events supported by
> v4l.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 3e7e283..dfa0ccd 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -1240,7 +1240,7 @@ static int uvc_ioctl_subscribe_event(struct v4l2_fh *fh,
>  	case V4L2_EVENT_CTRL:
>  		return v4l2_event_subscribe(fh, sub, 0, &uvc_ctrl_sub_ev_ops);
>  	default:
> -		return -EINVAL;
> +		return v4l2_ctrl_subscribe_event(fh, sub);

This looks incorrect. With this change driver will be subscribing to all
v4l2 events? Is this the intent?

>  	}
>  }
>  
> 

thanks,
-- Shuah
