Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36103 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEN2O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 08:28:14 -0500
Received: by mail-pf0-f194.google.com with SMTP id c4so17112538pfb.3
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 05:28:14 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        eraikhel <evgeni.raikhel@intel.com>
Subject: [PATCH 0/2] uvcvideo: *** Support Intel SR300 Depth camera formats ***
Date: Mon,  5 Dec 2016 15:24:57 +0200
Message-Id: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: eraikhel <evgeni.raikhel@intel.com>

*** Enable Intel RealSense™ SR300 Depth camera pixel formats to be recognized correctly by uvc module  ***

Aviv Greenberg (1):
  UVC: Add support for Intel SR300 depth camera

Evgeni Raikhel (1):
  Document Intel SR300 Depth camera INZI format

 Documentation/media/uapi/v4l/pixfmt-inzi.rst | 40 ++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c           | 15 +++++++++++
 drivers/media/usb/uvc/uvcvideo.h             |  9 +++++++
 include/uapi/linux/videodev2.h               |  1 +
 4 files changed, 65 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst

-- 
2.7.4

