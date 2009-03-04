Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4468 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZCDOw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 09:52:27 -0500
Message-ID: <63862.62.70.2.252.1236178340.squirrel@webmail.xs4all.nl>
Date: Wed, 4 Mar 2009 15:52:20 +0100 (CET)
Subject: Re: identifying camera sensor
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tuukka,

> Hi,
>
> I am writing a generic driver for SMIA-compatible sensors.
> SMIA-sensors have registers containing:
>   u16 model_id
>   u16 revision_number
>   u8 manufacturer_id
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
>   #define V4L2_IDENT_SMIA_BASE	(0x53 << 24)
> then in sensor driver's VIDIOC_DBG_G_CHIP_IDENT ioctl handler:
>   struct v4l2_dbg_chip_ident id;
>   id.ident = V4L2_IDENT_SMIA_BASE | (manufacturer_id << 16) | model_id;
>   id.revision = revision_number;
>
> Do you think this is acceptable?

This ioctl is meant for debugging only. It's API can change without notice
(hence the 'DBG' part in the name and the warnings in the v4l2 spec). In
fact, it did change recently.

The only application using it is v4l2-dbg, which is a tool that allows you
to read and write registers on the fly. Very useful for debugging.

It is also used internally in the kernel if the adapter driver needs to do
different things depending on the actual chip used.

So it is *not* acceptable to use this API in a generic application (i.e.
an app that can be used for all sorts of different hardware). However, on
an embedded system where you control the environment I have no objection
if someone uses it in a custom application. They should be aware though
that this API can change in a future kernel. But since they control the
kernel version as well that shouldn't pose a problem.

> Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
> Would it make more sense if it would return something like
>   capability.card:  `omap3/smia-sensor-12-1234-5678//'
> where 12 would be manufacturer_id, 1234 model_id, and
> 5678 revision_number?

Yuck :-)

> I'll start writing a patch as soon as you let me know
> which would be the best alternative. Thanks!

G_CHIP_IDENT is probably the way to go, provided you are aware of the
limitations of this ioctl. Should this be a problem, then we need to think
of a better solution.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

