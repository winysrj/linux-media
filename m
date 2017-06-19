Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56865 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdFSRA4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:00:56 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 00/12] [media]: vimc: Virtual Media Control VPU's
Date: Mon, 19 Jun 2017 14:00:09 -0300
Message-Id: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series improves the current video processing units in vimc
(by adding more controls to the sensor and capture node, allowing the
user to configure different frame formats) and also adds a debayer
and a scaler node.
The debayer transforms the bayer format image received in its sink pad
to a bayer format by averaging the pixels within a mean window.
The scaler only scales up the image for now.

This patch series is based on media/master and it is available at:
	https://github.com/helen-fornazier/opw-staging/tree/z/sent/vimc/vpu/v5

In this version the errors shown by the sparse tool are fixed

Changes in v5:
[media] vimc: Subdevices as modules
	- Fix vimc_add_subdevs in rollback case. The loop variable can
	be negative, remove 'unsigned' from the loop variable and fix
	warning from smatch tool
[media] vimc: deb: Add debayer filter
	- delare vimc_deb_video_ops as static, remove sparse warning
[media] vimc: sca: Add scaler
	- declare vimc_sca_video_ops as static, remove sparse warning
[media] vimc: sen: Declare vimc_sen_video_ops as static
	- This is a new patch in the series

Changes in v4:
[media] vimc: common: Add vimc_link_validate
	- remove vimc_fmt_pix_to_mbus(), replaced by
	v4l2_fill_mbus_format()
	- remove EXPORT_SYMBOL(vimc_link_validate), not necessary in
	this patch, moved to submodules patch
	- Fix multi-line comment style
	- If colorspace is set to DEFAULT, then assume all the other
	colorimetry parameters are also DEFAULT
[media] vimc: common: Add vimc_colorimetry_clamp
	- this is a new patch in the series
[media] vimc: sen: Support several image formats
	- use vimc_colorimetry_clamp macro
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct
[media] vimc: cap: Support several image formats
	- add vimc_colorimetry_clamp macro
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct
[media] vimc: Subdevices as modules
	- Rebase without [media] vimc: Optimize frame generation the through
	pipe
	- s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL
	- add struct vimc_platform_data to pass the entity's name to the
	sudmodule
	- Fix comment about vimc-input (remove vimc-output comment)
[media] vimc: deb: Add debayer filter
	- Rebase without [media] vimc: Optimize frame generation through
	pipe
	- use vimc_colorimetry_clamp
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct
	- use struct vimc_platform_data to retrieve the entity's name
[media] vimc: sca: Add scaler
	- use vimc_colorimetry_clamp
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct
	- use struct vimc_platform_data to retrieve the entity's name

Changes in v3:
[media] vimc: sen: Integrate the tpg on the sensor
	- Declare frame_size as a local variable
	- Set tpg frame format before starting kthread
	- s_stream(sd, 1): return 0 if stream is already enabled
	- s_stream(sd, 0): return 0 if stream is already disabled
	- s_stream: propagate error from kthread_stop
	- coding style when calling tpg_s_bytesperline
	- s/vimc_thread_sen/vimc_sen_tpg_thread
	- fix multiline comment
	- remove V4L2_FIELD_ALTERNATE from tpg_s_field
	- remove V4L2_STD_PAL from tpg_fill_plane_buffer
[media] vimc: Move common code from the core
	- This is a new patch in the series
[media] vimc: common: Add vimc_ent_sd_* helper
	- add it in vimc-common.c instead in vimc-core.c
	- fix vimc_ent_sd_register, use function parameter to assign
	sd->entity.function instead of using a fixed value
	- rename commit to add the "common" tag
[media] vimc: Add vimc_pipeline_s_stream in the core
	- add it in vimc-common instead of vimc-core
	- rename commit with "common" tag
[media] vimc: common: Add vimc_link_validate
	- this is a new patch in the series
[media] vimc: sen: Support several image formats
	- remove support for V4L2_FIELD_ALTERNATE (left as TODO for now)
	- clamp image size to an even dimension for height and width
	- set default values for colorimetry using _DEFAULT macro
	- reset all values of colorimetry to _DEFAULT if user tries to
	set an invalid colorspace
[media] vimc: cap: Support several image formats
	- use *_DEFAULT macros for colorimetry in the default format
	- clamp height and width of the image by an even value
	- is user try to set colorspace to an invalid format, set all
	colorimetry parameters to _DEFAULT
	- remove V4L2_FMT_FLAG_COMPRESSED from vimc_cap_enum_fmt_vid_cap
	- remove V4L2_BUF_TYPE_VIDEO_CAPTURE from vimc_cap_enum_fmt_vid_cap
	- increase step_width and step_height to 2 instead of 1
	- remove link validate function, use the one in vimc-common.c
[media] vimc: Subdevices as modules
	- This is a new patch in the series
[media] vimc: deb: Add debayer filter
	- Declare frame_size as a local variable
	- s_stream(sd, 1): return 0 if stream is already enabled
	- s_stream(sd, 0): return 0 if stream is already disabled
	- s_stream: add ret variable to propagate return errors
	- structure code to be a module, use platform_driver and component system
	- fix multiline comment
	- s/thought/through
	- s/RGB8888/RGB888
	- clamp height and width of the image by an even value
	- if user try to set colorspace to an invalid format, set all
        colorimetry parameters to _DEFAULT
	- uset _DEFAULT for colorimetry in the default format
[media] vimc: sca: Add scaler
	- Declare frame_size as a local variable
	- s_stream(sd, 1): return 0 if stream is already enabled
	- s_stream(sd, 0): return 0 if stream is already disabled
	- s_stream: add ret variable to propagate return errors
	- structure code to be a module, use platform_driver and component system
	- s/thought/through
	- clamp height and width of the image by an even value
	- if user try to set colorspace to an invalid format, set all
	    colorimetry parameters to _DEFAULT
	- uset _DEFAULT for colorimetry in the default format

Changes in v2:
[media] vimc: sen: Integrate the tpg on the sensor
	- Fix include location
	- Select V4L2_TPG in Kconfig
	- configure tpg on streamon only
	- rm BUG_ON
	- coding style
[media] vimc: Add vimc_ent_sd_* helper functions
	- Comments in vimc_ent_sd_init
	- Update vimc_ent_sd_init with upstream code as media_entity_pads_init
	(instead of media_entity_init), entity->function intead of entity->type
	- Add missing vimc_pads_cleanup in vimc_ent_sd_cleanup
	- remove subdevice v4l2_dev and dev fields
	- change unregister order in vimc_ent_sd_cleanup
	- rename vimc_ent_sd_{init,cleanup} to vimc_ent_sd_{register,unregister}
	- remove struct vimc_ent_subdevice, use ved and sd directly
	- don't impose struct vimc_sen_device to declare ved and sd struct first
	- add kernel docs
[media] vimc: Add vimc_pipeline_s_stream in the core
	- Use is_media_entity_v4l2_subdev instead of comparing with the old
	entity->type
	- Fix comments style
	- add kernel-docs
	- call s_stream across all sink pads
[media] vimc: sen: Support several image formats
	- this is a new commit in the serie (the old one was splitted in two)
	- add init_cfg to initialize try_fmt
	- reorder code in vimc_sen_set_fmt
	- allow user space to change all fields from struct v4l2_mbus_framefmt
	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
	- merge with patch for the enum_mbus_code and enum_frame_size
	- change commit message
	- add vimc_pix_map_by_index
	- rename MIN/MAX macros
	- check set_fmt default parameters for quantization, colorspace ...media] vimc: sen: Support several image formats
[media] vimc: cap: Support several image formats
	- this is a new commit in the serie (the old one was splitted in two)
	- allow user space to change all fields from struct v4l2_pix_format
	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
	- link_validate and try_fmt: also checks colospace, quantization, field, xfer_func, ycbcr_enc
	- add struct v4l2_pix_format fmt_default
	- add enum_framesizes
	- enum_fmt_vid_cap: enumerate all formats from vimc_pix_map_table
	- add mode dev_dbg
[media] vimc: deb: Add debayer filter
	- Using MEDIA_ENT_F_ATV_DECODER in function
	- remove v4l2_dev and dev from vimc_deb_device struct
	- src fmt propagates from the sink
	- coding style
	- remove redundant else if statements
	- check end of enum and remove BUG_ON
	- enum frame size with min and max values
	- set/try fmt
	- remove unecessary include freezer.h
	- check pad types on create
	- return EBUSY when trying to set the format while stream is on
	- remove vsd struct
	- add IS_SRC and IS_SINK macros
	- add deb_mean_win_size as a parameter of the module
	- check set_fmt default parameters for quantization, colorspace ...
	- add more dev_dbg
[media] vimc: sca: Add scaler
	- Add function MEDIA_ENT_F_IO_V4L
	- remove v4l2_dev and dev
	- s/sink_mbus_fmt/sink_fmt
	- remove BUG_ON, remove redundant if else, rewrite TODO, check end of enum
	- rm src_width/height, enum fsize with min and max values
	- set/try fmt
	- remove unecessary include freezer.h
	- core: add bayer boolean in pixel table
	- coding style
	- fix bug in enum frame size
	- check pad types on create
	- return EBUSY when trying to set the format while stream is on
	- remove vsd struct
	- add IS_SRC and IS_SINK macros
	- add sca_mult as a parameter of the module
	- check set_fmt default parameters for quantization, colorspace ...
	- add more dev_dbg

Helen Koike (12):
  [media] vimc: sen: Integrate the tpg on the sensor
  [media] vimc: Move common code from the core
  [media] vimc: common: Add vimc_ent_sd_* helper
  [media] vimc: common: Add vimc_pipeline_s_stream helper
  [media] vimc: common: Add vimc_link_validate
  [media] vimc: common: Add vimc_colorimetry_clamp
  [media] vimc: sen: Support several image formats
  [media] vimc: cap: Support several image formats
  [media] vimc: Subdevices as modules
  [media] vimc: deb: Add debayer filter
  [media] vimc: sca: Add scaler
  [media] vimc: sen: Declare vimc_sen_video_ops as static

 drivers/media/platform/vimc/Kconfig        |   1 +
 drivers/media/platform/vimc/Makefile       |  10 +-
 drivers/media/platform/vimc/vimc-capture.c | 321 ++++++++-------
 drivers/media/platform/vimc/vimc-capture.h |  28 --
 drivers/media/platform/vimc/vimc-common.c  | 473 ++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-common.h  | 229 +++++++++++
 drivers/media/platform/vimc/vimc-core.c    | 610 ++++++++---------------------
 drivers/media/platform/vimc/vimc-core.h    | 112 ------
 drivers/media/platform/vimc/vimc-debayer.c | 601 ++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-scaler.c  | 455 +++++++++++++++++++++
 drivers/media/platform/vimc/vimc-sensor.c  | 321 ++++++++++-----
 drivers/media/platform/vimc/vimc-sensor.h  |  28 --
 12 files changed, 2325 insertions(+), 864 deletions(-)
 delete mode 100644 drivers/media/platform/vimc/vimc-capture.h
 create mode 100644 drivers/media/platform/vimc/vimc-common.c
 create mode 100644 drivers/media/platform/vimc/vimc-common.h
 delete mode 100644 drivers/media/platform/vimc/vimc-core.h
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
 delete mode 100644 drivers/media/platform/vimc/vimc-sensor.h

-- 
2.7.4
