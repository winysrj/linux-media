Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:59611 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbeHUK7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:59:06 -0400
Subject: [PATCH 7/6] pixfmt-compressed.rst: update vicodec-codec.h reference
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
 <20180821073119.3662-7-hverkuil@xs4all.nl>
Message-ID: <9cf8a2a2-a97c-9c8f-462f-c696e7dd01ce@xs4all.nl>
Date: Tue, 21 Aug 2018 09:39:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180821073119.3662-7-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header has been renamed to codec-fwht.h, so update this
doc as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index d382e7a5c38e..d04b18adac33 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -101,4 +101,4 @@ Compressed Formats
       - 'FWHT'
       - Video elementary stream using a codec based on the Fast Walsh Hadamard
         Transform. This codec is implemented by the vicodec ('Virtual Codec')
-	driver. See the vicodec-codec.h header for more details.
+	driver. See the codec-fwht.h header for more details.
-- 
2.18.0
