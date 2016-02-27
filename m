Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44130 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340AbcB0LcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 06:32:22 -0500
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ulrich.hecht@gmail.com
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D1893E.9070007@xs4all.nl>
Date: Sat, 27 Feb 2016 12:32:14 +0100
MIME-Version: 1.0
In-Reply-To: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2016 03:58 AM, Niklas Söderlund wrote:
> A V4L2 driver for Renesas R-Car VIN driver that do not depend on
> soc_camera. The driver is heavily based on its predecessor and aims to
> replace it.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
> 
> The driver is tested on Koelsch and can do streaming using qv4l2 and
> grab frames using yavta. It passes a v4l2-compliance (git master) run
> without failures, see bellow for output. Some issues I know about but
> will have to wait for future work in other patches.
>  - The soc_camera driver provides some pixel formats that do not display
>    properly for me in qv4l2 or yavta. I have ported these formats as is
>    (not working correctly?) to the new driver.
>  - One can not bind/unbind the subdevice and continue using the driver.
> 
> As stated in commit message the driver is based on its soc_camera
> version but some features have been drooped (for now?).
>  - The driver no longer try to use the subdev for cropping (using
>    cropcrop/s_crop).
>  - Do not interrogate the subdev using g_mbus_config.

A quick question: was this tested with the adv7180 only? Or do you also
have access to a sensor to test with?

Regards,

	Hans
