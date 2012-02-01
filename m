Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50676 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2BAKFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 05:05:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYP00JRWLCJ6X30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 10:05:07 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYP005GHLCICG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 10:05:07 +0000 (GMT)
Date: Wed, 01 Feb 2012 11:05:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [ANN] IRC meeting on camera controls
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Sylwester Nawrocki <snjw23@gmail.com>
Message-id: <4F290E52.5090503@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I would like to invite everyone interested to a short IRC meeting on 
#v4l-meeting channel we are going to have at 14:00 CET, this Friday 
2012-02-03. The main topics are camera exposure and auto focus control
API. There were previous discussions on the mailing list regarding this
and patches from HeungJun Kim and me [1], [2]. Most of the patches are 
now available at gitweb interface [4]. They incorporate comments from
the discussions and the documentation is improved slightly. Some controls
will depend on the new integer menu control type patches from Sakari [3].

There were suggestions to create a new class for the proposed controls
as they are relatively high level. However as we're going to also have
a low level "image source" control class there are doubts whether it's 
a good thing to do.

The proposed controls can be divided into following groups:

Exposure controls:

* V4L2_CID_METERING_MODE		- light metering mode for auto exposure
* V4L2_CID_EXPOSURE_BIAS		- auto exposure bias
* V4L2_CID_ISO				- manual ISO sensitivity
* V4L2_CID_ISO_AUTO			- enable disable automatic ISO adjustments
* V4L2_CID_ISO_PRESET			- sensitivity preset

White balance:

* V4L2_CID_WHITE_BALANCE_PRESET		- white balance preset

Auto focus controls:

* V4L2_CID_AUTO_FOCUS_START 		- one-shot auto focus start
* V4L2_CID_AUTO_FOCUS_STOP 		- one-shot auto focus stop
* V4L2_CID_AUTO_FOCUS_STATUS		- auto focus status
* V4L2_CID_AUTO_FOCUS_DISTANCE 		- auto focus scan range selection
* V4L2_CID_AUTO_FOCUS_AREA 		- auto focus area selection
* V4L2_CID_AUTO_FOCUS_X_POSITION 	- horizontal AF spot position
* V4L2_CID_AUTO_FOCUS_Y_POSITION 	- vertical AF spot position
* V4L2_CID_AUTO_FOCUS_FACE_PRIORITY 	- enable/disable face priority

Other:

* V4L2_CID_WIDE_DYNAMIC_RANGE		- enable/disable wide dynamic range
* V4L2_CID_IMAGE_STABILIZATION		- enable/disable image stabilization
* V4L2_CID_SCENEMODE			- scene preset, it's a bit questionable
					  due to influencing many other controls

A debatable topic is setting up the coordinates (spot and rectangles) for auto 
focus sensors, exposure and white balance. In some modes only spot needs to be 
specified (x, y) while some only need a rectangle, or multiple rectangles - 
however in practice I didn't have a need for them yet.

Some attributes have mixed series of values and presets, like for instance ISO:

ISO_AUTO
ISO_100
ISO_200
ISO_400
ISO_SPORTS
ISO_NIGHT
ISO_INDOOR

I would assume it's best to create 3 controls for such ones, e.g.

V4L2_CID_ISO_AUTO 
V4L2_CID_ISO
V4L2_CID_ISO_PRESET

Then devices that do not support ISO presets would only implement the first
two or just the second one for instance.

All comments are welcome.

[1] http://www.spinics.net/lists/linux-media/msg40970.html
[2] http://www.spinics.net/lists/linux-media/msg42152.html
[3] http://www.spinics.net/lists/linux-media/msg40796.html
[4] http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/camera-controls


Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
