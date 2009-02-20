Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:55338 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZBTVwj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 16:52:39 -0500
Date: Fri, 20 Feb 2009 13:52:35 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Questions about VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP
In-Reply-To: <20090220120400.3d797cc4@free.fr>
Message-ID: <Pine.LNX.4.58.0902201335020.24268@shell2.speakeasy.net>
References: <14759.62.70.2.252.1235052151.squirrel@webmail.xs4all.nl>
 <200902200929.36974.hverkuil@xs4all.nl> <20090220120400.3d797cc4@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Feb 2009, Jean-Francois Moine wrote:
> So, I propose to remove these ioctls, and to add two controls: one to
> set the JPEG quality (range 15..95 %) and the other to set a webcam
> quality which might be a boolean or any value depending on some
> associated webcam parameter.

A control can have any min, max and step size the driver wants to give it.
So their could easily be a "quality" control that's 15 to 95 on one driver
and 0 to 1 on another.

For zoran, I wonder if it would a good idea to support the existing
V4L2_CID_MPEG_VIDEO_BITRATE_MODE and V4L2_CID_MPEG_VIDEO_BITRATE controls.
Yeah, zoran is MJPEG and not MPEG, but what does one letter in the control
name matter?  IIRC, the zr36060 chip supports both VBR and CBR.  The
hardware is programmed with a bit rate in CBR mode.  The "quality" setting
is just an artificial construct created by the driver for user convenience.

A generic "quality" control would still be useful for hardware that doesn't
support bitrate setting and just as some nebulous quality setting.
