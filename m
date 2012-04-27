Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:35444 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab2D0HwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 03:52:16 -0400
Date: Fri, 27 Apr 2012 09:53:09 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org,
	Erik =?UTF-8?B?QW5kcsOpbg==?= <erik.andren@gmail.com>
Subject: Re: gspca V4L2_CID_EXPOSURE_AUTO and VIDIOC_G/S/TRY_EXT_CTRLS
Message-ID: <20120427095309.5d922000@tele>
In-Reply-To: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Apr 2012 15:37:20 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> I noticed that AEC (Automatic Exposure Control, or
> V4L2_CID_EXPOSURE_AUTO) does not work in the ov534 gspca driver, either
> from guvcview or qv4l2.
	[snip]
> So in ov534, but I think in m5602 too, V4L2_CID_EXPOSURE_AUTO does not
> work from guvcview, qv4l2, or v4l2-ctrl, for instance the latter fails
> with the message:
> 
> 	error 25 getting ext_ctrl Auto Exposure
> 
> I tried adding an hackish implementation of vidioc_g_ext_ctrls and
> vidioc_s_ext_ctrls to gspca, and with these V4L2_CID_EXPOSURE_AUTO seems
> to work, but I need to learn more about this kind of controls before
> I can propose a decent implementation for mainline inclusion myself, so
> if anyone wants to anticipate me I'd be glad to test :)
> 
> Unrelated, but maybe worth mentioning is that V4L2_CID_EXPOSURE_AUTO is
> of type MENU, while some drivers are treating it as a boolean, I think
> I can fix this one if needed.

Hi Antonio,

Yes, V4L2_CID_EXPOSURE_AUTO is of class V4L2_CTRL_CLASS_CAMERA, and, as
the associated menu shows, it is not suitable for webcams.

In the webcam world, the autoexposure is often the same as the
autogain: in the knee algorithm
(http://81.209.78.62:8080/docs/LowLightOptimization.html - also look at
gspca/sonixb.c), both exposure and gain are concerned. The cases where
a user wants only autoexposure (fixed gain) or autogain (fixed
exposure) are rare. If you want people to be able to do that, you
should add a new webcam control, V4L2_CID_AUTOEXPOSURE, and also add it
to each driver which implements the knee algorithm, and handle the three
cases, autogain only, autoexposure only and knee.

Then, looking about your implementation of vidioc_s_ext_ctrls, I found
it was a bit simple: setting many controls is atomic, i.e., if any
error occurs at some point, the previous controls should be reset to
their original values. Same about vidioc_g_ext_ctrls: the mutex must be
taken only once for the values do not change. You also do not check if
the controls are in a same control class. Anyway, are these ioctl's
needed?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
