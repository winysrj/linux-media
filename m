Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0082.outbound.protection.outlook.com ([104.47.40.82]:20928
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751536AbdHISxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 14:53:44 -0400
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <hyun.kwon@xilinx.com>,
        Rohit Athavale <rathaval@xilinx.com>
Subject: [PATCH 0/3] Xilinx 8-bit color depth YCbCr 4:2:0 media bus format
Date: Wed, 9 Aug 2017 11:27:51 -0700
Message-ID: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set adds a vendor specific custom YCbCr 4:2:0 format. The way
Xilinx Video IP sends data over the bus makes it unrepresented by existing
media bus formats.

YCbCr 4:2:0 transmission over the bus does not slice Chroma and Luma
components over the bus width. Instead it sends sub-sampled Chroma when
present along with the Luma component, otherwise zero padded Luma only
data is sent.

The first patch  (1/3) adds the format to the uapi header file.
The second patch (2/3) adds the format to the table in xilinx-vip.c.
The third patch  (3/3) updates the subdev format doc file.

Rohit Athavale (3):
  uapi: media-bus-format: Add Xilinx specific YCbCr 4:2:0 media bus
    format
  media: xilinx-vip: Add 8-bit YCbCr 4:2:0 to formats table
  Documentation: subdev-formats: Add Xilinx YCbCr to Vendor specific
    area

 Documentation/media/uapi/v4l/subdev-formats.rst | 5 +++++
 drivers/media/platform/xilinx/xilinx-vip.c      | 3 +++
 include/uapi/linux/media-bus-format.h           | 4 +++-
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
1.9.1
