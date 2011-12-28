Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56676 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1L1OBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 09:01:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 0/4] Add some new camera controls
Date: Wed, 28 Dec 2011 15:01:23 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112281501.25091.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
> Hi everyone,
> 
> This RFC patch series include new 4 controls ID for digital camera.
> I about to suggest these controls by the necessity enabling the M-5MOLS
> sensor's function, and I hope to discuss this in here.

Thanks for the patches.

The new controls introduced by these patches are very high level. Should they 
be put in their own class ? I also think we should specify how those high-
level controls interact with low-level controls, otherwise applications will 
likely get very confused.

> Any opinions and thoughts are very welcome!
> 
> It's good to connect Sylwester's suggestion for discussing.
> - http://www.mail-archive.com/linux-media@vger.kernel.org/msg39907.html
> 
> But it's no problem even if it is considered as seperated subject.
> 
> 1. White Balance Peset
> ======================
> 
> Some camera hardware provides its own preset of white balance,
> but fortunately the names of these presets are similar with the others.
> So, I thought it can be provided as a generic digital camera API.
> I suggest the following as items:
> 
> enum v4l2_preset_white_balance {
> 	V4L2_WHITE_BALANCE_INCANDESCENT = 0,
> 	V4L2_WHITE_BALANCE_FLUORESCENT = 1,
> 	V4L2_WHITE_BALANCE_DAYLIGHT = 2,
> 	V4L2_WHITE_BALANCE_CLOUDY = 3,
> 	V4L2_WHITE_BALANCE_SHADE = 4,
> };
> 
> 2. Scenemode
> ============
> 
> I had suggested it before. :
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg29917.html
> 
> And I want to continue this subject on this threads.
> 
> The scenemode is also needed in the mobile digital .
> The reason I about to suggest this function as CID,
> is also the items are used widely & generally.
> 
> enum v4l2_scenemode {
> 	V4L2_SCENEMODE_NONE = 0,
> 	V4L2_SCENEMODE_NORMAL = 1,
> 	V4L2_SCENEMODE_PORTRAIT = 2,
> 	V4L2_SCENEMODE_LANDSCAPE = 3,
> 	V4L2_SCENEMODE_SPORTS = 4,
> 	V4L2_SCENEMODE_PARTY_INDOOR = 5,
> 	V4L2_SCENEMODE_BEACH_SNOW = 6,
> 	V4L2_SCENEMODE_SUNSET = 7,
> 	V4L2_SCENEMODE_DAWN_DUSK = 8,
> 	V4L2_SCENEMODE_FALL = 9,
> 	V4L2_SCENEMODE_NIGHT = 10,
> 	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
> 	V4L2_SCENEMODE_FIRE = 12,
> 	V4L2_SCENEMODE_TEXT = 13,
> 	V4L2_SCENEMODE_CANDLE = 14,
> };
> 
> 3. WDR(Wide Dynamic Range)
> ==========================
> 
> This function can be unfamiliar, but it is as known as HDR(High Dynamic
> Range) to iPhone users. Although the name is different, but both are the
> same function.
> 
> It makes the image look more clear by adjusting the intensity area of
> illumination of the image. This function can be used only turn on/off
> like button control, then the actual WDR algorithm are activated in the
> hardware.
> 
> 4. Antishake
> ============
> 
> This function compensate and stabilize the shakeness of the stream and
> image. So, if this function turned on, the image created without many
> shakeness. It means both, the case when compensating the stream's
> shakeness,
> and when stabilizing the image itself.
> 
> 5. References
> =============
> 
> - This is the example of the various digital camera's upper controls.
> You can find that the term of each control is very similiar.
> 
> @ White Balance Preset
> http://imaging.nikon.com/history/basics/17/index.htm
> http://www.dailyphotographytips.net/camera-controls-and-settings/how-to-set
> -custom-white-balance/
> http://www.digitalcamera-hq.com/articles/how-to-white-balance-your-camera
> http://www.digital-photography-school.com/introduction-to-white-balance
> 
> @ Scenemode
> http://www.digital-photography-school.com/digital-camera-modes
> http://www.picturecorrect.com/tips/digital-camera-scene-modes/
> 
> @ WDR and HDR
> http://en.wikipedia.org/wiki/High_dynamic_range_imaging
> http://en.wikipedia.org/wiki/Wide_dynamic_range
> 
> @ Ahtishake
> http://www.digital-slr-guide.com/digital-slr-anti-shake.html

-- 
Regards,

Laurent Pinchart
