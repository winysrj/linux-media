Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJNnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 08:43:52 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MET00HZIHXBAA70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Dec 2012 13:46:27 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MET00JXCI4V1O40@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Dec 2012 13:43:50 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/2] V4L: Add auto focus area control and selection
Date: Mon, 10 Dec 2012 14:43:37 +0100
Message-id: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set of patches is created by Sylwester Nawrocki, with small changes by me.

This set of patches extends the camera class with control
V4L2_CID_AUTO_FOCUS_AREA for determining the area of the frame that
camera uses for auto-focus.
The control takes care of three cases:
- V4L2_AUTO_FOCUS_AREA_ALL, normal auto-focus, 
	whole frame is used for auto-focus,
- V4L2_AUTO_FOCUS_AREA_RECTANGLE, user provides rectangle or spot
	as an area of interest,
- V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION, object/face detection engine
	of the camera should be used for auto-focus.

In case of the rectangle or the spot its coordinates shall be passed
to the driver using selection API (VIDIOC_SUBDEV_S_SELECTION) with
V4L2_SEL_TGT_AUTO_FOCUS as a target name. In case of spot width and
height of the rectangle shall be set to 0.

We (me and Sylwester) are not sure if this is the best solution.

I would like to propose another solution which seems to me more natural,
but probably it would require extending controls API.
The solution is neither formalized, neither implemented at the moment.

The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
ioctls can be called with multiple controls per call.
There could be added four pseudo-controls, lets call them for short:
LEFT, TOP, WIDTH, HEIGHT.
Those controls could be passed together with V4L2_AUTO_FOCUS_AREA_RECTANGLE
control in one ioctl as a kind of control parameters.

For example setting auto-focus spot would require calling VIDIOC_S_EXT_CTRLS
with the following controls:
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
- LEFT = ...
- RIGHT = ...

Setting AF rectangle:
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
- LEFT = ...
- TOP = ...
- WIDTH = ...
- HEIGHT = ...

Setting  AF object detection:
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION

I have presented all three cases to show the advantages of this solution:
- atomicity - control and its parameters are passed in one call,
- flexibility - we are not limited by a fixed number of parameters,
- no-redundancy(?) - we can pass only required parameters
	(no need to pass null width and height in case of spot selection),
- extensibility - it is possible to extend parameters in the future,
for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
- backward compatibility, 
- re-usability - this schema could be used in other controls,
	pseudo-controls could be re-used in other controls as well.

I hope this e-mail will trigger some discussion about the proposed solution.

Regards
Andrzej Hajda

