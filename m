Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57287 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdJMLap (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 07:30:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 04/17] media: v4l2-common.h: document ancillary functions
Date: Fri, 13 Oct 2017 14:30:57 +0300
Message-ID: <1862933.xO50N3FPej@avalon>
In-Reply-To: <8b06a3313f0e991b37fd36f29d8ee33561177ec7.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <8b06a3313f0e991b37fd36f29d8ee33561177ec7.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:47 EEST Mauro Carvalho Chehab wrote:
> There are several ancillary functions that aren't documented.
> 
> Document them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c |  14 -----
>  include/media/v4l2-common.h           | 104 +++++++++++++++++++++++++++----
>  2 files changed, 94 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c
> b/drivers/media/v4l2-core/v4l2-common.c index fb9a2a3c1072..ac404d5083e0
> 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -320,20 +320,6 @@ static unsigned int clamp_align(unsigned int x,
> unsigned int min, return x;
>  }
> 
> -/* Bound an image to have a width between wmin and wmax, and height between
> - * hmin and hmax, inclusive.  Additionally, the width will be a multiple
> of - * 2^walign, the height will be a multiple of 2^halign, and the overall
> size - * (width*height) will be a multiple of 2^salign.  The image may be
> shrunk - * or enlarged to fit the alignment constraints.
> - *
> - * The width or height maximum must not be smaller than the corresponding
> - * minimum.  The alignments must not be so high there are no possible image
> - * sizes within the allowed bounds.  wmin and hmin must be at least 1 - *
> (don't use 0).  If you don't care about a certain alignment, specify 0, - *
> as 2^0 is 1 and one byte alignment is equivalent to no alignment.  If - *
> you only want to adjust downward, specify a maximum that's the same as - *
> the initial value.
> - */

I still think documentation would be much better placed in C files than header 
files. Maybe we could quickly discuss this during the media summit at ELCE.

>  void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
>  			   unsigned int walign,
>  			   u32 *h, unsigned int hmin, unsigned int hmax,
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 7ae7840df068..d3f5f907d566 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -174,17 +174,43 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd,
> struct i2c_client *client, */
>  unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
> 
> +/**
> + * enum v4l2_i2c_tuner_type - specifies the range of tuner address that
> + *	should be used when seeking for I2C devices.
> + *
> + * @ADDRS_RADIO:		Radio tuner addresses.
> + * 				Represent the following I2C addresses:
> + * 				0x10 (if compiled with tea5761 support)
> + *				and 0x60.
> + * @ADDRS_DEMOD:		Demod tuner addresses.
> + * 				Represent the following I2C addresses:
> + * 				0x42, 0x43, 0x4a and 0x4b.
> + * @ADDRS_TV:			TV tuner addresses.
> + * 				Represent the following I2C addresses:
> + * 				0x42, 0x43, 0x4a, 0x4b, 0x60, 0x61, 0x62,
> + *				0x63 and 0x64.
> + * @ADDRS_TV_WITH_DEMOD:	TV tuner addresses if demod is present, this
> + *				excludes addresses used by the demodulator
> + *				from the list of candidates.
> + * 				Represent the following I2C addresses:
> + * 				0x60, 0x61, 0x62, 0x63 and 0x64.
> + *
> + * NOTE: All I2C addresses above use the 7-bit notation.
> + */
>  enum v4l2_i2c_tuner_type {
> -	ADDRS_RADIO,	/* Radio tuner addresses */
> -	ADDRS_DEMOD,	/* Demod tuner addresses */
> -	ADDRS_TV,	/* TV tuner addresses */
> -	/* TV tuner addresses if demod is present, this excludes
> -	   addresses used by the demodulator from the list of
> -	   candidates. */
> +	ADDRS_RADIO,
> +	ADDRS_DEMOD,
> +	ADDRS_TV,
>  	ADDRS_TV_WITH_DEMOD,
>  };
> -/* Return a list of I2C tuner addresses to probe. Use only if the tuner
> -   addresses are unknown. */
> +/**
> + * v4l2_i2c_tuner_addrs - Return a list of I2C tuner addresses to probe.
> + *
> + * @type: type of the tuner type to seek, as defined by

s/tuner type/tuner/

> + *	  &enum v4l2_i2c_tuner_type.
> + *
> + * NOTE: Use only if the tuner addresses are unknown.
> + */
>  const unsigned short *v4l2_i2c_tuner_addrs(enum v4l2_i2c_tuner_type type);
> 
>  /* --------------------------------------------------------------------- */
>  @@ -228,6 +254,9 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd,
> struct spi_device *spi,
>   * FIXME: these remaining ioctls/structs should be removed as well, but
>   they
>   * are still used in tuner-simple.c (TUNER_SET_CONFIG) and cx18/ivtv
>   (RESET).
>   * To remove these ioctls some more cleanup is needed in those modules.
> + *
> + * It doesn't make much sense on documenting them, as what we really want
> is
> + * to get rid of them.
>   */
> 
>  /* s_config */
> @@ -243,17 +272,72 @@ struct v4l2_priv_tun_config {
> 
>  /* Miscellaneous helper functions */
> 
> -void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
> +/**
> + * v4l_bound_align_image - adjust video dimensions according to
> + * 	a given criteria.

s/a given criteria/the given constraints/

> + *
> + * @width:	pointer to width that will be adjusted if needed.
> + * @wmin:	minimum width.
> + * @wmax:	maximum width.
> + * @walign:	least significant bit on width.
> + * @height:	pointer to height that will be adjusted if needed.
> + * @hmin:	minimum height.
> + * @hmax:	maximum height.
> + * @halign:	least significant bit on width.
> + * @salign:	least significant bit for the image size (e. g.
> + *		:math:`width * height`).
> + *
> + * Bound an image to have @width between @wmin and @wmax, and @height
> between
> + * @hmin and @hmax, inclusive.

s/Bound/Bind/ ? I think "Clip" would be better actually.

> + *
> + * Additionally, the @width will be a multiple of :math:`2^{walign}`,
> + * the @height will be a multiple of :math:`2^{halign}`, and the overall
> + * size :math:`width * height` will be a multiple of :math:`2^{salign}`.
> + *
> + * .. note::
> + *
> + *    #. The image may be shrunk or enlarged to fit the alignment
> constraints.

It's not the image that will be shrunk or enlarged, but the clipping 
rectangle.

> + *    #. @wmax must not be smaller than @wmin.
> + *    #. @hmax must not be smaller than @hmin.
> + *    #. The alignments must not be so high there are no possible image
> + *       sizes within the allowed bounds.
> + *    #. @wmin and @hmin must be at least 1 (don't use 0).
> + *    #. For @walign, @halign and @salign, if you don't care about a
> certain
> + *       alignment, specify ``0``, as :math:`2^0 = 1` and one byte
> alignment
> + *       is equivalent to no alignment.
> + *    #. If you only want to adjust downward, specify a maximum that's the
> + *       same as the initial value.
> + */
> +void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
>  			   unsigned int wmax, unsigned int walign,
> -			   unsigned int *h, unsigned int hmin,
> +			   unsigned int *height, unsigned int hmin,
>  			   unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
> 
> +/**
> + * v4l2_find_nearest_format - find the nearest format size among a discrete
> + *	set of resolutions.
> + *
> + * @sizes: array with a pointer to & struct v4l2_frmsize_discrete image
> sizes.
> + * @num_sizes: size of @sizes array.

I'd say "length" instead of "size", or "number of elements in the @sizes 
array". Size could be interpreted as the array size in bytes.

> + * @width: desired width.
> + * @height: desired heigth.
> + *
> + * Finds the closest resolution to minimize the width and height
> differences
> + * between what userspace requested and the supported resolutions.

This function isn't restricted to be used to handle userspace sizes, I 
wouldn't mention userspace here.

> + */
>  const struct v4l2_frmsize_discrete
>  *v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
>  			  const size_t num_sizes,
>  			  s32 width, s32 height);
> 
> +/**
> + * v4l2_get_timestamp - ancillary routine to get a timestamp to be used
> when
> + *	filling streaming metadata. Internally, it uses ktime_get_ts(), +
> *	with is the recommended way to get it.

s/with/which/

> + *
> + * @tv: pointer to &stuct timeval to be filled.
> + */
>  void v4l2_get_timestamp(struct timeval *tv);
> 
>  #endif /* V4L2_COMMON_H_ */


-- 
Regards,

Laurent Pinchart
