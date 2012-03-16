Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49941 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2CPTkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 15:40:04 -0400
Date: Fri, 16 Mar 2012 20:40:05 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xavion <xavion.0@gmail.com>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam succumbs to glare in Linux
Message-ID: <20120316204005.58f64d41@tele>
In-Reply-To: <CAKnx8Y6Qa-9CTNoH3MfbH3TdypswL1avZdcN3Wy_qW1xK6o6ag@mail.gmail.com>
References: <CAKnx8Y5_amjNv7YjTGUqBoSYU99tGYJLw0G63ha8TZDq3n7Sgw@mail.gmail.com>
	<CAKnx8Y6Qa-9CTNoH3MfbH3TdypswL1avZdcN3Wy_qW1xK6o6ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Mar 2012 08:53:51 +1100
Xavion <xavion.0@gmail.com> wrote:

> As you can probably gather from the attached screenshots, I'm
> attempting to use my SN9C201 webcam for home security.  The problem is
> that it succumbs to external glare during the middle hours of sunny
> days when used in Linux.
> 
> The same problem doesn't occur in Windows, probably since the software
> automatically adjusts to the current lighting conditions.  These
> screenshots were taken only five minutes apart and the sunlight
> intensity didn't change much in-between.
> 
> No amount of adjusting the webcam's settings (via V4L2-UCP) seemed to
> make any significant difference.  For this reason, I'm guessing that
> there's at least one other adjustable setting that the GSPCA driver
> isn't tapping into yet.
	[snip]

Hi Xavion,

It seems that the exposure is not set correctly. May you try the patch
below? (to be applied to the gspca test version 2.15.7 - the exposure
may be too low at init time, set it to 800)

--- build/sn9c20x.c~
+++ build/sn9c20x.c
@@ -1650,10 +1650,9 @@
 	case SENSOR_OV7670:
 	case SENSOR_OV9655:
 	case SENSOR_OV9650:
-		exp[0] |= (3 << 4);
-		exp[2] = 0x2d;
-		exp[3] = expo;
-		exp[4] = expo >> 8;
+		exp[0] |= (2 << 4);
+		exp[2] = 0x10;			/* AECH */
+		exp[3] = expo * 255 / 0x1780;
 		break;
 	case SENSOR_MT9M001:
 	case SENSOR_MT9V112:

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
