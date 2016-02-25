Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39791 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcBYVoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 16:44:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/1] v4l: libv4l2subdev: Drop length argument from string conversion functions
Date: Thu, 25 Feb 2016 23:44:01 +0200
Message-ID: <9220133.1Kl6SBjeVB@avalon>
In-Reply-To: <1453759113-18014-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1453759113-18014-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 25 January 2016 23:58:33 Sakari Ailus wrote:
> v4l2_subdev_string_to_pixelcode() and v4l2_subdev_string_to_field() take a
> string and the length of that string as an argument. This has been
> motivated by existing usage in the same library. While this works for the
> library quite well, it's not a great API.
> 
> Instead, drop the length argument and pass a nul terminated string to the
> string conversion functions.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> This goes on top of the media bus code patchset.
> 
>  utils/media-ctl/libv4l2subdev.c | 36 ++++++++++++++++++++++--------------
>  utils/media-ctl/v4l2subdev.h    | 12 ++++--------
>  2 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index 408f1cf..70e1e39 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -308,6 +308,7 @@ static int v4l2_subdev_parse_format(struct media_device
> *media, {
>  	enum v4l2_mbus_pixelcode code;
>  	unsigned int width, height;
> +	char *fmt;
>  	char *end;
> 
>  	/*
> @@ -318,7 +319,12 @@ static int v4l2_subdev_parse_format(struct media_device
> *media, for (end = (char *)p;
>  	     *end != '/' && *end != ' ' && *end != '\0'; ++end);
> 
> -	code = v4l2_subdev_string_to_pixelcode(p, end - p);
> +	fmt = strndup(p, end - p);
> +	if (!fmt)
> +		return -ENOMEM;
> +
> +	code = v4l2_subdev_string_to_pixelcode(fmt);
> +	free(fmt);
>  	if (code == (enum v4l2_mbus_pixelcode)-1) {
>  		media_dbg(media, "Invalid pixel code '%.*s'\n", end - p, p);
>  		return -EINVAL;
> @@ -475,11 +481,19 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
> 
>  		if (strhazit("field:", &p)) {
>  			enum v4l2_field field;
> +			char *strfield;
> 
>  			for (end = (char *)p; isalpha(*end) || *end == '-';
>  			     ++end);
> 
> -			field = v4l2_subdev_string_to_field(p, end - p);
> +			strfield = strndup(p, end - p);
> +			if (!strfield) {
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			field = v4l2_subdev_string_to_field(strfield);
> +			free(strfield);
>  			if (field == (enum v4l2_field)-1) {
>  				media_dbg(media, "Invalid field value '%*s'\n",
>  					  end - p, p);
> @@ -770,14 +784,12 @@ const char *v4l2_subdev_pixelcode_to_string(enum
> v4l2_mbus_pixelcode code) return "unknown";
>  }
> 
> -enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char
> *string, -							 unsigned int length)
> +enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char
> *string) {
>  	unsigned int i;
> 
>  	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
> -		if (strncmp(mbus_formats[i].name, string, length) == 0
> -		    && mbus_formats[i].name[length] == '\0')
> +		if (strcmp(mbus_formats[i].name, string) == 0)
>  			return mbus_formats[i].code;
>  	}
> 
> @@ -812,20 +824,16 @@ const char *v4l2_subdev_field_to_string(enum
> v4l2_field field) return "unknown";
>  }
> 
> -enum v4l2_field v4l2_subdev_string_to_field(const char *string,
> -					    unsigned int length)
> +enum v4l2_field v4l2_subdev_string_to_field(const char *string)
>  {
>  	unsigned int i;
> 
>  	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
> -		if (strncasecmp(fields[i].name, string, length) == 0)
> -			break;
> +		if (strcasecmp(fields[i].name, string) == 0)
> +			return fields[i].field;
>  	}
> 
> -	if (i == ARRAY_SIZE(fields))
> -		return (enum v4l2_field)-1;
> -
> -	return fields[i].field;
> +	return (enum v4l2_field)-1;
>  }
> 
>  const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(void)
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 33327d6..dcdb35c 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -247,15 +247,13 @@ const char *v4l2_subdev_pixelcode_to_string(enum
> v4l2_mbus_pixelcode code);
> 
>  /**
>   * @brief Parse string to media bus pixel code.
> - * @param string - input string
> - * @param length - length of the string
> + * @param string - nul terminalted string, textual media bus pixel code
>   *
>   * Parse human readable string @a string to an media bus pixel code.
>   *
>   * @return media bus pixelcode on success, -1 on failure.
>   */
> -enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char
> *string, -							 unsigned int length);
> +enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char
> *string);
> 
>  /**
>   * @brief Convert a field order to string.
> @@ -269,15 +267,13 @@ const char *v4l2_subdev_field_to_string(enum
> v4l2_field field);
> 
>  /**
>   * @brief Parse string to field order.
> - * @param string - input string
> - * @param length - length of the string
> + * @param string - nul terminated string, textual media bus pixel code
>   *
>   * Parse human readable string @a string to field order.
>   *
>   * @return field order on success, -1 on failure.
>   */
> -enum v4l2_field v4l2_subdev_string_to_field(const char *string,
> -					    unsigned int length);
> +enum v4l2_field v4l2_subdev_string_to_field(const char *string);
> 
>  /**
>   * @brief Enumerate library supported media bus pixel codes.

-- 
Regards,

Laurent Pinchart

