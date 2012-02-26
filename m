Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50334 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2BZRK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 12:10:59 -0500
Received: by werb13 with SMTP id b13so2348495wer.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 09:10:57 -0800 (PST)
Message-ID: <4F4A679D.9060302@gmail.com>
Date: Sun, 26 Feb 2012 18:10:53 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC][DRAFT] V4L: Add camera auto focus controls
References: <1326749622-11446-1-git-send-email-sylvester.nawrocki@gmail.com> <4F4A6493.1080004@gmail.com>
In-Reply-To: <4F4A6493.1080004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2012 05:57 PM, Sylwester Nawrocki wrote:
> rather painful in use. After changing V4L2_CID_AUTO_FOCUS_SELECTION to
> 
> #define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+23)

Oops, of course each occurence of "SELECTION" below should be replaced with
"AREA". Sorry for the confusion.

> enum v4l2_auto_focus_selection {
> 	V4L2_AUTO_FOCUS_SELECTION_ALL		= 0,
> 	V4L2_AUTO_FOCUS_SELECTION_SPOT		= 1,
> 	V4L2_AUTO_FOCUS_SELECTION_RECTANGLE	= 2,
> };
> 
> I tried use them with the M-5MOLS sensor driver where there is only
> one register for setting following automatic focus modes:
> 
> NORMAL AUTO (single-shot),
> MACRO,
> INFINITY,
> SPOT,
> FACE_DETECTION
> 
> The issue is that when V4L2_CID_AUTO_FOCUS_AREA is set to for example
> V4L2_AUTO_FOCUS_SELECTION_SPOT, none of the menu entries of
> V4L2_CID_AUTO_FOCUS_DISTANCE is valid.
> 
> So it would really be better to use single control for automatic focus
> mode. A private control could handle that. But there will be more than
> one sensor driver needing such a control, so I thought about an
> additional header, e.g. samsung_camera.h in include/linux/ that would
> define reguired control IDs and menus in the camera class private id
> range.
> 
> What do you think about it ?
> 
> 
>> +#define V4L2_CID_AUTO_FOCUS_X_POSITION		(V4L2_CID_CAMERA_CLASS_BASE+24)
>> +#define V4L2_CID_AUTO_FOCUS_Y_POSITION		(V4L2_CID_CAMERA_CLASS_BASE+25)
> ...
> 
> --
> 
> Regards,
> Sylwester

