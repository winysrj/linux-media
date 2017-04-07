Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57992 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdDGWhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 18:37:31 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 0/7] [media]: vimc: Virtual Media Control VPU's
Date: Fri,  7 Apr 2017 19:37:05 -0300
Message-Id: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
In-Reply-To: <cover.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series improves the current video processing units in vimc
(by adding more controls to the sensor and capture node, allowing the
user to configure different frame formats) and also adds a debayer
and a scaler node.
The debayer transforms the bayer format image received in its sink pad
to a bayer format by averaging the pixels within a mean window.
The scaler only scales up the image for now.

This patch series depends on commit "[media] vimc: Virtual Media Controller core, capture and sensor"
and it is available at:
https://github.com/helen-fornazier/opw-staging/tree/z/sent/vimc/vpu/v2

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
	- check set_fmt default parameters for quantization, colorspace ...
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

Helen Koike (7):
  [media] vimc: sen: Integrate the tpg on the sensor
  [media] vimc: Add vimc_ent_sd_* helper functions
  [media] vimc: Add vimc_pipeline_s_stream in the core
  [media] vimc: sen: Support several image formats
  [media] vimc: cap: Support several image formats
  [media] vimc: deb: Add debayer filter
  [media] vimc: sca: Add scaler

 drivers/media/platform/vimc/Kconfig        |   1 +
 drivers/media/platform/vimc/Makefile       |   3 +-
 drivers/media/platform/vimc/vimc-capture.c | 196 +++++++---
 drivers/media/platform/vimc/vimc-core.c    | 145 +++++++-
 drivers/media/platform/vimc/vimc-core.h    |  65 ++++
 drivers/media/platform/vimc/vimc-debayer.c | 573 +++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-debayer.h |  28 ++
 drivers/media/platform/vimc/vimc-scaler.c  | 426 +++++++++++++++++++++
 drivers/media/platform/vimc/vimc-scaler.h  |  28 ++
 drivers/media/platform/vimc/vimc-sensor.c  | 226 ++++++++----
 10 files changed, 1562 insertions(+), 129 deletions(-)
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.h
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.h

-- 
2.7.4
