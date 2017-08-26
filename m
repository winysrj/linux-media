Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53439
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752153AbdHZKHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 6/6] media: dvbproperty.rst: minor editorial changes
Date: Sat, 26 Aug 2017 07:07:14 -0300
Message-Id: <d9f6164eb9319c8fc6eee20e2bd8da09886eebe1.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do some minor editorial changes to make this chapter visually
better, and the example a little bit clearer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dvbproperty.rst | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 1e8fc75e469d..843f1d70aff0 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -8,8 +8,8 @@ DVB Frontend properties
 Tuning into a Digital TV physical channel and starting decoding it
 requires changing a set of parameters, in order to control the tuner,
 the demodulator, the Linear Low-noise Amplifier (LNA) and to set the
-antenna subsystem via Satellite Equipment Control (SEC), on satellite
-systems. The actual parameters are specific to each particular digital
+antenna subsystem via Satellite Equipment Control - SEC (on satellite
+systems). The actual parameters are specific to each particular digital
 TV standards, and may change as the digital TV specs evolves.
 
 In the past (up to DVB API version 3), the strategy used was to have a
@@ -41,25 +41,24 @@ with suppports all digital TV delivery systems.
    4. DVB API version 5 is also called *S2API*, as the first
       new standard added to it was DVB-S2.
 
-Example: with the properties based approach, in order to set the tuner
-to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and
-symbol rate of 5.217 Mbauds, those properties should be sent to
+**Example**: in order to set the hardware to tune into a DVB-C channel
+at 651 kHz, modulated with 256-QAM, FEC 3/4 and symbol rate of 5.217
+Mbauds, those properties should be sent to
 :ref:`FE_SET_PROPERTY <FE_GET_PROPERTY>` ioctl:
 
--  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>` =
-   SYS_DVBC_ANNEX_A
+  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>` = SYS_DVBC_ANNEX_A
 
--  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>` = 651000000
+  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>` = 651000000
 
--  :ref:`DTV_MODULATION <DTV-MODULATION>` = QAM_256
+  :ref:`DTV_MODULATION <DTV-MODULATION>` = QAM_256
 
--  :ref:`DTV_INVERSION <DTV-INVERSION>` = INVERSION_AUTO
+  :ref:`DTV_INVERSION <DTV-INVERSION>` = INVERSION_AUTO
 
--  :ref:`DTV_SYMBOL_RATE <DTV-SYMBOL-RATE>` = 5217000
+  :ref:`DTV_SYMBOL_RATE <DTV-SYMBOL-RATE>` = 5217000
 
--  :ref:`DTV_INNER_FEC <DTV-INNER-FEC>` = FEC_3_4
+  :ref:`DTV_INNER_FEC <DTV-INNER-FEC>` = FEC_3_4
 
--  :ref:`DTV_TUNE <DTV-TUNE>`
+  :ref:`DTV_TUNE <DTV-TUNE>`
 
 The code that would that would do the above is show in
 :ref:`dtv-prop-example`.
-- 
2.13.3
