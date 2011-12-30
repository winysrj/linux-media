Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45263 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1L3LSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 06:18:54 -0500
Received: by eekc4 with SMTP id c4so13507573eek.19
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 03:18:53 -0800 (PST)
Message-ID: <4EFD9E10.1050407@gmail.com>
Date: Fri, 30 Dec 2011 12:18:40 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 0/4] Add some new camera controls
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <201112281501.25091.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112281501.25091.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/28/2011 03:01 PM, Laurent Pinchart wrote:
> On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
>> This RFC patch series include new 4 controls ID for digital camera.
>> I about to suggest these controls by the necessity enabling the M-5MOLS
>> sensor's function, and I hope to discuss this in here.
> 
> Thanks for the patches.
> 
> The new controls introduced by these patches are very high level. Should they 
> be put in their own class ? I also think we should specify how those high-
> level controls interact with low-level controls, otherwise applications will 
> likely get very confused.

I agree we may need a separate control class for those high-level controls.
They are mostly applicable to software ISP algorithms, run either on digital
signal processor embedded in the sensor or on a processor being part of an SoC.

Thus we would three levels of controls for camera,
 1) image source class (lowest possible level), dealing mostly with hardware
    registers;
 2) "normal" camera controls (V4L2_CID_CAMERA_CLASS) [2];
 3) high level camera controls (for camera software algorithms)

plus some camera controls are in the user controls class. I'm not sure why there
are camera controls in the user control class, perhaps there was no camera
class yet at the time V4L2_CID_EXPOSURE or V4L2_CID_BACKLIGHT_COMPENSATION were
added. I might be missing something else.

I'm afraid a little it might be hard to distinguish if some control should
belong to 2) or 3), as sensors' logic complexity and advancement varies.

Although I can see an advantage of logically separating controls which have
influence on one or more other (lower level) controls. And separate control
class would be helpful in that.

The candidates to such control class might be:

* V4L2_CID_METERING_MODE,
* V4L2_CID_EXPOSURE_BIAS,
* V4L2_CID_ISO,
* V4L2_CID_WHITE_BALANCE_PRESET,
* V4L2_CID_SCENEMODE,
* V4L2_CID_WDR,
* V4L2_CID_ANTISHAKE,

[1] http://patchwork.linuxtv.org/patch/8923/
[2] http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#camera-controls

--

Regards,
Sylwester
