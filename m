Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:7746 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964995AbeFOD3r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 23:29:47 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: sakari.ailus@linux.intel.com, linux-media@vger.kernel.org
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com, chao.c.li@intel.com,
        tian.shu.qiu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v1 0/2] Document Intel IPU3 ImgU driver and uAPI
Date: Thu, 14 Jun 2018 22:29:31 -0500
Message-Id: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, All,

This patch set adds documentation on Intel IPU3 ImgU driver and its uAPI, based
on the feedback received for v1 RFC below and ImgU driver patch series:

v1 RFC:
<URL:https://patchwork.kernel.org/patch/10321897/>

ImgU v6:
<URL:https://patchwork.kernel.org/patch/10316739/>

Few unused structs have being removed from intel-ipu3.h since v6. This patch set
will be merged into the next ImgU driver update.

Rajmohan Mani (1):
  doc-rst: Add Intel IPU3 documentation

Yong Zhi (1):
  v4l: Document Intel IPU3 meta data uAPI

 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  174 ++
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/ipu3.rst           |  304 +++
 include/uapi/linux/intel-ipu3.h                    | 2816 ++++++++++++++++++++
 5 files changed, 3296 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
 create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
 create mode 100644 include/uapi/linux/intel-ipu3.h

-- 
2.7.4
