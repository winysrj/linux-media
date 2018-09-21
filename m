Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:62038 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389264AbeIUOMO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 10:12:14 -0400
Subject: Re: [PATCH 04/18] video/hdmi: Constify infoframe passed to the pack
 functions
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
 <20180920185145.1912-5-ville.syrjala@linux.intel.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <d23d0960-18e4-8d25-e6cb-6dc489cae1a6@cisco.com>
Date: Fri, 21 Sep 2018 10:24:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180920185145.1912-5-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/18 20:51, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Let's make the infoframe pack functions usable with a const infoframe
> structure. This allows us to precompute the infoframe earlier, and still
> pack it later when we're no longer allowed to modify the structure.
> So now we end up with a _check()+_pack_only() or _pack() functions
> depending on whether you want to precompute the infoframes or not.
> The names aren't greate but I was lazy and didn't want to change all the

greate -> great

> drivers.
> 
> v2: Deal with exynos churn
>     Actually export the new funcs
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/video/hdmi.c | 425 +++++++++++++++++++++++++++++++++++++++++++++++----
>  include/linux/hdmi.h |  19 ++-
>  2 files changed, 416 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index 53e7ee2c83fc..9507f668a569 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -68,8 +68,36 @@ int hdmi_avi_infoframe_init(struct hdmi_avi_infoframe *frame)
>  }
>  EXPORT_SYMBOL(hdmi_avi_infoframe_init);
>  
> +static int hdmi_avi_infoframe_check_only(const struct hdmi_avi_infoframe *frame)
> +{
> +	if (frame->type != HDMI_INFOFRAME_TYPE_AVI ||
> +	    frame->version != 2 ||
> +	    frame->length != HDMI_AVI_INFOFRAME_SIZE)
> +		return -EINVAL;
> +
> +	if (frame->picture_aspect > HDMI_PICTURE_ASPECT_16_9)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /**
> - * hdmi_avi_infoframe_pack() - write HDMI AVI infoframe to binary buffer
> + * hdmi_avi_infoframe_check() - Check and check a HDMI AVI infoframe

"Check and check"? This is repeated elsewhere as well (clearly copy-and-paste).

> + * @frame: HDMI AVI infoframe
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int hdmi_avi_infoframe_check(struct hdmi_avi_infoframe *frame)
> +{
> +	return hdmi_avi_infoframe_check_only(frame);
> +}
> +EXPORT_SYMBOL(hdmi_avi_infoframe_check);
> +
> +/**
> + * hdmi_avi_infoframe_pack_only() - write HDMI AVI infoframe to binary buffer
>   * @frame: HDMI AVI infoframe
>   * @buffer: destination buffer
>   * @size: size of buffer
> @@ -82,20 +110,22 @@ EXPORT_SYMBOL(hdmi_avi_infoframe_init);
>   * Returns the number of bytes packed into the binary buffer or a negative
>   * error code on failure.
>   */
> -ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
> -				size_t size)
> +ssize_t hdmi_avi_infoframe_pack_only(const struct hdmi_avi_infoframe *frame,
> +				     void *buffer, size_t size)
>  {
>  	u8 *ptr = buffer;
>  	size_t length;
> +	int ret;
> +
> +	ret = hdmi_avi_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
>  
>  	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
>  
>  	if (size < length)
>  		return -ENOSPC;
>  
> -	if (frame->picture_aspect > HDMI_PICTURE_ASPECT_16_9)
> -		return -EINVAL;
> -
>  	memset(buffer, 0, size);
>  
>  	ptr[0] = frame->type;
> @@ -152,6 +182,36 @@ ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
>  
>  	return length;
>  }
> +EXPORT_SYMBOL(hdmi_avi_infoframe_pack_only);
> +
> +/**
> + * hdmi_avi_infoframe_pack() - Check and check a HDMI AVI infoframe,
> + *                             and write it to binary buffer
> + * @frame: HDMI AVI infoframe
> + * @buffer: destination buffer
> + * @size: size of buffer
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields, after which packs the information

which packs -> which it packs

Ditto elsewhere.

> + * contained in the @frame structure into a binary representation that
> + * can be written into the corresponding controller registers. Also

Also -> This function also

Ditto elsewhere.

> + * computes the checksum as required by section 5.3.5 of the HDMI 1.4
> + * specification.
> + *
> + * Returns the number of bytes packed into the binary buffer or a negative
> + * error code on failure.
> + */
> +ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame,
> +				void *buffer, size_t size)
> +{
> +	int ret;
> +
> +	ret = hdmi_avi_infoframe_check(frame);
> +	if (ret)
> +		return ret;
> +
> +	return hdmi_avi_infoframe_pack_only(frame, buffer, size);
> +}
>  EXPORT_SYMBOL(hdmi_avi_infoframe_pack);
>  
>  /**
> @@ -178,8 +238,33 @@ int hdmi_spd_infoframe_init(struct hdmi_spd_infoframe *frame,
>  }
>  EXPORT_SYMBOL(hdmi_spd_infoframe_init);
>  
> +static int hdmi_spd_infoframe_check_only(const struct hdmi_spd_infoframe *frame)
> +{
> +	if (frame->type != HDMI_INFOFRAME_TYPE_SPD ||
> +	    frame->version != 1 ||
> +	    frame->length != HDMI_SPD_INFOFRAME_SIZE)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /**
> - * hdmi_spd_infoframe_pack() - write HDMI SPD infoframe to binary buffer
> + * hdmi_spd_infoframe_check() - Check and check a HDMI SPD infoframe
> + * @frame: HDMI SPD infoframe
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int hdmi_spd_infoframe_check(struct hdmi_spd_infoframe *frame)
> +{
> +	return hdmi_spd_infoframe_check_only(frame);
> +}
> +EXPORT_SYMBOL(hdmi_spd_infoframe_check);
> +
> +/**
> + * hdmi_spd_infoframe_pack_only() - write HDMI SPD infoframe to binary buffer
>   * @frame: HDMI SPD infoframe
>   * @buffer: destination buffer
>   * @size: size of buffer
> @@ -192,11 +277,16 @@ EXPORT_SYMBOL(hdmi_spd_infoframe_init);
>   * Returns the number of bytes packed into the binary buffer or a negative
>   * error code on failure.
>   */
> -ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame, void *buffer,
> -				size_t size)
> +ssize_t hdmi_spd_infoframe_pack_only(const struct hdmi_spd_infoframe *frame,
> +				     void *buffer, size_t size)
>  {
>  	u8 *ptr = buffer;
>  	size_t length;
> +	int ret;
> +
> +	ret = hdmi_spd_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
>  
>  	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
>  
> @@ -222,6 +312,36 @@ ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame, void *buffer,
>  
>  	return length;
>  }
> +EXPORT_SYMBOL(hdmi_spd_infoframe_pack_only);
> +
> +/**
> + * hdmi_spd_infoframe_pack() - Check and check a HDMI SPD infoframe,
> + *                             and write it to binary buffer
> + * @frame: HDMI SPD infoframe
> + * @buffer: destination buffer
> + * @size: size of buffer
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields, after which packs the information
> + * contained in the @frame structure into a binary representation that
> + * can be written into the corresponding controller registers. Also
> + * computes the checksum as required by section 5.3.5 of the HDMI 1.4
> + * specification.
> + *
> + * Returns the number of bytes packed into the binary buffer or a negative
> + * error code on failure.
> + */
> +ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame,
> +				void *buffer, size_t size)
> +{
> +	int ret;
> +
> +	ret = hdmi_spd_infoframe_check(frame);
> +	if (ret)
> +		return ret;
> +
> +	return hdmi_spd_infoframe_pack_only(frame, buffer, size);
> +}
>  EXPORT_SYMBOL(hdmi_spd_infoframe_pack);
>  
>  /**
> @@ -242,8 +362,33 @@ int hdmi_audio_infoframe_init(struct hdmi_audio_infoframe *frame)
>  }
>  EXPORT_SYMBOL(hdmi_audio_infoframe_init);
>  
> +static int hdmi_audio_infoframe_check_only(const struct hdmi_audio_infoframe *frame)
> +{
> +	if (frame->type != HDMI_INFOFRAME_TYPE_AUDIO ||
> +	    frame->version != 1 ||
> +	    frame->length != HDMI_AUDIO_INFOFRAME_SIZE)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/**
> + * hdmi_audio_infoframe_check() - Check and check a HDMI audio infoframe
> + * @frame: HDMI audio infoframe
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int hdmi_audio_infoframe_check(struct hdmi_audio_infoframe *frame)
> +{
> +	return hdmi_audio_infoframe_check_only(frame);
> +}
> +EXPORT_SYMBOL(hdmi_audio_infoframe_check);
> +
>  /**
> - * hdmi_audio_infoframe_pack() - write HDMI audio infoframe to binary buffer
> + * hdmi_audio_infoframe_pack_only() - write HDMI audio infoframe to binary buffer
>   * @frame: HDMI audio infoframe
>   * @buffer: destination buffer
>   * @size: size of buffer
> @@ -256,12 +401,17 @@ EXPORT_SYMBOL(hdmi_audio_infoframe_init);
>   * Returns the number of bytes packed into the binary buffer or a negative
>   * error code on failure.
>   */
> -ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
> -				  void *buffer, size_t size)
> +ssize_t hdmi_audio_infoframe_pack_only(const struct hdmi_audio_infoframe *frame,
> +				       void *buffer, size_t size)
>  {
>  	unsigned char channels;
>  	u8 *ptr = buffer;
>  	size_t length;
> +	int ret;
> +
> +	ret = hdmi_audio_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
>  
>  	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
>  
> @@ -297,6 +447,36 @@ ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
>  
>  	return length;
>  }
> +EXPORT_SYMBOL(hdmi_audio_infoframe_pack_only);
> +
> +/**
> + * hdmi_audio_infoframe_pack() - Check and check a HDMI Audio infoframe,
> + *                               and write it to binary buffer
> + * @frame: HDMI Audio infoframe
> + * @buffer: destination buffer
> + * @size: size of buffer
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields, after which packs the information
> + * contained in the @frame structure into a binary representation that
> + * can be written into the corresponding controller registers. Also
> + * computes the checksum as required by section 5.3.5 of the HDMI 1.4
> + * specification.
> + *
> + * Returns the number of bytes packed into the binary buffer or a negative
> + * error code on failure.
> + */
> +ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
> +				  void *buffer, size_t size)
> +{
> +	int ret;
> +
> +	ret = hdmi_audio_infoframe_check(frame);
> +	if (ret)
> +		return ret;
> +
> +	return hdmi_audio_infoframe_pack_only(frame, buffer, size);
> +}
>  EXPORT_SYMBOL(hdmi_audio_infoframe_pack);
>  
>  /**
> @@ -319,6 +499,7 @@ int hdmi_vendor_infoframe_init(struct hdmi_vendor_infoframe *frame)
>  	 * value
>  	 */
>  	frame->s3d_struct = HDMI_3D_STRUCTURE_INVALID;
> +	frame->length = 4;
>  
>  	return 0;
>  }
> @@ -335,8 +516,42 @@ static int hdmi_vendor_infoframe_length(const struct hdmi_vendor_infoframe *fram
>  		return 4;
>  }
>  
> +static int hdmi_vendor_infoframe_check_only(const struct hdmi_vendor_infoframe *frame)
> +{
> +	if (frame->type != HDMI_INFOFRAME_TYPE_VENDOR ||
> +	    frame->version != 1 ||
> +	    frame->oui != HDMI_IEEE_OUI)
> +		return -EINVAL;
> +
> +	/* only one of those can be supplied */
> +	if (frame->vic != 0 && frame->s3d_struct != HDMI_3D_STRUCTURE_INVALID)
> +		return -EINVAL;
> +
> +	if (frame->length != hdmi_vendor_infoframe_length(frame))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /**
> - * hdmi_vendor_infoframe_pack() - write a HDMI vendor infoframe to binary buffer
> + * hdmi_vendor_infoframe_check() - Check and check a HDMI vendor infoframe
> + * @frame: HDMI infoframe
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int hdmi_vendor_infoframe_check(struct hdmi_vendor_infoframe *frame)
> +{
> +	frame->length = hdmi_vendor_infoframe_length(frame);
> +
> +	return hdmi_vendor_infoframe_check_only(frame);
> +}
> +EXPORT_SYMBOL(hdmi_vendor_infoframe_check);
> +
> +/**
> + * hdmi_vendor_infoframe_pack_only() - write a HDMI vendor infoframe to binary buffer
>   * @frame: HDMI infoframe
>   * @buffer: destination buffer
>   * @size: size of buffer
> @@ -349,17 +564,16 @@ static int hdmi_vendor_infoframe_length(const struct hdmi_vendor_infoframe *fram
>   * Returns the number of bytes packed into the binary buffer or a negative
>   * error code on failure.
>   */
> -ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
> -				 void *buffer, size_t size)
> +ssize_t hdmi_vendor_infoframe_pack_only(const struct hdmi_vendor_infoframe *frame,
> +					void *buffer, size_t size)
>  {
>  	u8 *ptr = buffer;
>  	size_t length;
> +	int ret;
>  
> -	/* only one of those can be supplied */
> -	if (frame->vic != 0 && frame->s3d_struct != HDMI_3D_STRUCTURE_INVALID)
> -		return -EINVAL;
> -
> -	frame->length = hdmi_vendor_infoframe_length(frame);
> +	ret = hdmi_vendor_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
>  
>  	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
>  
> @@ -394,24 +608,134 @@ ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
>  
>  	return length;
>  }
> +EXPORT_SYMBOL(hdmi_vendor_infoframe_pack_only);
> +
> +/**
> + * hdmi_vendor_infoframe_pack() - Check and check a HDMI Vendor infoframe,
> + *                                and write it to binary buffer
> + * @frame: HDMI Vendor infoframe
> + * @buffer: destination buffer
> + * @size: size of buffer
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields, after which packs the information
> + * contained in the @frame structure into a binary representation that
> + * can be written into the corresponding controller registers. Also
> + * computes the checksum as required by section 5.3.5 of the HDMI 1.4
> + * specification.
> + *
> + * Returns the number of bytes packed into the binary buffer or a negative
> + * error code on failure.
> + */
> +ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
> +				   void *buffer, size_t size)
> +{
> +	int ret;
> +
> +	ret = hdmi_vendor_infoframe_check(frame);
> +	if (ret)
> +		return ret;
> +
> +	return hdmi_vendor_infoframe_pack_only(frame, buffer, size);
> +}
>  EXPORT_SYMBOL(hdmi_vendor_infoframe_pack);
>  
> +static int
> +hdmi_vendor_any_infoframe_check_only(const union hdmi_vendor_any_infoframe *frame)
> +{
> +	if (frame->any.type != HDMI_INFOFRAME_TYPE_VENDOR ||
> +	    frame->any.version != 1)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /*
> - * hdmi_vendor_any_infoframe_pack() - write a vendor infoframe to binary buffer
> + * hdmi_vendor_any_infoframe_check() - check and check a vendor infoframe
> + */
> +static int
> +hdmi_vendor_any_infoframe_check(union hdmi_vendor_any_infoframe *frame)
> +{
> +	int ret;
> +
> +	ret = hdmi_vendor_any_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
> +
> +	/* we only know about HDMI vendor infoframes */
> +	if (frame->any.oui != HDMI_IEEE_OUI)
> +		return -EINVAL;
> +
> +	return hdmi_vendor_infoframe_check(&frame->hdmi);
> +}
> +
> +/*
> + * hdmi_vendor_any_infoframe_pack_only() - write a vendor infoframe to binary buffer
>   */
>  static ssize_t
> -hdmi_vendor_any_infoframe_pack(union hdmi_vendor_any_infoframe *frame,
> -			   void *buffer, size_t size)
> +hdmi_vendor_any_infoframe_pack_only(const union hdmi_vendor_any_infoframe *frame,
> +				    void *buffer, size_t size)
>  {
> +	int ret;
> +
> +	ret = hdmi_vendor_any_infoframe_check_only(frame);
> +	if (ret)
> +		return ret;
> +
>  	/* we only know about HDMI vendor infoframes */
>  	if (frame->any.oui != HDMI_IEEE_OUI)
>  		return -EINVAL;
>  
> -	return hdmi_vendor_infoframe_pack(&frame->hdmi, buffer, size);
> +	return hdmi_vendor_infoframe_pack_only(&frame->hdmi, buffer, size);
> +}
> +
> +/*
> + * hdmi_vendor_any_infoframe_pack() - check and check a vendor infoframe,
> + *                                              and write it to binary buffer
> + */
> +static ssize_t
> +hdmi_vendor_any_infoframe_pack(union hdmi_vendor_any_infoframe *frame,
> +			       void *buffer, size_t size)
> +{
> +	int ret;
> +
> +	ret = hdmi_vendor_any_infoframe_check(frame);
> +	if (ret)
> +		return ret;
> +
> +	return hdmi_vendor_any_infoframe_pack_only(frame, buffer, size);
> +}
> +
> +/**
> + * hdmi_infoframe_check() - Check check a HDMI infoframe
> + * @frame: HDMI infoframe
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int
> +hdmi_infoframe_check(union hdmi_infoframe *frame)
> +{
> +	switch (frame->any.type) {
> +	case HDMI_INFOFRAME_TYPE_AVI:
> +		return hdmi_avi_infoframe_check(&frame->avi);
> +	case HDMI_INFOFRAME_TYPE_SPD:
> +		return hdmi_spd_infoframe_check(&frame->spd);
> +	case HDMI_INFOFRAME_TYPE_AUDIO:
> +		return hdmi_audio_infoframe_check(&frame->audio);
> +	case HDMI_INFOFRAME_TYPE_VENDOR:
> +		return hdmi_vendor_any_infoframe_check(&frame->vendor);
> +	default:
> +		WARN(1, "Bad infoframe type %d\n", frame->any.type);
> +		return -EINVAL;
> +	}
>  }
> +EXPORT_SYMBOL(hdmi_infoframe_check);
>  
>  /**
> - * hdmi_infoframe_pack() - write a HDMI infoframe to binary buffer
> + * hdmi_infoframe_pack_only() - write a HDMI infoframe to binary buffer
>   * @frame: HDMI infoframe
>   * @buffer: destination buffer
>   * @size: size of buffer
> @@ -425,7 +749,56 @@ hdmi_vendor_any_infoframe_pack(union hdmi_vendor_any_infoframe *frame,
>   * error code on failure.
>   */
>  ssize_t
> -hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size)
> +hdmi_infoframe_pack_only(const union hdmi_infoframe *frame, void *buffer, size_t size)
> +{
> +	ssize_t length;
> +
> +	switch (frame->any.type) {
> +	case HDMI_INFOFRAME_TYPE_AVI:
> +		length = hdmi_avi_infoframe_pack_only(&frame->avi,
> +						      buffer, size);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_SPD:
> +		length = hdmi_spd_infoframe_pack_only(&frame->spd,
> +						      buffer, size);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_AUDIO:
> +		length = hdmi_audio_infoframe_pack_only(&frame->audio,
> +							buffer, size);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_VENDOR:
> +		length = hdmi_vendor_any_infoframe_pack_only(&frame->vendor,
> +							     buffer, size);
> +		break;
> +	default:
> +		WARN(1, "Bad infoframe type %d\n", frame->any.type);
> +		length = -EINVAL;
> +	}
> +
> +	return length;
> +}
> +EXPORT_SYMBOL(hdmi_infoframe_pack_only);
> +
> +/**
> + * hdmi_infoframe_pack() - Check check a HDMI infoframe,

Check check?

> + *                         and write it to binary buffer
> + * @frame: HDMI infoframe
> + * @buffer: destination buffer
> + * @size: size of buffer
> + *
> + * Validates that the infoframe is consistent and updates derived fields
> + * (eg. length) based on other fields, after which packs the information
> + * contained in the @frame structure into a binary representation that
> + * can be written into the corresponding controller registers. Also
> + * computes the checksum as required by section 5.3.5 of the HDMI 1.4
> + * specification.
> + *
> + * Returns the number of bytes packed into the binary buffer or a negative
> + * error code on failure.
> + */
> +ssize_t
> +hdmi_infoframe_pack(union hdmi_infoframe *frame,
> +		    void *buffer, size_t size)
>  {
>  	ssize_t length;
>  
> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> index bce1abb1fe57..c76b50a48e48 100644
> --- a/include/linux/hdmi.h
> +++ b/include/linux/hdmi.h
> @@ -163,6 +163,9 @@ struct hdmi_avi_infoframe {
>  int hdmi_avi_infoframe_init(struct hdmi_avi_infoframe *frame);
>  ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
>  				size_t size);
> +ssize_t hdmi_avi_infoframe_pack_only(const struct hdmi_avi_infoframe *frame,
> +				     void *buffer, size_t size);
> +int hdmi_avi_infoframe_check(struct hdmi_avi_infoframe *frame);
>  
>  enum hdmi_spd_sdi {
>  	HDMI_SPD_SDI_UNKNOWN,
> @@ -194,6 +197,9 @@ int hdmi_spd_infoframe_init(struct hdmi_spd_infoframe *frame,
>  			    const char *vendor, const char *product);
>  ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame, void *buffer,
>  				size_t size);
> +ssize_t hdmi_spd_infoframe_pack_only(const struct hdmi_spd_infoframe *frame,
> +				     void *buffer, size_t size);
> +int hdmi_spd_infoframe_check(struct hdmi_spd_infoframe *frame);
>  
>  enum hdmi_audio_coding_type {
>  	HDMI_AUDIO_CODING_TYPE_STREAM,
> @@ -272,6 +278,9 @@ struct hdmi_audio_infoframe {
>  int hdmi_audio_infoframe_init(struct hdmi_audio_infoframe *frame);
>  ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
>  				  void *buffer, size_t size);
> +ssize_t hdmi_audio_infoframe_pack_only(const struct hdmi_audio_infoframe *frame,
> +				       void *buffer, size_t size);
> +int hdmi_audio_infoframe_check(struct hdmi_audio_infoframe *frame);
>  
>  enum hdmi_3d_structure {
>  	HDMI_3D_STRUCTURE_INVALID = -1,
> @@ -299,6 +308,9 @@ struct hdmi_vendor_infoframe {
>  int hdmi_vendor_infoframe_init(struct hdmi_vendor_infoframe *frame);
>  ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
>  				   void *buffer, size_t size);
> +ssize_t hdmi_vendor_infoframe_pack_only(const struct hdmi_vendor_infoframe *frame,
> +					void *buffer, size_t size);
> +int hdmi_vendor_infoframe_check(struct hdmi_vendor_infoframe *frame);
>  
>  union hdmi_vendor_any_infoframe {
>  	struct {
> @@ -330,8 +342,11 @@ union hdmi_infoframe {
>  	struct hdmi_audio_infoframe audio;
>  };
>  
> -ssize_t
> -hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
> +ssize_t hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer,
> +			    size_t size);
> +ssize_t hdmi_infoframe_pack_only(const union hdmi_infoframe *frame,
> +				 void *buffer, size_t size);
> +int hdmi_infoframe_check(union hdmi_infoframe *frame);
>  int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
>  			  const void *buffer, size_t size);
>  void hdmi_infoframe_log(const char *level, struct device *dev,
> 

Regards,

	Hans
