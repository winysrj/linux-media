Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3555 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3IKJFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 05:05:11 -0400
Message-ID: <52303233.6060504@xs4all.nl>
Date: Wed, 11 Sep 2013 11:04:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] RFC: Support for multiple selections
References: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com> <1378888254-5236-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1378888254-5236-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 09/11/2013 10:30 AM, Ricardo Ribalda Delgado wrote:
> A new id field is added to the struct selection. On devices that
> supports multiple sections this id indicate which of the selection to
> modify.
> 
> A new control V4L2_CID_SELECTION_BITMASK selects which of the selections
> are used, if the control is set to zero the default rectangles are used.
> 
> This is needed in cases where the user has to change multiple selections
> at the same time to get a valid combination.
> 
> On devices where the control V4L2_CID_SELECTION_BITMASK does not exist,
> the id field is ignored

This feels like a hack to me. A big problem I have with using a control here
is that with a control you can't specify for which selection target it is.

If you want to set multiple rectangles, why not just pass them directly? E.g.:

struct v4l2_selection {
        __u32                   type;
        __u32                   target;
        __u32                   flags;
	union {
	        struct v4l2_rect        r;
		struct v4l2_rect	*pr;
	};
	__u32			rectangles;
        __u32                   reserved[8];
};

If rectangles > 1, then pr is used.

It's a bit more work to add this to the core code (VIDIOC_SUBDEV_G/S_SELECTION
should probably be changed at the same time and you have to fix existing drivers
to check/set the new rectangles field), but it scales much better.

Regards,

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml | 6 ++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         | 2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c         | 4 ++--
>  include/uapi/linux/v4l2-controls.h           | 4 +++-
>  include/uapi/linux/videodev2.h               | 5 ++++-
>  5 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index c2fc9ec..a8c84bb 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -338,6 +338,12 @@ minimum value disables backlight compensation.</entry>
>  		  coefficients determined by <constant>V4L2_CID_COLORFX_CBCR</constant>
>  		  control.</entry>
>  		</row>
> +		<row>
> +		  <entry><constant>V4L2_CID_SELECTION_BITMASK</constant>&nbsp;</entry>
> +		  <entry>For drivers that support multiple selections. This control
> +		  determine which selections are enabled. If it is set to zero the default
> +		  crop and compose rectangle are used.</entry>
> +		</row>
>  	      </tbody>
>  	    </entrytbl>
>  	  </row>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index fccd08b..fa3bfc2 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -599,6 +599,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Min Number of Output Buffers";
>  	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
>  	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
> +	case V4L2_CID_SELECTION_BITMASK:	return "Selection Bitmask";
>  
>  	/* MPEG controls */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -957,6 +958,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DV_TX_RXSENSE:
>  	case V4L2_CID_DV_TX_EDID_PRESENT:
>  	case V4L2_CID_DV_RX_POWER_PRESENT:
> +	case V4L2_CID_SELECTION_BITMASK:
>  		*type = V4L2_CTRL_TYPE_BITMASK;
>  		break;
>  	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 68e6b5e..ca177bb 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -573,9 +573,9 @@ static void v4l_print_selection(const void *arg, bool write_only)
>  {
>  	const struct v4l2_selection *p = arg;
>  
> -	pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
> +	pr_cont("type=%s, target=%d, flags=0x%x, id=%d,wxh=%dx%d, x,y=%d,%d\n",
>  		prt_names(p->type, v4l2_type_names),
> -		p->target, p->flags,
> +		p->target, p->flags, p->id,
>  		p->r.width, p->r.height, p->r.left, p->r.top);
>  }
>  
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index e90a88a..ca44338 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -138,8 +138,10 @@ enum v4l2_colorfx {
>  #define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
>  #define V4L2_CID_COLORFX_CBCR			(V4L2_CID_BASE+42)
>  
> +#define V4L2_CID_SELECTION_BITMASK		(V4L2_CID_BASE+43)
> +
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+44)
>  
>  /* USER-class private control IDs */
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 0e80472..4f68196 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -806,6 +806,8 @@ struct v4l2_crop {
>   * @target:	Selection target, used to choose one of possible rectangles;
>   *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
>   * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
> + * @id:		Selection to change, for devices that supports multiple,
> + *		set to zero otherwise.
>   * @r:		coordinates of selection window
>   * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
>   *
> @@ -818,7 +820,8 @@ struct v4l2_selection {
>  	__u32			target;
>  	__u32                   flags;
>  	struct v4l2_rect        r;
> -	__u32                   reserved[9];
> +	__u32			id;
> +	__u32                   reserved[8];
>  };
>  
>  
> 
