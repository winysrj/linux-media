Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57007 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376Ab3BMV4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 16:56:32 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so642064eaa.27
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 13:56:31 -0800 (PST)
Message-ID: <511C0C0C.3090403@gmail.com>
Date: Wed, 13 Feb 2013 22:56:28 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Timestamp API update for mem-to-mem devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This change set includes a two patches I missed out in my last pull request
which introduce V4L2_BUF_FLAG_TIMESTAMP_COPY buffer flag to indicate the
timestamps are, in case of the mem-to-mem devices, copied from output to
capture buffer queue.

The other two patches is a fix for s3c-camif driver and a patch adding 
device
tree support to the s5p-g2d driver.

Please pull for 3.9 if still possible. There are already some patches queued
for 3.9 improving the timestamps handling and it would be especially useful
to have the below two patches from Kamil together in same kernel release.

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) 
(2013-02-13 18:05:29 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git for_v3.9_2

Kamil Debski (2):
       v4l: Define video buffer flag for the COPY timestamp type
       vb2: Add support for non monotonic timestamps

Sachin Kamat (1):
       s5p-g2d: Add DT based discovery support

Sylwester Nawrocki (1):
       s3c-camif: Fail on insufficient number of allocated buffers

  Documentation/DocBook/media/v4l/io.xml             |    6 ++++
  drivers/media/platform/blackfin/bfin_capture.c     |    1 +
  drivers/media/platform/davinci/vpbe_display.c      |    1 +
  drivers/media/platform/davinci/vpif_capture.c      |    1 +
  drivers/media/platform/davinci/vpif_display.c      |    1 +
  drivers/media/platform/s3c-camif/camif-capture.c   |   16 +++++++--
  drivers/media/platform/s5p-fimc/fimc-capture.c     |    1 +
  drivers/media/platform/s5p-fimc/fimc-lite.c        |    1 +
  drivers/media/platform/s5p-g2d/g2d.c               |   31 
++++++++++++++++++-
  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +
  drivers/media/platform/soc_camera/atmel-isi.c      |    1 +
  drivers/media/platform/soc_camera/mx2_camera.c     |    1 +
  drivers/media/platform/soc_camera/mx3_camera.c     |    1 +
  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    1 +
  drivers/media/platform/vivi.c                      |    1 +
  drivers/media/usb/pwc/pwc-if.c                     |    1 +
  drivers/media/usb/stk1160/stk1160-v4l.c            |    1 +
  drivers/media/usb/uvc/uvc_queue.c                  |    1 +
  drivers/media/v4l2-core/videobuf2-core.c           |    8 ++++-
  include/media/videobuf2-core.h                     |    1 +
  include/uapi/linux/videodev2.h                     |    1 +
  21 files changed, 71 insertions(+), 8 deletions(-)

The corresponding pwclient commands:

pwclient update -s accepted 16650
pwclient update -s accepted 16470
pwclient update -s accepted 16471
pwclient update -s accepted 16733
pwclient update -s superseded 16247
pwclient update -s superseded 16248
pwclient update -s superseded 16246
pwclient update -s superseded 16447
pwclient update -s superseded 16448
pwclient update -s superseded 16449

---

Thanks,
Sylwester
