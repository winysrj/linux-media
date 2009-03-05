Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:28999 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZCEAmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 19:42:37 -0500
Received: by wf-out-1314.google.com with SMTP id 28so4210731wfa.4
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 16:42:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200903041612.54557.tuukka.o.toivonen@nokia.com>
References: <200903041612.54557.tuukka.o.toivonen@nokia.com>
Date: Thu, 5 Mar 2009 09:42:35 +0900
Message-ID: <5e9665e10903041642t113c347fja3f140b921ecfc49@mail.gmail.com>
Subject: Re: identifying camera sensor
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi tuukka,

Chip identification could be used for many other camera devices. Not
only for SMIA compatible sensors.
It could be used for generic camera devices I guess for any other
reasons, like checking chip version on factory assembly line in mass
production.

Something like G_CHIP_IDENT (as Hans mentioned) should be cool.

Cheers,

Nate

On Wed, Mar 4, 2009 at 11:12 PM, Tuukka.O Toivonen
<tuukka.o.toivonen@nokia.com> wrote:
> Hi,
>
> I am writing a generic driver for SMIA-compatible sensors.
> SMIA-sensors have registers containing:
>  u16 model_id
>  u16 revision_number
>  u8 manufacturer_id
> which could be used to detect the sensor.
> However, since the driver is generic, it is not interested
> of these values.
>
> Nevertheless, in some cases user space applications want
> to know the exact chip. For example, to get the highest
> possible image quality, user space application might capture
> an image and postprocess it using sensor-specific filtering
> algorithms (which don't belong into kernel driver).
>
> I am planning to export the chip identification information
> to user space using VIDIOC_DBG_G_CHIP_IDENT.
> Here's a sketch:
>  #define V4L2_IDENT_SMIA_BASE  (0x53 << 24)
> then in sensor driver's VIDIOC_DBG_G_CHIP_IDENT ioctl handler:
>  struct v4l2_dbg_chip_ident id;
>  id.ident = V4L2_IDENT_SMIA_BASE | (manufacturer_id << 16) | model_id;
>  id.revision = revision_number;
>
> Do you think this is acceptable?
>
> Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
> Would it make more sense if it would return something like
>  capability.card:  `omap3/smia-sensor-12-1234-5678//'
> where 12 would be manufacturer_id, 1234 model_id, and
> 5678 revision_number?
>
> I'll start writing a patch as soon as you let me know
> which would be the best alternative. Thanks!
>
> - Tuukka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
