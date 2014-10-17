Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33479 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751846AbaJQO7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:59:18 -0400
Message-ID: <54412EC8.1080001@iki.fi>
Date: Fri, 17 Oct 2014 17:59:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [RFC PATCH 09/11] videodev2.h: add v4l2_ctrl_selection
 compound control type.
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-10-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

(Cc Ricardo.)

Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This will be used by a new selection control.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/v4l2-ctrls.h     | 2 ++
>  include/uapi/linux/videodev2.h | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 3005d88..c2fd050 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -46,6 +46,7 @@ struct poll_table_struct;
>   * @p_u16:	Pointer to a 16-bit unsigned value.
>   * @p_u32:	Pointer to a 32-bit unsigned value.
>   * @p_char:	Pointer to a string.
> + * @p_sel:	Pointer to a struct v4l2_ctrl_selection.
>   * @p:		Pointer to a compound value.
>   */
>  union v4l2_ctrl_ptr {
> @@ -55,6 +56,7 @@ union v4l2_ctrl_ptr {
>  	u16 *p_u16;
>  	u32 *p_u32;
>  	char *p_char;
> +	struct v4l2_ctrl_selection *p_sel;
>  	void *p;
>  };

In order to be usable on sub-devices, pad information should be added.
That results in having a pad per rectangle, which probably doesn't make
sense. Also, other controls may benefit from being pad related.

What would you think of including the pad information in struct
v4l2_ext_control? That should be in a different patch. Would a flags
field be needed to tell whether the pad field is valid? 16 bits should
be good for both, but we anyway had just a single reserved field.

This would leave you with essentially a rectangle control, which you
still might want to call (or not) a selection control.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi

