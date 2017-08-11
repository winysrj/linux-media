Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43608 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751416AbdHKGCB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 02:02:01 -0400
Subject: Re: [PATCH 1/3] media: v4l2-ctrls.h: better document the arguments
 for v4l2_ctrl_fill
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
 <cover.1502409182.git.mchehab@s-opensource.com>
 <f6ac7366e711649241bb77aff997d6815d6c063e.1502409182.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d2ad9cc5-5635-79a0-5213-f312edc07603@xs4all.nl>
Date: Fri, 11 Aug 2017 08:01:58 +0200
MIME-Version: 1.0
In-Reply-To: <f6ac7366e711649241bb77aff997d6815d6c063e.1502409182.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/17 02:16, Mauro Carvalho Chehab wrote:
> The arguments for this function are pointers. Make it clear at
> its documentation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-ctrls.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 2d2aed56922f..6ba30acf06aa 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -339,18 +339,18 @@ struct v4l2_ctrl_config {
>  /**
>   * v4l2_ctrl_fill - Fill in the control fields based on the control ID.
>   *
> - * @id: ID of the control
> - * @name: name of the control
> - * @type: type of the control
> - * @min: minimum value for the control
> - * @max: maximum value for the control
> - * @step: control step
> - * @def: default value for the control
> - * @flags: flags to be used on the control
> + * @id: pointer for storing the ID of the control

id isn't a pointer, all other arguments are.

> + * @name: pointer for storing the name of the control

This is a pointer to a pointer.

> + * @type: pointer for storing the type of the control
> + * @min: pointer for storing the minimum value for the control
> + * @max: pointer for storing the maximum value for the control
> + * @step: pointer for storing the control step
> + * @def: pointer for storing the default value for the control
> + * @flags: pointer for storing the flags to be used on the control
>   *
>   * This works for all standard V4L2 controls.
>   * For non-standard controls it will only fill in the given arguments
> - * and @name will be %NULL.
> + * and @name content will be filled with %NULL.

I'd say: 'set to %NULL'.

>   *
>   * This function will overwrite the contents of @name, @type and @flags.
>   * The contents of @min, @max, @step and @def may be modified depending on
> 

Regards,

	Hans
