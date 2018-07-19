Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:40676 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbeGSODd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 10:03:33 -0400
Subject: Re: [PATCH 2/5] videodev.h: add PIX_FMT_FWHT for use with vicodec
To: sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Tom aan de Wiel <tom.aandewiel@gmail.com>
References: <20180719121353.20021-1-hverkuil@xs4all.nl>
 <20180719121353.20021-3-hverkuil@xs4all.nl>
 <20180719131544.kxbwpzssskepwple@lanttu.localdomain>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <d912d4c6-90ec-ed89-31fa-6a5243a7b0de@cisco.com>
Date: Thu, 19 Jul 2018 15:20:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180719131544.kxbwpzssskepwple@lanttu.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/18 15:15, sakari.ailus@iki.fi wrote:
> On Thu, Jul 19, 2018 at 02:13:50PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> Add a new pixelformat for the vicodec software codec using the
>> Fast Walsh Hadamard Transform.
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> 
> Could you add documentation for this format, please?
> 

??? It's part of the patch:

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index abec03937bb3..e5419f046b59 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -95,3 +95,10 @@ Compressed Formats
       - ``V4L2_PIX_FMT_HEVC``
       - 'HEVC'
       - HEVC/H.265 video elementary stream.
+    * .. _V4L2-PIX-FMT-FWHT:
+
+      - ``V4L2_PIX_FMT_FWHT``
+      - 'FWHT'
+      - Video elementary stream using a codec based on the Fast Walsh Hadamard
+        Transform. This codec is implemented by the vicodec ('Virtual Codec')
+	driver.

Since the whole codec is implemented in the vicodec source I didn't think it
necessary to say more about it.

Regards,

	Hans
