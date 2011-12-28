Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:24442 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1L1GXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 01:23:51 -0500
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWW008RLHRJL5K0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Dec 2011 15:23:50 +0900 (KST)
Received: from riverful-ubuntu.165.213.246.161 ([165.213.219.119])
 by mmp1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LWW007D6HRPXC40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Dec 2011 15:23:50 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
Subject: [RFC PATCH 0/4] Add some new camera controls
Date: Wed, 28 Dec 2011 15:23:44 +0900
Message-id: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This RFC patch series include new 4 controls ID for digital camera.
I about to suggest these controls by the necessity enabling the M-5MOLS
sensor's function, and I hope to discuss this in here.

Any opinions and thoughts are very welcome!

It's good to connect Sylwester's suggestion for discussing.
- http://www.mail-archive.com/linux-media@vger.kernel.org/msg39907.html

But it's no problem even if it is considered as seperated subject.

1. White Balance Peset
======================

Some camera hardware provides its own preset of white balance,
but fortunately the names of these presets are similar with the others.
So, I thought it can be provided as a generic digital camera API.
I suggest the following as items:

enum v4l2_preset_white_balance {
	V4L2_WHITE_BALANCE_INCANDESCENT = 0,
	V4L2_WHITE_BALANCE_FLUORESCENT = 1,
	V4L2_WHITE_BALANCE_DAYLIGHT = 2,
	V4L2_WHITE_BALANCE_CLOUDY = 3,
	V4L2_WHITE_BALANCE_SHADE = 4,
};

2. Scenemode
============

I had suggested it before. :
http://www.mail-archive.com/linux-media@vger.kernel.org/msg29917.html

And I want to continue this subject on this threads.

The scenemode is also needed in the mobile digital .
The reason I about to suggest this function as CID,
is also the items are used widely & generally.

enum v4l2_scenemode {
	V4L2_SCENEMODE_NONE = 0,
	V4L2_SCENEMODE_NORMAL = 1,
	V4L2_SCENEMODE_PORTRAIT = 2,
	V4L2_SCENEMODE_LANDSCAPE = 3,
	V4L2_SCENEMODE_SPORTS = 4,
	V4L2_SCENEMODE_PARTY_INDOOR = 5,
	V4L2_SCENEMODE_BEACH_SNOW = 6,
	V4L2_SCENEMODE_SUNSET = 7,
	V4L2_SCENEMODE_DAWN_DUSK = 8,
	V4L2_SCENEMODE_FALL = 9,
	V4L2_SCENEMODE_NIGHT = 10,
	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
	V4L2_SCENEMODE_FIRE = 12,
	V4L2_SCENEMODE_TEXT = 13,
	V4L2_SCENEMODE_CANDLE = 14,
};

3. WDR(Wide Dynamic Range)
==========================

This function can be unfamiliar, but it is as known as HDR(High Dynamic Range)
to iPhone users. Although the name is different, but both are the same function.

It makes the image look more clear by adjusting the intensity area of
illumination of the image. This function can be used only turn on/off
like button control, then the actual WDR algorithm are activated in the hardware.

4. Antishake
============

This function compensate and stabilize the shakeness of the stream and image.
So, if this function turned on, the image created without many shakeness.
It means both, the case when compensating the stream's shakeness,
and when stabilizing the image itself.

5. References
=============

- This is the example of the various digital camera's upper controls.
You can find that the term of each control is very similiar.

@ White Balance Preset
http://imaging.nikon.com/history/basics/17/index.htm
http://www.dailyphotographytips.net/camera-controls-and-settings/how-to-set-custom-white-balance/
http://www.digitalcamera-hq.com/articles/how-to-white-balance-your-camera
http://www.digital-photography-school.com/introduction-to-white-balance

@ Scenemode
http://www.digital-photography-school.com/digital-camera-modes
http://www.picturecorrect.com/tips/digital-camera-scene-modes/

@ WDR and HDR
http://en.wikipedia.org/wiki/High_dynamic_range_imaging
http://en.wikipedia.org/wiki/Wide_dynamic_range

@ Ahtishake
http://www.digital-slr-guide.com/digital-slr-anti-shake.html


