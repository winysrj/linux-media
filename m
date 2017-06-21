Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53164
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752472AbdFUKP3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 06:15:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH] [media] dvb uapi docs: enums are passed by value, not reference
Date: Wed, 21 Jun 2017 07:14:47 -0300
Message-Id: <aafec43e4c84fb34281672d22283830d4a0fe65c.1498040076.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since 2015, the documentation for FE_DISEQC_SEND_BURST, FE_SET_TONE
and FE_SET_VOLTAGE are incorrectly saying that the enums are passed
by reference. They aren't: they're passed by value.

Fix the documentation to reflect reality.

Fixes: 81959d996a3b ("[media] DocBook: better document FE_DISEQC_SEND_BURST ioctl")
Fixes: d6b6d346e560 ("[media] DocBook: better document FE_SET_VOLTAGE ioctl")
Fixes: 6dc59e7a195f ("[media] DocBook: better document FE_SET_TONE ioctl")
Reported-by: Thierry Lelegard <thierry.lelegard@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst | 2 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst          | 2 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index 26272f2860bc..5c000ab14b86 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -15,7 +15,7 @@ FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite se
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd *tone )
+.. c:function:: int ioctl( int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd tone )
     :name: FE_DISEQC_SEND_BURST
 
 
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index bea193234cb4..d4138e550588 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -15,7 +15,7 @@ FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone )
+.. c:function:: int ioctl( int fd, FE_SET_TONE, enum fe_sec_tone_mode tone )
     :name: FE_SET_TONE
 
 
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index fcf6f38ef18e..ea92002fbd10 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -15,7 +15,7 @@ FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, FE_SET_VOLTAGE, enum fe_sec_voltage *voltage )
+.. c:function:: int ioctl( int fd, FE_SET_VOLTAGE, enum fe_sec_voltage voltage )
     :name: FE_SET_VOLTAGE
 
 
-- 
2.9.4
