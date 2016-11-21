Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49414 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753680AbcKUOQt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:16:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] ti-vpe: fixes and enhancements + davinci compile
 warning fix
Message-ID: <8dea2fe5-6b80-3d9f-b40d-4f25cd1a666b@xs4all.nl>
Date: Mon, 21 Nov 2016 15:16:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See 
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1275718.html for
details.

Also added a davinci compile warning fix that I encountered while 
compiling this
series.

Regards,

	Hans

The following changes since commit f2709c206d8a3e11729e68d80c57e7470bbe8e5e:

   Revert "[media] dvb_frontend: merge duplicate dvb_tuner_ops.release 
implementations" (2016-11-18 20:44:33 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git vpe

for you to fetch changes up to bfafa9565c306a462b6e5dc2f8ddb1e633382e5c:

   vpfe_capture: fix compiler warning (2016-11-21 15:02:06 +0100)

----------------------------------------------------------------
Archit Taneja (1):
       media: ti-vpe: Use line average de-interlacing for first 2 frames

Benoit Parrot (16):
       media: ti-vpe: vpdma: Make vpdma library into its own module
       media: ti-vpe: vpdma: Add multi-instance and multi-client support
       media: ti-vpe: vpdma: Add helper to set a background color
       media: ti-vpe: vpdma: Fix bus error when vpdma is writing a 
descriptor
       media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
       media: ti-vpe: vpdma: Corrected YUV422 data type label.
       media: ti-vpe: vpdma: RGB data type yield inverted data
       media: ti-vpe: vpe: Fix vb2 buffer cleanup
       media: ti-vpe: vpe: Enable DMABUF export
       media: ti-vpe: Make scaler library into its own module
       media: ti-vpe: scaler: Add debug support for multi-instance
       media: ti-vpe: vpe: Make sure frame size dont exceed scaler capacity
       media: ti-vpe: vpdma: Add RAW8 and RAW16 data types
       media: ti-vpe: Make colorspace converter library into its own module
       media: ti-vpe: csc: Add debug support for multi-instance
       media: ti-vpe: vpe: Add proper support single and multi-plane buffer

Hans Verkuil (1):
       vpfe_capture: fix compiler warning

Harinarayan Bhatta (2):
       media: ti-vpe: Increasing max buffer height and width
       media: ti-vpe: Free vpdma buffers in vpe_release

Nikhil Devshatwar (16):
       media: ti-vpe: vpe: Do not perform job transaction atomically
       media: ti-vpe: Add support for SEQ_TB buffers
       media: ti-vpe: vpe: Return NULL for invalid buffer type
       media: ti-vpe: vpdma: Add support for setting max width height
       media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs
       media: ti-vpe: vpdma: Make list post atomic operation
       media: ti-vpe: vpdma: Clear IRQs for individual lists
       media: ti-vpe: vpe: configure line mode separately
       media: ti-vpe: vpe: Setup srcdst parameters in start_streaming
       media: ti-vpe: vpe: Post next descriptor only for list complete IRQ
       media: ti-vpe: vpe: Add RGB565 and RGB5551 support
       media: ti-vpe: vpdma: allocate and maintain hwlist
       media: ti-vpe: sc: Fix incorrect optimization
       media: ti-vpe: vpdma: Fix race condition for firmware loading
       media: ti-vpe: vpdma: Use bidirectional cached buffers
       media: ti-vpe: vpe: Fix line stride for output motion vector

  drivers/media/platform/Kconfig                |  14 ++
  drivers/media/platform/davinci/vpfe_capture.c |   4 +-
  drivers/media/platform/ti-vpe/Makefile        |  10 +-
  drivers/media/platform/ti-vpe/csc.c           |  18 ++-
  drivers/media/platform/ti-vpe/csc.h           |   2 +-
  drivers/media/platform/ti-vpe/sc.c            |  28 ++--
  drivers/media/platform/ti-vpe/sc.h            |  11 +-
  drivers/media/platform/ti-vpe/vpdma.c         | 349 
+++++++++++++++++++++++++++++++++++++++-----
  drivers/media/platform/ti-vpe/vpdma.h         |  85 ++++++++++-
  drivers/media/platform/ti-vpe/vpdma_priv.h    | 130 ++++++++---------
  drivers/media/platform/ti-vpe/vpe.c           | 450 
+++++++++++++++++++++++++++++++++++++++++++++++----------
  11 files changed, 894 insertions(+), 207 deletions(-)
