Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48354
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752329AbdIATiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 13/14] media: intro.rst: don't assume audio and video codecs to be MPEG2
Date: Fri,  1 Sep 2017 16:37:49 -0300
Message-Id: <92351e29059e3678ec714eb66ee7f10c4fcca3b0.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally, when DVB was introduced, all codecs would be part of
MPEG2 standard. That's not true anymore, as there are a large
number of codec standards used on digital TV nowadays.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index fbae687414ce..79b4d0e4e920 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -94,11 +94,10 @@ Demultiplexer which filters the incoming Digital TV MPEG-TS stream
    streams it also contains data streams with information about the
    programs offered in this or other streams of the same provider.
 
-MPEG2 audio and video decoder
-   The main targets of the demultiplexer are the MPEG2 audio and video
-   decoders. After decoding they pass on the uncompressed audio and
-   video to the computer screen or (through a PAL/NTSC encoder) to a TV
-   set.
+Audio and video decoder
+   The main targets of the demultiplexer are audio and video
+   decoders. After decoding, they pass on the uncompressed audio and
+   video to the computer screen or to a TV set.
 
    .. note::
 
-- 
2.13.5
