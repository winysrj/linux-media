Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44318 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751972AbdHJNQE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:16:04 -0400
Subject: Re: [PATCH v2 3/3] v4l2-flash-led-class: Document v4l2_flash_init()
 references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-4-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b50ed1f3-d4e1-998e-0001-3f09e36fb701@xs4all.nl>
Date: Thu, 10 Aug 2017 15:16:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170809111555.30147-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/17 13:15, Sakari Ailus wrote:
> The v4l2_flash_init() keeps a reference to the ops struct but not to the
> config struct (nor anything it contains). Document this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/media/v4l2-flash-led-class.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
> index c3f39992f3fa..6f4825b6a352 100644
> --- a/include/media/v4l2-flash-led-class.h
> +++ b/include/media/v4l2-flash-led-class.h
> @@ -112,6 +112,9 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
>   * @config:	initialization data for V4L2 Flash sub-device
>   *
>   * Create V4L2 Flash sub-device wrapping given LED subsystem device.
> + * The ops pointer is stored by the V4L2 flash framework. No
> + * references are held to config nor its contents once this function
> + * has returned.
>   *
>   * Returns: A valid pointer, or, when an error occurs, the return
>   * value is encoded using ERR_PTR(). Use IS_ERR() to check and
> @@ -130,6 +133,9 @@ struct v4l2_flash *v4l2_flash_init(
>   * @config:	initialization data for V4L2 Flash sub-device
>   *
>   * Create V4L2 Flash sub-device wrapping given LED subsystem device.
> + * The ops pointer is stored by the V4L2 flash framework. No
> + * references are held to config nor its contents once this function
> + * has returned.
>   *
>   * Returns: A valid pointer, or, when an error occurs, the return
>   * value is encoded using ERR_PTR(). Use IS_ERR() to check and
> 
