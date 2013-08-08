Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:3929 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3HHMbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:31:42 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcjW014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:38 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/9] qv4l2: scaling, pixel aspect ratio and render fixes
Date: Thu,  8 Aug 2013 14:31:18 +0200
Message-Id: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PATCHv2 only rebases for master pull.

This adds scaling and aspect ratio support to the qv4l2 CaptureWin.
In that regard it fixes a lot of other issues that would otherwise make scaling
render incorrectly. It also fixes some issues with the original OpenGL patch series,
as well as adding tweaks and improvements left out in the original patches.


Some of the changes/improvements:
- CaptureWin have scaling support for video frames for all renderers
- CaptureWin support pixel aspect ratio scaling
- Aspect ratio and scaling can be changed during capture
- Reset and disable scaling options
- CaptureWin's setMinimumSize is now resize, which resizes the window to the frame size given
  and minimum size is set automatically
- The YUY2 shader programs are rewritten and has the resizing issue fixed
- The Show Frames option in Capture menu can be toggled during capture
- Added a hotkey:
    CTRL + F : (size to video 'F'rame)
               When either the main window or capture window is selected
               this will reset the scaling to fit the frame size.
               This option is also available in the Capture menu.

Pixel Aspect Ratio Modes:
- Autodetect (if not supported this assumes square pixels)
- Square
- NTSC/PAL-M/PAL-60
- NTSC/PAL-M/PAL-60, Anamorphic
- PAL/SECAM
- PAL/SECAM, Anamorphic

Perfomance:
  All tests are done using the 3.10 kernel with OpenGL enabled and desktop effects disabled.
  Testing was done on an Intel i7-2600S (with Turbo Boost disabled)
  using the integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
  with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
  inputs connected using PCIe2.0x8. All video input streams used for testing are
  progressive HD (1920x1080) with 60fps.

  FPS for every input for a given number of streams
  (BGR3, YU12 and YV12 are emulated using the CPU):
        1 STREAM  2 STREAMS  3 STREAMS  4 STREAMS
  RGB3      60        60         60         60
  BGR3      60        60         60         58
  YUYV      60        60         60         60
  YU12      60        60         60         60
  YV12      60        60         60         60

