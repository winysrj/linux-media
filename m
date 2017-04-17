Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51751
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753810AbdDQTvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 15:51:38 -0400
Date: Mon, 17 Apr 2017 16:51:32 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Document the practice of symmetrically calling
 s_power(dev, 0/1)
Message-ID: <20170417165132.18ab9fc5@vento.lan>
In-Reply-To: <1489060485-15618-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1489060485-15618-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  9 Mar 2017 13:54:45 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The caller must always call the s_power() op symmetrically powering the
> device on and off. This is the practice albeit it was not documented. A
> lot of sub-device drivers rely on it, so document it accordingly.

Actually, there are several non-embedded drivers that don't call s_power()
symmetrically, as they use it just put a sub-device in standby mode.
I remember some widely used tuners that has this behavior. Such subdevs
automatically awaken when a command is issued to them (for example,
requesting the tuner to tune into a channel).

If you're willing to change the kABI, you need first to patch such
drivers.

Regards,
Mauro

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/v4l2-subdev.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 0ab1c5d..b4e521d 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -172,8 +172,10 @@ struct v4l2_subdev_io_pin_config {
>   *
>   * @s_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
>   *
> - * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
> - *	mode (on == 1).
> + * @s_power: Puts subdevice in power saving mode (on == 0) or normal operation
> + *	mode (on == 1). The caller is responsible for calling the op
> + *	symmetrically, i.e. calling s_power(dev, 1) once requires later calling
> + *	s_power(dev, 0) once.
>   *
>   * @interrupt_service_routine: Called by the bridge chip's interrupt service
>   *	handler, when an interrupt status has be raised due to this subdev,



Thanks,
Mauro
