Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33714 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbcDYGht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 02:37:49 -0400
From: Eric Engestrom <eric@engestrom.ch>
To: linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric@engestrom.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 37/41] Documentation: video4linux: fix spelling mistakes
Date: Mon, 25 Apr 2016 07:37:03 +0100
Message-Id: <1461566229-4717-11-git-send-email-eric@engestrom.ch>
In-Reply-To: <1461566229-4717-1-git-send-email-eric@engestrom.ch>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
 <1461566229-4717-1-git-send-email-eric@engestrom.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
---
 Documentation/video4linux/vivid.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index e35d376..8da5d2a 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -294,7 +294,7 @@ the result will be.
 
 These inputs support all combinations of the field setting. Special care has
 been taken to faithfully reproduce how fields are handled for the different
-TV standards. This is particularly noticable when generating a horizontally
+TV standards. This is particularly noticeable when generating a horizontally
 moving image so the temporal effect of using interlaced formats becomes clearly
 visible. For 50 Hz standards the top field is the oldest and the bottom field
 is the newest in time. For 60 Hz standards that is reversed: the bottom field
@@ -313,7 +313,7 @@ will be SMPTE-170M.
 The pixel aspect ratio will depend on the TV standard. The video aspect ratio
 can be selected through the 'Standard Aspect Ratio' Vivid control.
 Choices are '4x3', '16x9' which will give letterboxed widescreen video and
-'16x9 Anomorphic' which will give full screen squashed anamorphic widescreen
+'16x9 Anamorphic' which will give full screen squashed anamorphic widescreen
 video that will need to be scaled accordingly.
 
 The TV 'tuner' supports a frequency range of 44-958 MHz. Channels are available
@@ -862,7 +862,7 @@ RDS Radio Text:
 RDS Stereo:
 RDS Artificial Head:
 RDS Compressed:
-RDS Dymanic PTY:
+RDS Dynamic PTY:
 RDS Traffic Announcement:
 RDS Traffic Program:
 RDS Music: these are all controls that set the RDS data that is transmitted by
-- 
2.8.0

