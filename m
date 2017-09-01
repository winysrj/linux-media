Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48389
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752503AbdIATiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 07/14] media: dmx-fread.rst: specify how DMX_CHECK_CRC works
Date: Fri,  1 Sep 2017 16:37:43 -0300
Message-Id: <260ebb53e3bc42b8cf45d2ccf6b8344935677593.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, the documentation used to say that, if a CRC error
was found, a "-ECRC" error would be returned. That's not true:
the DVB core will just silently ignore such errors.

So, add an explicit note about that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-fread.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index cb6cedbb47f6..36ba851bc0af 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -38,6 +38,13 @@ data. The filtered data is transferred from the driver’s internal
 circular buffer to buf. The maximum amount of data to be transferred is
 implied by count.
 
+.. note::
+
+   if a section filter created with
+   :c:type:`DMX_CHECK_CRC <dmx_sct_filter_params>` flag set,
+   data that fails on CRC check will be silently ignored.
+
+
 Return Value
 ------------
 
-- 
2.13.5
