Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57484 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758375AbdJMMy2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 08:54:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 15/17] media: v4l2-ctrls: document nested members of structs
Date: Fri, 13 Oct 2017 15:54:40 +0300
Message-ID: <6035228.f1Xvqo8GGG@avalon>
In-Reply-To: <1e306b8be3c23175bc7d1c77208ce66094ff4549.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <1e306b8be3c23175bc7d1c77208ce66094ff4549.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:58 EEST Mauro Carvalho Chehab wrote:
> There are a few nested members at v4l2-ctrls.h. Now that
> kernel-doc supports, document them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-ctrls.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index dacfe54057f8..ca05f0f49bc5 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -147,7 +147,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl
> *ctrl, void *priv); * @type_ops:	The control type ops.
>   * @id:	The control ID.
>   * @name:	The control name.
> - * @type:	The control type.
> + * @type:	The control type, as defined by &enum v4l2_ctrl_type.

Why do you need this ? The field is an enum v4l2_ctrl_type, Sphinx should 
generate the proper link already.

>   * @minimum:	The control's minimum value.
>   * @maximum:	The control's maximum value.
>   * @default_value: The control's default value.
> @@ -166,8 +166,15 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl
> *ctrl, void *priv);
>   *		empty strings ("") correspond to non-existing menu items (this
>   *		is in addition to the menu_skip_mask above). The last entry
>   *		must be NULL.
> + *		Used only if the @type is %V4L2_CTRL_TYPE_MENU.
> + * @qmenu_int:	A 64-bit integer array for with integer menu items.
> + *		The size of array must be equal to the menu size, e. g.:
> + *		:math:`ceil(\frac{maximum - minimum}{step}) + 1`.
> + *		Used only if the @type is %V4L2_CTRL_TYPE_INTEGER_MENU.
>   * @flags:	The control's flags.
> - * @cur:	The control's current value.
> + * @cur:	Struct to store data about the current value.

s/Struct/Structure/
s/data about the current value/the current value/

> + * @cur.val:	The control's current value, if the @type is represented via
> + *		a u32 integer (see &enum v4l2_ctrl_type).
>   * @val:	The control's new s32 value.
>   * @priv:	The control's private pointer. For use by the driver. It is
>   *		untouched by the control framework. Note that this pointer is

-- 
Regards,

Laurent Pinchart
