Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44944
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbdHaXrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 01/15] media: dvb/intro: use the term Digital TV to refer to the system
Date: Thu, 31 Aug 2017 20:46:48 -0300
Message-Id: <d6c0a23fb69210b6b59ece27a2f28e10cfb41080.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On several places at the introduction, a digital TV board and its
kernel support is called as DVB. The reason is simple: by the
time the document was written, there were no other digital TV
standards :-)

Modernize the specs by referring to them as Digital TV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 20bd7aec2665..de432ffcba50 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -13,7 +13,7 @@ What you need to know
 =====================
 
 The reader of this document is required to have some knowledge in the
-area of digital video broadcasting (DVB) and should be familiar with
+area of digital video broadcasting (Digital TV) and should be familiar with
 part I of the MPEG2 specification ISO/IEC 13818 (aka ITU-T H.222), i.e
 you should know what a program/transport stream (PS/TS) is and what is
 meant by a packetized elementary stream (PES) or an I-frame.
@@ -59,14 +59,14 @@ Overview
     :alt:   dvbstb.svg
     :align: center
 
-    Components of a DVB card/STB
+    Components of a Digital TV card/STB
 
-A DVB PCI card or DVB set-top-box (STB) usually consists of the
+A Digital TV card or set-top-box (STB) usually consists of the
 following main hardware components:
 
--  Frontend consisting of tuner and DVB demodulator
+-  Frontend consisting of tuner and digital TV demodulator
 
-   Here the raw signal reaches the DVB hardware from a satellite dish or
+   Here the raw signal reaches the digital TV hardware from a satellite dish or
    antenna or directly from cable. The frontend down-converts and
    demodulates this signal into an MPEG transport stream (TS). In case
    of a satellite frontend, this includes a facility for satellite
@@ -105,10 +105,10 @@ conditional access hardware.
 
 .. _dvb_devices:
 
-Linux DVB Devices
-=================
+Linux Digital TV Devices
+========================
 
-The Linux DVB API lets you control these hardware components through
+The Linux Digital TV API lets you control these hardware components through
 currently six Unix-style character devices for video, audio, frontend,
 demux, CA and IP-over-DVB networking. The video and audio devices
 control the MPEG2 decoder hardware, the frontend device the tuner and
@@ -137,8 +137,8 @@ individual devices are called:
 
 -  ``/dev/dvb/adapterN/caM``,
 
-where ``N`` enumerates the DVB PCI cards in a system starting from 0, and ``M``
-enumerates the devices of each type within each adapter, starting
+where ``N`` enumerates the Digital TV cards in a system starting from 0, and
+``M`` enumerates the devices of each type within each adapter, starting
 from 0, too. We will omit the “``/dev/dvb/adapterN/``\ ” in the further
 discussion of these devices.
 
@@ -151,8 +151,8 @@ devices are described in the following chapters.
 API include files
 =================
 
-For each of the DVB devices a corresponding include file exists. The DVB
-API include files should be included in application sources with a
+For each of the Digital TV devices a corresponding include file exists. The
+Digital TV API include files should be included in application sources with a
 partial path like:
 
 
-- 
2.13.5
