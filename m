Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52002 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbcDHVNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 17:13:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v4] [media] tpg: Export the tpg code from vivid as a module
Date: Sat, 09 Apr 2016 00:13:51 +0300
Message-ID: <3574117.sI5vZqXvk9@avalon>
In-Reply-To: <1460147338-31003-1-git-send-email-helen.koike@collabora.co.uk>
References: <1460147338-31003-1-git-send-email-helen.koike@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for the patch.

On Friday 08 Apr 2016 17:28:58 Helen Mae Koike Fornazier wrote:
> The test pattern generator will be used by other drivers as the virtual
> media controller (vimc)
> 
> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> Changes since v3:
> 	- "depends on VIDEO_VIVID" removed from Kconfig
> 	- License changed from GPL v2 to GLP, as the code comes originaly from
> vivid, it should keep the same license - Added  MODULE_AUTHOS("Hans
> Verkuil"), same reason as the license
> 
> The patch is based on 'media/master' branch and available at
>          https://github.com/helen-fornazier/opw-staging tpg/review/vivid
> 
> 
>  drivers/media/common/Kconfig                       |  1 +
>  drivers/media/common/Makefile                      |  2 +-
>  drivers/media/common/v4l2-tpg/Kconfig              |  2 ++
>  drivers/media/common/v4l2-tpg/Makefile             |  3 +++
>  .../v4l2-tpg/v4l2-tpg-colors.c}                    |  7 +++---
>  .../v4l2-tpg/v4l2-tpg-core.c}                      | 25 +++++++++++++++++--
>  drivers/media/platform/vivid/Kconfig               |  1 +
>  drivers/media/platform/vivid/Makefile              |  2 +-
>  drivers/media/platform/vivid/vivid-core.h          |  2 +-
>  .../media/v4l2-tpg-colors.h                        |  6 +++---
>  .../vivid/vivid-tpg.h => include/media/v4l2-tpg.h  |  9 ++++----
>  11 files changed, 43 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/media/common/v4l2-tpg/Kconfig
>  create mode 100644 drivers/media/common/v4l2-tpg/Makefile
>  rename drivers/media/{platform/vivid/vivid-tpg-colors.c =>
> common/v4l2-tpg/v4l2-tpg-colors.c} (99%) rename
> drivers/media/{platform/vivid/vivid-tpg.c =>
> common/v4l2-tpg/v4l2-tpg-core.c} (98%) rename
> drivers/media/platform/vivid/vivid-tpg-colors.h =>
> include/media/v4l2-tpg-colors.h (93%) rename
> drivers/media/platform/vivid/vivid-tpg.h => include/media/v4l2-tpg.h (99%)
> 
> diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
> index 21154dd..326df0a 100644
> --- a/drivers/media/common/Kconfig
> +++ b/drivers/media/common/Kconfig
> @@ -19,3 +19,4 @@ config CYPRESS_FIRMWARE
>  source "drivers/media/common/b2c2/Kconfig"
>  source "drivers/media/common/saa7146/Kconfig"
>  source "drivers/media/common/siano/Kconfig"
> +source "drivers/media/common/v4l2-tpg/Kconfig"
> diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
> index 89b795d..2d1b0a0 100644
> --- a/drivers/media/common/Makefile
> +++ b/drivers/media/common/Makefile
> @@ -1,4 +1,4 @@
> -obj-y += b2c2/ saa7146/ siano/
> +obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/
>  obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>  obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
> diff --git a/drivers/media/common/v4l2-tpg/Kconfig
> b/drivers/media/common/v4l2-tpg/Kconfig new file mode 100644
> index 0000000..7456fc1
> --- /dev/null
> +++ b/drivers/media/common/v4l2-tpg/Kconfig
> @@ -0,0 +1,2 @@
> +config VIDEO_V4L2_TPG
> +	tristate
> diff --git a/drivers/media/common/v4l2-tpg/Makefile
> b/drivers/media/common/v4l2-tpg/Makefile new file mode 100644
> index 0000000..f588df4
> --- /dev/null
> +++ b/drivers/media/common/v4l2-tpg/Makefile
> @@ -0,0 +1,3 @@
> +v4l2-tpg-objs := v4l2-tpg-core.o v4l2-tpg-colors.o
> +
> +obj-$(CONFIG_VIDEO_V4L2_TPG) += v4l2-tpg.o
> diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.c
> b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c similarity index 99%
> rename from drivers/media/platform/vivid/vivid-tpg-colors.c
> rename to drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> index 2299f0c..9bcbd31 100644
> --- a/drivers/media/platform/vivid/vivid-tpg-colors.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> @@ -1,5 +1,5 @@
>  /*
> - * vivid-color.c - A table that converts colors to various colorspaces
> + * v4l2-tpg-colors.c - A table that converts colors to various colorspaces
>   *
>   * The test pattern generator uses the tpg_colors for its test patterns.
>   * For testing colorspaces the first 8 colors of that table need to be
> @@ -12,7 +12,7 @@
>   * This source also contains the code used to generate the tpg_csc_colors
>   * table. Run the following command to compile it:
>   *
> - *	gcc vivid-tpg-colors.c -DCOMPILE_APP -o gen-colors -lm
> + *	gcc v4l2-tpg-colors.c -DCOMPILE_APP -o gen-colors -lm
>   *
>   * and run the utility.
>   *
> @@ -36,8 +36,7 @@
>   */
> 
>  #include <linux/videodev2.h>
> -
> -#include "vivid-tpg-colors.h"
> +#include <media/v4l2-tpg-colors.h>
> 
>  /* sRGB colors with range [0-255] */
>  const struct color tpg_colors[TPG_COLOR_MAX] = {
> diff --git a/drivers/media/platform/vivid/vivid-tpg.c
> b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c similarity index 98%
> rename from drivers/media/platform/vivid/vivid-tpg.c
> rename to drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index da862bb..cf1dadd 100644
> --- a/drivers/media/platform/vivid/vivid-tpg.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -1,5 +1,5 @@
>  /*
> - * vivid-tpg.c - Test Pattern Generator
> + * v4l2-tpg-core.c - Test Pattern Generator
>   *
>   * Note: gen_twopix and tpg_gen_text are based on code from vivi.c. See the
> * vivi.c source for the copyright information of those functions. @@ -20,7
> +20,8 @@
>   * SOFTWARE.
>   */
> 
> -#include "vivid-tpg.h"
> +#include <linux/module.h>
> +#include <media/v4l2-tpg.h>
> 
>  /* Must remain in sync with enum tpg_pattern */
>  const char * const tpg_pattern_strings[] = {
> @@ -48,6 +49,7 @@ const char * const tpg_pattern_strings[] = {
>  	"Noise",
>  	NULL
>  };
> +EXPORT_SYMBOL_GPL(tpg_pattern_strings);
> 
>  /* Must remain in sync with enum tpg_aspect */
>  const char * const tpg_aspect_strings[] = {
> @@ -58,6 +60,7 @@ const char * const tpg_aspect_strings[] = {
>  	"16x9 Anamorphic",
>  	NULL
>  };
> +EXPORT_SYMBOL_GPL(tpg_aspect_strings);
> 
>  /*
>   * Sine table: sin[0] = 127 * sin(-180 degrees)
> @@ -93,6 +96,7 @@ void tpg_set_font(const u8 *f)
>  {
>  	font8x16 = f;
>  }
> +EXPORT_SYMBOL_GPL(tpg_set_font);
> 
>  void tpg_init(struct tpg_data *tpg, unsigned w, unsigned h)
>  {
> @@ -114,6 +118,7 @@ void tpg_init(struct tpg_data *tpg, unsigned w, unsigned
> h) tpg->colorspace = V4L2_COLORSPACE_SRGB;
>  	tpg->perc_fill = 100;
>  }
> +EXPORT_SYMBOL_GPL(tpg_init);
> 
>  int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
>  {
> @@ -150,6 +155,7 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(tpg_alloc);
> 
>  void tpg_free(struct tpg_data *tpg)
>  {
> @@ -174,6 +180,7 @@ void tpg_free(struct tpg_data *tpg)
>  		tpg->random_line[plane] = NULL;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(tpg_free);
> 
>  bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  {
> @@ -403,6 +410,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  	}
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(tpg_s_fourcc);
> 
>  void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
> const struct v4l2_rect *compose)
> @@ -418,6 +426,7 @@ void tpg_s_crop_compose(struct tpg_data *tpg, const
> struct v4l2_rect *crop, tpg->scaled_width = 2;
>  	tpg->recalc_lines = true;
>  }
> +EXPORT_SYMBOL_GPL(tpg_s_crop_compose);
> 
>  void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned
> height, u32 field)
> @@ -442,6 +451,7 @@ void tpg_reset_source(struct tpg_data *tpg, unsigned
> width, unsigned height, (2 * tpg->hdownsampling[p]);
>  	tpg->recalc_square_border = true;
>  }
> +EXPORT_SYMBOL_GPL(tpg_reset_source);
> 
>  static enum tpg_color tpg_get_textbg_color(struct tpg_data *tpg)
>  {
> @@ -1250,6 +1260,7 @@ unsigned tpg_g_interleaved_plane(const struct tpg_data
> *tpg, unsigned buf_line) return 0;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(tpg_g_interleaved_plane);
> 
>  /* Return how many pattern lines are used by the current pattern. */
>  static unsigned tpg_get_pat_lines(const struct tpg_data *tpg)
> @@ -1725,6 +1736,7 @@ void tpg_gen_text(const struct tpg_data *tpg, u8
> *basep[TPG_MAX_PLANES][2], }
>  	}
>  }
> +EXPORT_SYMBOL_GPL(tpg_gen_text);
> 
>  void tpg_update_mv_step(struct tpg_data *tpg)
>  {
> @@ -1773,6 +1785,7 @@ void tpg_update_mv_step(struct tpg_data *tpg)
>  	if (factor < 0)
>  		tpg->mv_vert_step = tpg->src_height - tpg->mv_vert_step;
>  }
> +EXPORT_SYMBOL_GPL(tpg_update_mv_step);
> 
>  /* Map the line number relative to the crop rectangle to a frame line
> number */ static unsigned tpg_calc_frameline(const struct tpg_data *tpg,
> unsigned src_y, @@ -1862,6 +1875,7 @@ void tpg_calc_text_basep(struct
> tpg_data *tpg, if (p == 0 && tpg->interleaved)
>  		tpg_calc_text_basep(tpg, basep, 1, vbuf);
>  }
> +EXPORT_SYMBOL_GPL(tpg_calc_text_basep);
> 
>  static int tpg_pattern_avg(const struct tpg_data *tpg,
>  			   unsigned pat1, unsigned pat2)
> @@ -1891,6 +1905,7 @@ void tpg_log_status(struct tpg_data *tpg)
>  	pr_info("tpg quantization: %d/%d\n", tpg->quantization,
> tpg->real_quantization); pr_info("tpg RGB range: %d/%d\n", tpg->rgb_range,
> tpg->real_rgb_range); }
> +EXPORT_SYMBOL_GPL(tpg_log_status);
> 
>  /*
>   * This struct contains common parameters used by both the drawing of the
> @@ -2296,6 +2311,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg,
> v4l2_std_id std, vbuf + buf_line * params.stride);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(tpg_fill_plane_buffer);
> 
>  void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
> *vbuf) {
> @@ -2312,3 +2328,8 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id
> std, unsigned p, u8 *vbuf) offset += tpg_calc_plane_size(tpg, i);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(tpg_fillbuffer);
> +
> +MODULE_DESCRIPTION("V4L2 Test Pattern Generator");
> +MODULE_AUTHOR("Hans Verkuil");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/vivid/Kconfig
> b/drivers/media/platform/vivid/Kconfig index 0885e93..f535f57 100644
> --- a/drivers/media/platform/vivid/Kconfig
> +++ b/drivers/media/platform/vivid/Kconfig
> @@ -7,6 +7,7 @@ config VIDEO_VIVID
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
>  	select VIDEOBUF2_VMALLOC
> +	select VIDEO_V4L2_TPG
>  	default n
>  	---help---
>  	  Enables a virtual video driver. This driver emulates a webcam,
> diff --git a/drivers/media/platform/vivid/Makefile
> b/drivers/media/platform/vivid/Makefile index 756fc12..633c8a1b 100644
> --- a/drivers/media/platform/vivid/Makefile
> +++ b/drivers/media/platform/vivid/Makefile
> @@ -2,5 +2,5 @@ vivid-objs := vivid-core.o vivid-ctrls.o vivid-vid-common.o
> vivid-vbi-gen.o \ vivid-vid-cap.o vivid-vid-out.o vivid-kthread-cap.o
> vivid-kthread-out.o \ vivid-radio-rx.o vivid-radio-tx.o
> vivid-radio-common.o \
>  		vivid-rds-gen.o vivid-sdr-cap.o vivid-vbi-cap.o vivid-vbi-out.o \
> -		vivid-osd.o vivid-tpg.o vivid-tpg-colors.o
> +		vivid-osd.o
>  obj-$(CONFIG_VIDEO_VIVID) += vivid.o
> diff --git a/drivers/media/platform/vivid/vivid-core.h
> b/drivers/media/platform/vivid/vivid-core.h index 751c1ba..776783b 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -25,7 +25,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-ctrls.h>
> -#include "vivid-tpg.h"
> +#include <media/v4l2-tpg.h>
>  #include "vivid-rds-gen.h"
>  #include "vivid-vbi-gen.h"
> 
> diff --git a/drivers/media/platform/vivid/vivid-tpg-colors.h
> b/include/media/v4l2-tpg-colors.h similarity index 93%
> rename from drivers/media/platform/vivid/vivid-tpg-colors.h
> rename to include/media/v4l2-tpg-colors.h
> index 4e5a76a..2a88d1f 100644
> --- a/drivers/media/platform/vivid/vivid-tpg-colors.h
> +++ b/include/media/v4l2-tpg-colors.h
> @@ -1,5 +1,5 @@
>  /*
> - * vivid-color.h - Color definitions for the test pattern generator
> + * v4l2-tpg-colors.h - Color definitions for the test pattern generator
>   *
>   * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
> reserved. *
> @@ -17,8 +17,8 @@
>   * SOFTWARE.
>   */
> 
> -#ifndef _VIVID_COLORS_H_
> -#define _VIVID_COLORS_H_
> +#ifndef _V4L2_TPG_COLORS_H_
> +#define _V4L2_TPG_COLORS_H_
> 
>  struct color {
>  	unsigned char r, g, b;
> diff --git a/drivers/media/platform/vivid/vivid-tpg.h
> b/include/media/v4l2-tpg.h similarity index 99%
> rename from drivers/media/platform/vivid/vivid-tpg.h
> rename to include/media/v4l2-tpg.h
> index 93fbaee..329bebf 100644
> --- a/drivers/media/platform/vivid/vivid-tpg.h
> +++ b/include/media/v4l2-tpg.h
> @@ -1,5 +1,5 @@
>  /*
> - * vivid-tpg.h - Test Pattern Generator
> + * v4l2-tpg.h - Test Pattern Generator
>   *
>   * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
> reserved. *
> @@ -17,8 +17,8 @@
>   * SOFTWARE.
>   */
> 
> -#ifndef _VIVID_TPG_H_
> -#define _VIVID_TPG_H_
> +#ifndef _V4L2_TPG_H_
> +#define _V4L2_TPG_H_
> 
>  #include <linux/types.h>
>  #include <linux/errno.h>
> @@ -26,8 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/videodev2.h>
> -
> -#include "vivid-tpg-colors.h"
> +#include <media/v4l2-tpg-colors.h>
> 
>  enum tpg_pattern {
>  	TPG_PAT_75_COLORBAR,

-- 
Regards,

Laurent Pinchart

