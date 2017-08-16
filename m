Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48394 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbdHPMXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:23:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [PATCH v2 0/2] Document s_stream video op calling (MC only) and CSI-2 stream stopping
Date: Wed, 16 Aug 2017 15:20:16 +0300
Message-Id: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I've updated the patch documenting the s_stream() video op calling for MC
enabled devices based on the review comments.

since v1:

- Split "stopping the transmitter" documentation to a separate patch and move it to
  csi2.rst which is a better place for it.

- Precise that the added s_stream() video op documentation only applies to
  Media controller enabled devices.

- Better wording for the note which discourages deep recursion in pipeline
  start / stop.

Sakari Ailus (2):
  docs-rst: media: Document s_stream() video op usage for MC enabled
    devices
  docs-rst: media: Document broken frame handling in stream stop for
    CSI-2

 Documentation/media/kapi/csi2.rst        | 10 ++++++++++
 Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

-- 
2.7.4
