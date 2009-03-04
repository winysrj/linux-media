Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:36295 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZCDXAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 18:00:14 -0500
Date: Wed, 4 Mar 2009 15:00:12 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: ribrishimov <ribrishimov@mm-sol.com>
cc: "'Tuukka.O Toivonen'" <tuukka.o.toivonen@nokia.com>,
	camera@ok.research.nokia.com, linux-media@vger.kernel.org,
	'ext Hans Verkuil' <hverkuil@xs4all.nl>
Subject: RE: [Camera] identifying camera sensor
In-Reply-To: <011401c99cd7$9d20bd40$020014ac@ribrishimov>
Message-ID: <Pine.LNX.4.58.0903041452180.24268@shell2.speakeasy.net>
References: <200903041612.54557.tuukka.o.toivonen@nokia.com>
 <011401c99cd7$9d20bd40$020014ac@ribrishimov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Mar 2009, ribrishimov wrote:
> I am planning to export the chip identification information
> to user space using VIDIOC_DBG_G_CHIP_IDENT.
> Here's a sketch:
>   #define V4L2_IDENT_SMIA_BASE	(0x53 << 24)
> then in sensor driver's VIDIOC_DBG_G_CHIP_IDENT ioctl handler:
>   struct v4l2_dbg_chip_ident id;
>   id.ident = V4L2_IDENT_SMIA_BASE | (manufacturer_id << 16) | model_id;
>   id.revision = revision_number;
>
> Do you think this is acceptable?

This is only meant for debugging and shouldn't be used by normal
software.

> Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
> Would it make more sense if it would return something like
>   capability.card:  `omap3/smia-sensor-12-1234-5678//'
> where 12 would be manufacturer_id, 1234 model_id, and
> 5678 revision_number?

You could always try to decode the manufacturer name and maybe even the
model name.  After all, pretty much every other driver does this.
