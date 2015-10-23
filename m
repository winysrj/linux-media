Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48316 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbbJWJ2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 05:28:15 -0400
Date: Fri, 23 Oct 2015 12:27:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media-ctl: Add field support for the media bus format
Message-ID: <20151023092741.GS26916@valkosipuli.retiisi.org.uk>
References: <1445591901-10650-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1445591901-10650-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch. A few comments below.

On Fri, Oct 23, 2015 at 12:18:21PM +0300, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  utils/media-ctl/libv4l2subdev.c | 62 +++++++++++++++++++++++++++++++++++++++++
>  utils/media-ctl/media-ctl.c     |  3 ++
>  utils/media-ctl/v4l2subdev.h    | 25 ++++++++++++++++-
>  3 files changed, 89 insertions(+), 1 deletion(-)
> 
> Old patch that was dying of boredom alone in my tree. As Sakari needs this
> features it seems to be a good time to remove the dust and submit it.
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 8015330ddb3c..ad3bb727aa07 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -473,6 +473,24 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
>  			continue;
>  		}
>  
> +		if (strhazit("field:", &p)) {
> +			enum v4l2_field field;
> +
> +			for (end = (char *)p; isalpha(*end) || *end == '-'; ++end);
> +
> +			field = v4l2_subdev_string_to_field(p, end - p);
> +			if (field == (enum v4l2_field)-1) {
> +				media_dbg(media, "Invalid field value '%*s'\n", end - p, p);

Over 80 characaters per line.

> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			format->field = field;
> +
> +			p = end;
> +			continue;
> +		}
> +
>  		/*
>  		 * Backward compatibility: crop rectangles can be specified
>  		 * implicitly without the 'crop:' property name.
> @@ -755,3 +773,47 @@ enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
>  
>  	return mbus_formats[i].code;
>  }
> +
> +static struct {
> +	const char *name;
> +	enum v4l2_field field;
> +} fields[] = {
> +	{ "any", V4L2_FIELD_ANY },
> +	{ "none", V4L2_FIELD_NONE },
> +	{ "top", V4L2_FIELD_TOP },
> +	{ "bottom", V4L2_FIELD_BOTTOM },
> +	{ "interlaced", V4L2_FIELD_INTERLACED },
> +	{ "seq-tb", V4L2_FIELD_SEQ_TB },
> +	{ "seq-bt", V4L2_FIELD_SEQ_BT },
> +	{ "alternate", V4L2_FIELD_ALTERNATE },
> +	{ "interlaced-tb", V4L2_FIELD_INTERLACED_TB },
> +	{ "interlaced-bt", V4L2_FIELD_INTERLACED_BT },
> +};
> +
> +const char *v4l2_subdev_field_to_string(enum v4l2_field field)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
> +		if (fields[i].field == field)
> +			return fields[i].name;
> +	}
> +
> +	return "unknown";
> +}
> +
> +enum v4l2_field v4l2_subdev_string_to_field(const char *string,
> +					    unsigned int length)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
> +		if (strncmp(fields[i].name, string, length) == 0)

How about using strncasecmp() instead? The definitions are upper case in the
header.

> +			break;

You should return fields[i].field here.

> +	}
> +
> +	if (i == ARRAY_SIZE(fields))
> +		return (enum v4l2_field)-1;
> +
> +	return fields[i].field;
> +}
> diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
> index d3f6e041db7b..3002fb7e4e12 100644
> --- a/utils/media-ctl/media-ctl.c
> +++ b/utils/media-ctl/media-ctl.c
> @@ -90,6 +90,9 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
>  	       v4l2_subdev_pixelcode_to_string(format.code),
>  	       format.width, format.height);
>  
> +	if (format.field)
> +		printf(" field:%s", v4l2_subdev_field_to_string(format.field));
> +
>  	ret = v4l2_subdev_get_selection(entity, &rect, pad,
>  					V4L2_SEL_TGT_CROP_BOUNDS,
>  					which);
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 1cb53ffbcfab..9138b87e0976 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -247,7 +247,7 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
>  /**
>   * @brief Parse string to media bus pixel code.
>   * @param string - input string
> - * @param lenght - length of the string
> + * @param length - length of the string
>   *
>   * Parse human readable string @a string to an media bus pixel code.
>   *
> @@ -255,4 +255,27 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
>   */
>  enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
>  							 unsigned int length);
> +
> +/**
> + * @brief Convert a field order to string.
> + * @param field - field order
> + *
> + * Convert field order @a field to a human-readable string.
> + *
> + * @return A pointer to a string on success, NULL on failure.
> + */
> +const char *v4l2_subdev_field_to_string(enum v4l2_field field);
> +
> +/**
> + * @brief Parse string to field order.
> + * @param string - input string
> + * @param length - length of the string
> + *
> + * Parse human readable string @a string to field order.
> + *
> + * @return field order on success, -1 on failure.
> + */
> +enum v4l2_field v4l2_subdev_string_to_field(const char *string,
> +					    unsigned int length);
> +
>  #endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
