Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:25462 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaBDNTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 08:19:10 -0500
Date: Tue, 04 Feb 2014 11:19:03 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Fw: [PATCH 34/52] devices.txt: add video4linux device for Software
 Defined Radio
Message-id: <20140204111903.5c2e928e@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan/Greg/Andrew/Rob,

Not sure who is currently maintaining Documentation/devices.txt.

We're needing to add support of a new type of V4L2 devices there.

Could you please ack with the following patch? If this one is ok, I intend
to send via my tree together with the patch series that implements support
for it, if you agree.

Thank you!
Mauro

Forwarded message:

Date: Sat, 25 Jan 2014 19:10:28 +0200
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 34/52] devices.txt: add video4linux device for Software Defined Radio


Add new video4linux device named /dev/swradio for Software Defined
Radio use. V4L device minor numbers are allocated dynamically
nowadays, but there is still configuration option for old fixed style.
Add note to mention that configuration option too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/devices.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 80b7241..e852855 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1490,10 +1490,17 @@ Your cooperation is appreciated.
 		 64 = /dev/radio0	Radio device
 		    ...
 		127 = /dev/radio63	Radio device
+		128 = /dev/swradio0	Software Defined Radio device
+		    ...
+		191 = /dev/swradio63	Software Defined Radio device
 		224 = /dev/vbi0		Vertical blank interrupt
 		    ...
 		255 = /dev/vbi31	Vertical blank interrupt
 
+		Minor numbers are allocated dynamically unless
+		CONFIG_VIDEO_FIXED_MINOR_RANGES (default n)
+		configuration option is set.
+
  81 block	I2O hard disk
 		  0 = /dev/i2o/hdq	17th I2O hard disk, whole disk
 		 16 = /dev/i2o/hdr	18th I2O hard disk, whole disk
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
