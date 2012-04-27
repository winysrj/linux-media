Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1734 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2D0MRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 08:17:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: gspca V4L2_CID_EXPOSURE_AUTO and VIDIOC_G/S/TRY_EXT_CTRLS
Date: Fri, 27 Apr 2012 14:14:48 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org,
	Erik =?iso-8859-15?q?Andr=E9n?= <erik.andren@gmail.com>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it> <20120427095309.5d922000@tele> <20120427140416.79cfd85f36f3f793816fe4d2@studenti.unina.it>
In-Reply-To: <20120427140416.79cfd85f36f3f793816fe4d2@studenti.unina.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271414.48967.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, April 27, 2012 14:04:16 Antonio Ospite wrote:
> On Fri, 27 Apr 2012 09:53:09 +0200
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
> > On Wed, 18 Apr 2012 15:37:20 +0200
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> > 
> > > I noticed that AEC (Automatic Exposure Control, or
> > > V4L2_CID_EXPOSURE_AUTO) does not work in the ov534 gspca driver, either
> > > from guvcview or qv4l2.
> > 	[snip]
> > > So in ov534, but I think in m5602 too, V4L2_CID_EXPOSURE_AUTO does not
> > > work from guvcview, qv4l2, or v4l2-ctrl, for instance the latter fails
> > > with the message:
> > > 
> > > 	error 25 getting ext_ctrl Auto Exposure
> > > 
> > > I tried adding an hackish implementation of vidioc_g_ext_ctrls and
> > > vidioc_s_ext_ctrls to gspca, and with these V4L2_CID_EXPOSURE_AUTO seems
> > > to work, but I need to learn more about this kind of controls before
> > > I can propose a decent implementation for mainline inclusion myself, so
> > > if anyone wants to anticipate me I'd be glad to test :)
> > > 
> > > Unrelated, but maybe worth mentioning is that V4L2_CID_EXPOSURE_AUTO is
> > > of type MENU, while some drivers are treating it as a boolean, I think
> > > I can fix this one if needed.
> > 
> > Hi Antonio,
> > 
> > Yes, V4L2_CID_EXPOSURE_AUTO is of class V4L2_CTRL_CLASS_CAMERA, and, as
> > the associated menu shows, it is not suitable for webcams.
> >
> 
> Where is that menu you refer to? Maybe camera_exposure_auto in
> drivers/media/video/v4l2-ctrls.c which mentions also "Shutter Priority
> Mode" and "Aperture Priority Mode"?
> 
> Naively one would expect that a web _camera_ could use some controls of
> type V4L2_CTRL_CLASS_CAMERA.
> 
> > In the webcam world, the autoexposure is often the same as the
> > autogain: in the knee algorithm
> > (http://81.209.78.62:8080/docs/LowLightOptimization.html - also look at
> > gspca/sonixb.c), both exposure and gain are concerned.
> 
> From the document you point at I still understand that from a user point
> of view autoexposure and autogain are _independent_ parameters (Table
> 1), it's just that for such algorithm to work well they should be _both_
> enabled.
> 
> > The cases where
> > a user wants only autoexposure (fixed gain) or autogain (fixed
> > exposure) are rare.
> >
> > If you want people to be able to do that, you
> > should add a new webcam control, V4L2_CID_AUTOEXPOSURE, and also add it
> > to each driver which implements the knee algorithm, and handle the three
> > cases, autogain only, autoexposure only and knee.
> 
> The real problem here is that _manual_ exposure does not work in ov534
> because the user cannot turn off what we are currently calling auto
> exposure.
> 
> > Then, looking about your implementation of vidioc_s_ext_ctrls, I found
> > it was a bit simple: setting many controls is atomic, i.e., if any
> > error occurs at some point, the previous controls should be reset to
> > their original values. Same about vidioc_g_ext_ctrls: the mutex must be
> > taken only once for the values do not change. You also do not check if
> > the controls are in a same control class.
> 
> I see, it was my first shot and I just wanted to start the discussion
> with a "works here" implementation. I think that using some v4l2
> infrastructure like the control-framework like Hans proposes could be
> better in the long run. IIUC this could also prevent drivers having to
> handle menu entries themselves like we are doing now in sd_querymenu(),
> right?

Correct.

> If you two reach an agreement and he gets to do it I'll surely port
> over drivers using V4L2_CID_EXPOSURE_AUTO.
> 
> > Anyway, are these ioctl's needed?
> > 
> 
> Whether they are really needed or not, that depends on the definition of
> webcam, the definition of "camera" in V4L2, and the relationship
> between the two.
> 
> If a webcam IS-A v4l2 camera, then I'd expect it to be able to use
> V4L2_CTRL_CLASS_CAMERA controls, and then EXT controls should be made
> accessible by gspca somehow.

The UVC driver definitely uses the camera class controls. So they are really
meant for webcam use :-)

Note that for technical reasons the UVC driver is the only driver that will
not use the control framework (partially due to design of the datastructures
and partially due to the complex control handling/mapping and the support of
dynamic controls in UVC).

Perhaps in the future we might try to get it into UVC anyway, but not before
all other drivers have been converted.

Regards,

	Hans

> 
> Thanks,
>    Antonio
> 
> 
