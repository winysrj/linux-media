Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44001 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750942AbdEIG3M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 02:29:12 -0400
Subject: Re: [patch, libv4l]: fix integer overflow
To: Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan> <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan> <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com> <20170508222819.GA14833@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Date: Tue, 9 May 2017 08:29:06 +0200
MIME-Version: 1.0
In-Reply-To: <20170508222819.GA14833@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/2017 12:28 AM, Pavel Machek wrote:
> Hi!
> 
> This bit me while trying to use absolute exposure time on Nokia N900:
> 
> Can someone apply it to libv4l2 tree? Could I get some feedback on the
> other patches? Is this the way to submit patches to libv4l2?

Yes, it is. But I do need a Signed-off-by from you.

Regards,

	Hans

> 
> Thanks,
> 								Pavel
> 
> commit 0484e39ec05fdc644191e7c334a7ebfff9cb2ec5
> Author: Pavel <pavel@ucw.cz>
> Date:   Mon May 8 21:52:02 2017 +0200
> 
>     Fix integer overflow with EXPOSURE_ABSOLUTE.
> 
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index e795aee..189fc06 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -1776,7 +1776,7 @@ int v4l2_set_control(int fd, int cid, int value)
>  		if (qctrl.type == V4L2_CTRL_TYPE_BOOLEAN)
>  			ctrl.value = value ? 1 : 0;
>  		else
> -			ctrl.value = (value * (qctrl.maximum - qctrl.minimum) + 32767) / 65535 +
> +			ctrl.value = ((long long) value * (qctrl.maximum - qctrl.minimum) + 32767) / 65535 +
>  				qctrl.minimum;
>  
>  		result = v4lconvert_vidioc_s_ctrl(devices[index].convert, &ctrl);
> @@ -1812,7 +1812,7 @@ int v4l2_get_control(int fd, int cid)
>  		if (v4l2_propagate_ioctl(index, VIDIOC_G_CTRL, &ctrl))
>  			return -1;
>  
> -	return ((ctrl.value - qctrl.minimum) * 65535 +
> +	return (((long long) ctrl.value - qctrl.minimum) * 65535 +
>  			(qctrl.maximum - qctrl.minimum) / 2) /
>  		(qctrl.maximum - qctrl.minimum);
>  }
> 
> 
