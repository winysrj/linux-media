Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:30482 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3GPLeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 07:34:05 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com
Subject: [PATCH 0/4] OpenGL render for qv4l2
Date: Tue, 16 Jul 2013 13:24:04 +0200
Message-Id: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

qv4l2:

The qv4l2 test utility now supports OpenGL-accelerated display of video.
This allows for using the graphics card to render the video content to screen
and to performing color space conversion.

The OpenGL implementation requires the QtOpenGL library as well as an OpenGL driver.
If OpenGL support is not present, then the program will fall back to using the CPU to display.

Some of the changes/improvements:
- Moved the ctrlEvent() function in qv4l2.cpp to be grouped with GUI function
  and to group capFrame() and capVbiFrame() together.
- OpenGL acceleration for supported systems.
- Option to change between GPU or CPU based rendering.
- CaptureWin's setMinimumSize() sets the minimum size for the video frame viewport
  and not for the window itself. If the minimum size is larger than the monitor resolution,
  it will reduce the minimum size to match this.
- Added a new menu option 'Preview' for controlling the CaptureWin's behavior.
- Added a couple of hotkeys:
    CTRL + V : When main window is selected start capture.
               This gives an option other than the button to start recording,
               as this is a frequent operation when using the utility.
    CTRL + W : When CaptureWin is selected close capture window.
               It makes it easier to deal with high resolutions video on
               small screen, especially when the window close button may
               be outside the monitor when repositioning the window.

Known issues:
- Repositioning, scaling or switching windows while the capture is recording will reduce the framerate.
  This is a limitation of Qt and not OpenGL.
- Using 4 streams of RGB3 1080p60 can at random times cease to render correctly
  and reduce the framerate to half. A restart solves this though.
- OpenGL is limited to 60fps. Disabling V-sync might allow for faster framerates.
- Resizing or scaling is not supported, mainly because the YUY2 shader renders the image incorrectly
  when the canvas size is not equal to the frame size.

Supported formats for OpenGL render:
- Native supported and accelerated:
    V4L2_PIX_FMT_RGB32
    V4L2_PIX_FMT_BGR32
    V4L2_PIX_FMT_RGB24
    V4L2_PIX_FMT_BGR24
    V4L2_PIX_FMT_RGB565
    V4L2_PIX_FMT_RGB555

    V4L2_PIX_FMT_YUYV
    V4L2_PIX_FMT_YVYU
    V4L2_PIX_FMT_UYVY
    V4L2_PIX_FMT_VYUY
    V4L2_PIX_FMT_YVU420
    V4L2_PIX_FMT_YUV420

- All formats supported by V4L conversion library,
  but they will use the CPU to convert to RGB3 before being displayed with OpenGL.

Performance:
All tests are done on an Intel i7-2600S (with Turbo Boost disabled) using the
integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
inputs connected using PCIe2.0x8. All video input streams used for testing are
progressive HD (1920x1080) with 60fps.

FPS for every input for a given number of streams:
      1 STREAM  2 STREAMS  3 STREAMS  4 STREAMS
RGB3      60        60         60         60
BGR3      60        60         60         50
YUYV      60        60         60         48
YU12      60        60         60         52
YV12      60        60         60         52

