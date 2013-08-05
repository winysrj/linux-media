Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23517 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3HEI5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:38 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7b001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:34 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/7] qv4l2: scaling and pixel aspect ratio
Date: Mon,  5 Aug 2013 10:56:50 +0200
Message-Id: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch series depends on the qv4l2 ALSA and OpenGL patch series.

This adds scaling and aspect ratio support to the qv4l2 CaptureWin.
It also fixes some issues with the original OpenGL patch series,
as well as adding tweaks and improvements left out in the original patches.

Some of the changes/improvements:
- CaptureWin have scaling support for video frames for all renderers
- CaptureWin support pixel aspect ratio scaling
- Aspect ratio and scaling can be changed during capture
- CaptureWin's setMinimumSize is now resize, which resizes the window to the frame size given
  and minimum size is set automatically
- The YUY2 shader programs are rewritten and has the resizing issue fixed
- The Show Frames option in Capture menu can be toggled during capture
- Reset and disable scaling options
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

