Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57341 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1L2GPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 01:15:47 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWY0059PC0TYGB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Dec 2011 15:15:46 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LWY00GPOC2AUXB0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Thu, 29 Dec 2011 15:15:46 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <201112281501.25091.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112281501.25091.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 0/4] Add some new camera controls
Date: Thu, 29 Dec 2011 15:15:46 +0900
Message-id: <001601ccc5f1$4db353d0$e919fb70$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Larent,

Thanks for the comments very well, and I replied the other each mails.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, December 28, 2011 11:01 PM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 0/4] Add some new camera controls
> 
> Hi,
> 
> On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
> > Hi everyone,
> >
> > This RFC patch series include new 4 controls ID for digital camera.
> > I about to suggest these controls by the necessity enabling the M-5MOLS
> > sensor's function, and I hope to discuss this in here.
> 
> Thanks for the patches.
> 
> The new controls introduced by these patches are very high level. Should they
> be put in their own class ? I also think we should specify how those high-
> level controls interact with low-level controls, otherwise applications will
> likely get very confused.
I did not consider yet, but I think it's first to define about what low-/high-
is. I think this is not high- level controls. And, honestly, I don't understand
it's really important to categorize low-/high-, or not.

IMHO, The importance is the just complexity of interacting with each modules.
If this means the level of low-/high-, I can understand this.
But I'm wrong, please explain this. :)

There is some different story, I just got the N900 some days ago :).
The purpose is just understanding Nokia and TI OMAP camera architecture well.
Probably, it helps for me to talk more easily, and I'll be able to speak more
well
with omap workers - you and Sakari.

Happy new year!

> 
> > Any opinions and thoughts are very welcome!
> >
> > It's good to connect Sylwester's suggestion for discussing.
> > - http://www.mail-archive.com/linux-media@vger.kernel.org/msg39907.html
> >
> > But it's no problem even if it is considered as seperated subject.
> >
> > 1. White Balance Peset
> > ======================
> >
> > Some camera hardware provides its own preset of white balance,
> > but fortunately the names of these presets are similar with the others.
> > So, I thought it can be provided as a generic digital camera API.
> > I suggest the following as items:
> >
> > enum v4l2_preset_white_balance {
> > 	V4L2_WHITE_BALANCE_INCANDESCENT = 0,
> > 	V4L2_WHITE_BALANCE_FLUORESCENT = 1,
> > 	V4L2_WHITE_BALANCE_DAYLIGHT = 2,
> > 	V4L2_WHITE_BALANCE_CLOUDY = 3,
> > 	V4L2_WHITE_BALANCE_SHADE = 4,
> > };
> >
> > 2. Scenemode
> > ============
> >
> > I had suggested it before. :
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg29917.html
> >
> > And I want to continue this subject on this threads.
> >
> > The scenemode is also needed in the mobile digital .
> > The reason I about to suggest this function as CID,
> > is also the items are used widely & generally.
> >
> > enum v4l2_scenemode {
> > 	V4L2_SCENEMODE_NONE = 0,
> > 	V4L2_SCENEMODE_NORMAL = 1,
> > 	V4L2_SCENEMODE_PORTRAIT = 2,
> > 	V4L2_SCENEMODE_LANDSCAPE = 3,
> > 	V4L2_SCENEMODE_SPORTS = 4,
> > 	V4L2_SCENEMODE_PARTY_INDOOR = 5,
> > 	V4L2_SCENEMODE_BEACH_SNOW = 6,
> > 	V4L2_SCENEMODE_SUNSET = 7,
> > 	V4L2_SCENEMODE_DAWN_DUSK = 8,
> > 	V4L2_SCENEMODE_FALL = 9,
> > 	V4L2_SCENEMODE_NIGHT = 10,
> > 	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
> > 	V4L2_SCENEMODE_FIRE = 12,
> > 	V4L2_SCENEMODE_TEXT = 13,
> > 	V4L2_SCENEMODE_CANDLE = 14,
> > };
> >
> > 3. WDR(Wide Dynamic Range)
> > ==========================
> >
> > This function can be unfamiliar, but it is as known as HDR(High Dynamic
> > Range) to iPhone users. Although the name is different, but both are the
> > same function.
> >
> > It makes the image look more clear by adjusting the intensity area of
> > illumination of the image. This function can be used only turn on/off
> > like button control, then the actual WDR algorithm are activated in the
> > hardware.
> >
> > 4. Antishake
> > ============
> >
> > This function compensate and stabilize the shakeness of the stream and
> > image. So, if this function turned on, the image created without many
> > shakeness. It means both, the case when compensating the stream's
> > shakeness,
> > and when stabilizing the image itself.
> >
> > 5. References
> > =============
> >
> > - This is the example of the various digital camera's upper controls.
> > You can find that the term of each control is very similiar.
> >
> > @ White Balance Preset
> > http://imaging.nikon.com/history/basics/17/index.htm
> > http://www.dailyphotographytips.net/camera-controls-and-settings/how-to-set
> > -custom-white-balance/
> > http://www.digitalcamera-hq.com/articles/how-to-white-balance-your-camera
> > http://www.digital-photography-school.com/introduction-to-white-balance
> >
> > @ Scenemode
> > http://www.digital-photography-school.com/digital-camera-modes
> > http://www.picturecorrect.com/tips/digital-camera-scene-modes/
> >
> > @ WDR and HDR
> > http://en.wikipedia.org/wiki/High_dynamic_range_imaging
> > http://en.wikipedia.org/wiki/Wide_dynamic_range
> >
> > @ Ahtishake
> > http://www.digital-slr-guide.com/digital-slr-anti-shake.html
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

