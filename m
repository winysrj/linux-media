Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51404 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751174AbdKMOeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 09:34:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv1 PATCH 0/6] v4l2-ctrls: implement requests
Date: Mon, 13 Nov 2017 15:34:02 +0100
Message-Id: <20171113143408.19644-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi Alexandre,

This is a first implementation of the request API in the
control framework. It is fairly simplistic at the moment in that
it just clones all the control values (so no refcounting yet for
values as Laurent proposed, I will work on that later). But this
should not be a problem for codecs since there aren't all that many
controls involved.

The API is as follows:

struct v4l2_ctrl_handler *v4l2_ctrl_request_alloc(void);

This allocates a struct v4l2_ctrl_handler that is empty (i.e. has
no controls) but is refcounted and is marked as representing a
request.

int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
                            const struct v4l2_ctrl_handler *from,
                            bool (*filter)(const struct v4l2_ctrl *ctrl));

Delete any existing controls in handler 'hdl', then clone the values
from an existing handler 'from' into 'hdl'. If 'from' == NULL, then
this just clears the handler. 'from' can either be another request
control handler or a regular control handler in which case the
current values are cloned. If 'filter' != NULL then you can
filter which controls you want to clone.

void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl);

Increase the refcount.

void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl);

Decrease the refcount and delete hdl if it reaches 0.

void v4l2_ctrl_request_setup(struct v4l2_ctrl_handler *hdl);

Apply the values from the handler (i.e. request object) to the
hardware.

You will have to modify v4l_g/s/try_ext_ctrls in v4l2-ioctls.c to
obtain the request v4l2_ctrl_handler pointer based on the request
field in struct v4l2_ext_controls.

The first patch in this series is necessary to avoid cloning
controls that belong to other devices (as opposed to the subdev
or bridge device for which you make a request). It can probably
be dropped for codecs, but it is needed for MC devices like
omap3isp.

This series has only been compile tested! So if it crashes as
soon as you try to use it, then that's why :-)

Note: I'm not sure if it makes sense to refcount the control
handler, you might prefer to have a refcount in a higher-level
request struct. If that's the case, then I can drop the _get
function and replace the _put function by a v4l2_ctrl_request_free()
function.

Good luck!

	Hans

Hans Verkuil (6):
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: add core request API
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: support g/s_ext_ctrls for requests
  v4l2-ctrls: add v4l2_ctrl_request_setup

 drivers/media/dvb-frontends/rtl2832_sdr.c        |   5 +-
 drivers/media/pci/bt8xx/bttv-driver.c            |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c          |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c          |   2 +-
 drivers/media/pci/cx88/cx88-video.c              |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c      |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c        |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c      |   3 +-
 drivers/media/platform/rcar_drif.c               |   2 +-
 drivers/media/platform/soc_camera/soc_camera.c   |   3 +-
 drivers/media/platform/vivid/vivid-ctrls.c       |  42 ++--
 drivers/media/usb/cx231xx/cx231xx-417.c          |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c        |   4 +-
 drivers/media/usb/msi2500/msi2500.c              |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c          |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             | 242 +++++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-device.c            |   3 +-
 drivers/staging/media/imx/imx-media-dev.c        |   2 +-
 drivers/staging/media/imx/imx-media-fim.c        |   2 +-
 include/media/v4l2-ctrls.h                       |  17 +-
 21 files changed, 287 insertions(+), 60 deletions(-)

-- 
2.14.1
