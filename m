Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0069.outbound.protection.outlook.com ([104.47.41.69]:45611
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752207AbeBIBWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 20:22:16 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v2 9/9] [media] Add documentation for YUV420 bus format
Date: Thu, 8 Feb 2018 17:22:07 -0800
Message-ID: <1518139327-21947-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code is MEDIA_BUS_FMT_VYYUYY8_1X24

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 34 +++++++++++++++++++++=
++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentatio=
n/media/uapi/v4l/subdev-formats.rst
index b1eea44..a4d7d87 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -7283,6 +7283,40 @@ The following table list existing packed 48bit wide =
YUV formats.
       - y\ :sub:`1`
       - y\ :sub:`0`

+      - MEDIA_BUS_FMT_VYYUYY8_1X24
+      - 0x202c
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`

 .. raw:: latex

--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
