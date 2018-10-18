Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55952 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbeJSDZs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 23:25:48 -0400
Message-ID: <1f439267adf9a492a5d178808ba23682338d7e58.camel@collabora.com>
Subject: RFC: kernelCI media subsystem pilot (Test results for
 gtucker/kernelci-media - gtucker-kernelci-media-001-6-g1b2c6e5844d8)
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, kernelci@groups.io
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.co.uk>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Ana Guerrero Lopez <ana.guerrero@collabora.co.uk>,
        Guillaume Charles Tucker <guillaume.tucker@collabora.co.uk>
Date: Thu, 18 Oct 2018 16:23:10 -0300
References: <b569d756-5c4a-d0b4-e077-27a2e2ebb19d@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

In Collabora, and as part of our kernelci work, we are doing
research on kernel functional testing with kernelci.

For those new to kernelci, see https://github.com/kernelci/kernelci-doc/wiki/KernelCI 
and https://kernelci.org/.

The goal is to lay down the infrastructure required to make
automated test coverage an integral part of our feature
and bugfix development process.

So, as a first attempt, we've decided to extend kernelci test
v4l2 plan support, leading the way to extending
other subsystems' test plans.

Currently, kernelci looks for a list of branches every hour and
see if anything changed. For any branch that has changed, it triggers
builds, boots, tests and reports for each branch that had some changes
since last time it ran.

For this pilot, we've decided to target just a few devices:
qemu with vivid, rk3399-gru-kevin and rk3288-veyron-jaq
with uvc.

We'd like to get some early feedback on this, so we are sending
an example of how a kernelci report would look like, to trigger
some discussion around
the direction this should take.

Thanks!

===
Test results for:
  Tree:    gtucker
  Branch:  kernelci-media
  Kernel:  gtucker-kernelci-media-002-2-gaa27eb0392c7
  URL:     https://gitlab.collabora.com/gtucker/linux.git
  Commit:  aa27eb0392c70adec713e911a9b5267a1d853624
  Test plans: v4l2

Summary
-------
3 test groups results

1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   4 FAIL  28 SKIP
2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   4 FAIL  28 SKIP
3  | v4l2       | qemu                   | arm64 | 168 total: 102 PASS   0 FAIL  66 SKIP


Tests
-----

1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   4 FAIL  28 SKIP

  Config:      defconfig
  Lab Name:    lab-collabora-dev
  Date:        2018-10-18 18:48:52.426000
  TXT log:     http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm64/defconfig/lab-collabora-dev
/v4l2-rk3399-gru-kevin.txt
  HTML log:    http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm64/defconfig/lab-collabora-dev
/v4l2-rk3399-gru-kevin.html
  Rootfs:      http://staging-storage.kernelci.org/images/rootfs/debian/stretchv4l2/20181017.1//arm64/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: e889b0d56757b9a74eb8c4c8cc2ebd5b18e228b2


  Test cases:

    * MMAP: FAIL
    * blocking-wait: PASS
    * read/write: SKIP
    * read/write: SKIP
    * read/write: SKIP
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: SKIP
    * VIDIOC_G/S_PARM: FAIL
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
    * VIDIOC_G/S_EDID: SKIP
    * VIDIOC_DV_TIMINGS_CAP: SKIP
    * VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: SKIP
    * VIDIOC_ENUM/G/S/QUERY_STD: SKIP
    * VIDIOC_G/S_AUDOUT: SKIP
    * VIDIOC_G/S/ENUMOUTPUT: SKIP
    * VIDIOC_ENUMAUDOUT: SKIP
    * VIDIOC_G/S_FREQUENCY: SKIP
    * VIDIOC_G/S_MODULATOR: SKIP
    * VIDIOC_G/S_AUDIO: SKIP
    * VIDIOC_G/S/ENUMINPUT: PASS
    * VIDIOC_ENUMAUDIO: SKIP
    * VIDIOC_S_HW_FREQ_SEEK: SKIP
    * VIDIOC_G/S_FREQUENCY: SKIP
    * VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: SKIP
    * VIDIOC_LOG_STATUS: SKIP
    * VIDIOC_DBG_G/S_REGISTER: SKIP
    * for-unlimited-opens: PASS
    * VIDIOC_G/S_PRIORITY: PASS
    * VIDIOC_QUERYCAP: PASS
    * second-/dev/video0-open: PASS
    * VIDIOC_QUERYCAP: PASS
    * MC-information-see-Media-Driver-Info-above: PASS



2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   4 FAIL  28 SKIP

  Config:      multi_v7_defconfig
  Lab Name:    lab-collabora-dev
  Date:        2018-10-18 17:00:41.724000
  TXT log:     http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm/multi_v7_defconfig/lab-collab
ora-dev/v4l2-rk3288-veyron-jaq.txt
  HTML log:    http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm/multi_v7_defconfig/lab-collab
ora-dev/v4l2-rk3288-veyron-jaq.html
  Rootfs:      http://staging-storage.kernelci.org/images/rootfs/debian/stretchv4l2/20181017.1//armhf/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: e889b0d56757b9a74eb8c4c8cc2ebd5b18e228b2


  Test cases:

    * MMAP: FAIL
    * blocking-wait: PASS
    * read/write: SKIP
    * read/write: SKIP
    * read/write: SKIP
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: SKIP
    * VIDIOC_G/S_PARM: FAIL
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
    * VIDIOC_G/S_EDID: SKIP
    * VIDIOC_DV_TIMINGS_CAP: SKIP
    * VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: SKIP
    * VIDIOC_ENUM/G/S/QUERY_STD: SKIP
    * VIDIOC_G/S_AUDOUT: SKIP
    * VIDIOC_G/S/ENUMOUTPUT: SKIP
    * VIDIOC_ENUMAUDOUT: SKIP
    * VIDIOC_G/S_FREQUENCY: SKIP
    * VIDIOC_G/S_MODULATOR: SKIP
    * VIDIOC_G/S_AUDIO: SKIP
    * VIDIOC_G/S/ENUMINPUT: PASS
    * VIDIOC_ENUMAUDIO: SKIP
    * VIDIOC_S_HW_FREQ_SEEK: SKIP
    * VIDIOC_G/S_FREQUENCY: SKIP
    * VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: SKIP
    * VIDIOC_LOG_STATUS: SKIP
    * VIDIOC_DBG_G/S_REGISTER: SKIP
    * for-unlimited-opens: PASS
    * VIDIOC_G/S_PRIORITY: PASS
    * VIDIOC_QUERYCAP: PASS
    * second-/dev/video0-open: PASS
    * VIDIOC_QUERYCAP: PASS
    * MC-information-see-Media-Driver-Info-above: PASS



3  | v4l2       | qemu                   | arm64 | 168 total: 102 PASS   0 FAIL  66 SKIP

  Config:      defconfig+virtualvideo
  Lab Name:    lab-collabora-dev
  Date:        2018-10-18 18:51:19.917000
  TXT log:     http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm64/defconfig+virtualvideo/lab-
collabora-dev/v4l2-qemu.txt
  HTML log:    http://staging-storage.kernelci.org/gtucker/kernelci-media/gtucker-kernelci-media-002-2-gaa27eb0392c7/arm64/defconfig+virtualvideo/lab-
collabora-dev/v4l2-qemu.html
  Rootfs:      http://staging-storage.kernelci.org/images/rootfs/debian/stretchv4l2/20181017.1//arm64/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: e889b0d56757b9a74eb8c4c8cc2ebd5b18e228b2


  Test cases:

    * blocking-wait: PASS
    * read/write: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * read/write: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * read/write: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_EXPBUF: PASS
    * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: PASS
    * VIDIOC_TRY_DECODER_CMD: SKIP
    * VIDIOC_G_ENC_INDEX: SKIP
    * VIDIOC_TRY_ENCODER_CMD: SKIP
    * Scaling: SKIP
    * Composing: SKIP
    * Cropping: SKIP
    * VIDIOC_G_SLICED_VBI_CAP: SKIP
    * VIDIOC_S_FMT: PASS
    * VIDIOC_TRY_FMT: PASS
    * VIDIOC_G_FMT: PASS
    * VIDIOC_G_FBUF: PASS
    * VIDIOC_G/S_PARM: PASS
    * VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: PASS
    * VIDIOC_G/S_JPEGCOMP: SKIP
    * VIDIOC_UNSUBSCRIBE_EVENT/DQEVENT: PASS
    * VIDIOC_G/S/TRY_EXT_CTRLS: PASS
    * VIDIOC_G/S_CTRL: PASS
    * VIDIOC_QUERYCTRL: PASS
    * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: PASS
    * VIDIOC_G/S_EDID: PASS
    * VIDIOC_DV_TIMINGS_CAP: PASS
    * VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: PASS
    * VIDIOC_ENUM/G/S/QUERY_STD: PASS
    * VIDIOC_G/S_AUDOUT: SKIP
    * VIDIOC_G/S/ENUMOUTPUT: SKIP
    * VIDIOC_ENUMAUDOUT: SKIP
    * VIDIOC_G/S_FREQUENCY: PASS
    * VIDIOC_G/S_MODULATOR: SKIP
    * VIDIOC_G/S_AUDIO: PASS
    * VIDIOC_G/S/ENUMINPUT: PASS
    * VIDIOC_ENUMAUDIO: PASS
    * VIDIOC_S_HW_FREQ_SEEK: SKIP
    * VIDIOC_G/S_FREQUENCY: PASS
    * VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: PASS
    * VIDIOC_LOG_STATUS: PASS
    * VIDIOC_DBG_G/S_REGISTER: SKIP
    * for-unlimited-opens: PASS
    * VIDIOC_G/S_PRIORITY: PASS
    * VIDIOC_QUERYCAP: PASS
    * second-/dev/video0-open: PASS
    * VIDIOC_QUERYCAP: PASS
