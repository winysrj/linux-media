Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26628 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753519AbdGNMnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 08:43:17 -0400
Date: Fri, 14 Jul 2017 15:41:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        adi-buildroot-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
Message-ID: <20170714124132.u3fzpetbh3b7gj7f@mwanda>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714093938.1469319-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714093938.1469319-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 11:36:56AM +0200, Arnd Bergmann wrote:
> @@ -1158,7 +1158,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
>  	 */
>  	fmt_src.pad = pad->index;
>  	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
> +	ret = v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src);
> +	if (!ret) {
>  		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
>  		depth_in = fmt_info->width;
>  	}

Is the original code buggy?

media/platform/omap3isp/ispccdc.c
  1156          /* Compute the lane shifter shift value and enable the bridge when the
  1157           * input format is a non-BT.656 YUV variant.
  1158           */
  1159          fmt_src.pad = pad->index;
  1160          fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
  1161          if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
  1162                  fmt_info = omap3isp_video_format_info(fmt_src.format.code);
  1163                  depth_in = fmt_info->width;
  1164          }

If v4l2_subdev_call() then depth_in is zero.

  1165  
  1166          fmt_info = omap3isp_video_format_info(format->code);
  1167          depth_out = fmt_info->width;
  1168          shift = depth_in - depth_out;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How do we know that this subtraction doesn't set "shift" to a very high
positive?

  1169  
  1170          if (ccdc->bt656)
  1171                  bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
  1172          else if (fmt_info->code == MEDIA_BUS_FMT_YUYV8_2X8)
  1173                  bridge = ISPCTRL_PAR_BRIDGE_LENDIAN;
  1174          else if (fmt_info->code == MEDIA_BUS_FMT_UYVY8_2X8)
  1175                  bridge = ISPCTRL_PAR_BRIDGE_BENDIAN;
  1176          else
  1177                  bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
  1178  
  1179          omap3isp_configure_bridge(isp, ccdc->input, parcfg, shift, bridge);

regards,
dan carpenter
