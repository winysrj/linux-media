Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46930
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752096AbdIANY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 06/27] media: dvb/intro: adjust the notices about optional hardware
Date: Fri,  1 Sep 2017 10:24:28 -0300
Message-Id: <1dcf27f4891893df94bcc7bc20f94b64ac368bc1.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both CA and decoders are optional. Also, the presence or
absence has nothing to do on being a PCI card or not.

Nowadays, most hardware leaves the decoders to either the
GPU or to some ISP inside the SoC, instead of implementing
it inside the Digital TV part of the device.

So, change the wording to reflect the hardware changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 4e1594816ef4..aeafc9ab96c1 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -71,8 +71,7 @@ Overview
 A Digital TV card or set-top-box (STB) usually consists of the
 following main hardware components:
 
--  Frontend consisting of tuner and digital TV demodulator
-
+Frontend consisting of tuner and digital TV demodulator
    Here the raw signal reaches the digital TV hardware from a satellite dish or
    antenna or directly from cable. The frontend down-converts and
    demodulates this signal into an MPEG transport stream (TS). In case
@@ -80,34 +79,40 @@ following main hardware components:
    equipment control (SEC), which allows control of LNB polarization,
    multi feed switches or dish rotors.
 
--  Conditional Access (CA) hardware like CI adapters and smartcard slots
-
+Conditional Access (CA) hardware like CI adapters and smartcard slots
    The complete TS is passed through the CA hardware. Programs to which
    the user has access (controlled by the smart card) are decoded in
    real time and re-inserted into the TS.
 
--  Demultiplexer which filters the incoming DVB stream
+   .. note::
 
+      Not every digital TV hardware provides conditional access hardware.
+
+Demultiplexer which filters the incoming DVB stream
    The demultiplexer splits the TS into its components like audio and
    video streams. Besides usually several of such audio and video
    streams it also contains data streams with information about the
    programs offered in this or other streams of the same provider.
 
--  MPEG2 audio and video decoder
-
+MPEG2 audio and video decoder
    The main targets of the demultiplexer are the MPEG2 audio and video
    decoders. After decoding they pass on the uncompressed audio and
    video to the computer screen or (through a PAL/NTSC encoder) to a TV
    set.
 
+   .. note::
+
+      Modern hardware usually doesn't have a separate decoder hardware, as
+      such functionality can be provided by the main CPU, by the graphics
+      adapter of the system or by a signal processing hardware embedded on
+      a Systems on a Chip (SoC) integrated circuit.
+
+      It may also not be needed for certain usages (e.g. for data-only
+      uses like “internet over satellite”).
+
 :ref:`stb_components` shows a crude schematic of the control and data
 flow between those components.
 
-On a DVB PCI card not all of these have to be present since some
-functionality can be provided by the main CPU of the PC (e.g. MPEG
-picture and sound decoding) or is not needed (e.g. for data-only uses
-like “internet over satellite”). Also not every card or STB provides
-conditional access hardware.
 
 
 .. _dvb_devices:
-- 
2.13.5
