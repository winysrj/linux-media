Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZFQK6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 06:58:21 -0400
Message-ID: <4A38CCAF.5060202@redhat.com>
Date: Wed, 17 Jun 2009 12:59:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl> <20090617065621.23515ab7@pedra.chehab.org>
In-Reply-To: <20090617065621.23515ab7@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/17/2009 11:56 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 17 Jun 2009 09:43:50 +0200 (CEST)
> "Hans Verkuil"<hverkuil@xs4all.nl>  escreveu:
>
>>> I recently have been bying second hand usb webcams left and right
>>> one of them (a creative unknown model) uses the cpia1 chipset, and
>>> works with the v4l1 driver currently in the kernel.
>>>
>>> One of these days I would like to convert it to a v4l2 driver using
>>> gspca as basis, this however will cause us to use parallel port support
>>> (that or we need to keep the old code around for the parallel port
>>> version).
>>>
>>> I personally think that loosing support for the parallel port
>>> version is ok given that the parallel port itslef is rapidly
>>> disappearing, what do you think ?
>> I agree wholeheartedly. If we remove pp support, then we can also remove
>> the bw-qcam and c-qcam drivers since they too use the parallel port.
>
> Maybe I'm too nostalgic, but those are the first V4L drivers. It would be fun
> to keep supporting them with V4L2 API ;)
>
> That's said, while it is probably not that hard to develop a gspca-pp driver,
> I'm not against removing parallel port support or even removing those drivers
> due to technical reasons, like the end of V4L1 drivers.
>
> By looking at the remaining V4L1 drivers, we have:
>
> 	ov511 - already implemented with V4L2 on gspca. Can be easily removed;
>

Yip, this one is a done deal :)

> 	se401, stv680, usbvideo, vicam - USB V4L1 drivers. IMO, it is valuable
> 		to convert them to gspca;
>

I've recently bought a (second hand) stv680 cam, haven't seriously tested it yet,
so I dunno if it works with the v4l1 driver. I agree it would be good to convert these,
and I can work on this as time permits, but I won't be converting code I don't have
HW to test for.

As for usbvideo that supports (amongst others) the st6422 (from the out of tree
qc-usb-messenger driver), but only one usb-id ??. I'm currently finishing up adding
st6422 support to gspca (with all known usb-id's), I have 2 different cams to test this with.

And indeed as mentioned in another mail we should also convert the w9968cf.

> 	cpia2, pwc - supports both V4L1 and V4L2 API. It shouldn't be hard to convert them
> 		to vidio_ioctl2 and remove V4L1 API.
>

I have a pwc cam , so I can test changes for pwc. btw current pwc oopses rather badly (GPF)
when unplugging the cam, I'll dig into this.

> 	stradis - a saa7146 V4L1 only driver - I never understood this one well, since there is
> 		already another saa7146 driver running V4L2, used by mxb, hexium_gemini and
> 		hexium_orion. To make things worse, stradis, mxb and hexium_orion are registering for
> 		the same PCI device (the generic saa7146 PCI ID). If nobody volunteers to convert
> 		and test with V4L2, then maybe we can just remove it. The better conversion would
> 		probably be to use the V4L2 support at the saa7146 driver.
>
> 	arv - seems to be a VGA output driver - Only implements 3 ioctls:
> 		VIDIOCGCAP and VIDIOCGWIN/VIDIOCSWIN. It shouldn't be hard to convert it to V4L2.
> 		I'm not sure if this is still used in practice.
>
> 	bw-qcam, pms, c-qcam, cpia, w9966 - very old drivers that use direct io and/or parport;
>
> IMO, after having all USB ID's for se401, stv680, usbvideo and vicam devices supported
> by a V4L2 driver, we can just remove V4L1 ioctls from cpia2 and pwc, and the drivers that
> will still remain using only the legacy API can be dropped. Anything more converted will be a bonus
>

Big +1, having digged through many of these old drivers to convert them, they all seem rather crufty
and ugly and having them gone would be good.

While cleaning cruft, I would also like to see the following v4l2 drivers go away in time, they are all
from the same author (who mostly borrowed the reverse engineering work from the original out of tree
gspca) and he does not maintain them, and they all support cams also supported by the new gspca:

zc0301
only supports one usb-id which has not yet been tested with gspca, used to claim a lot more
usb-id's but didn't actually work with those as it only supported the bridge, not the sensor
-> remove it now ?

et61x251
Only supports using this bridge in combination with one type of sensor where as gspca
supports 2 type of sensors. gspca support is untested AFAIK.
-> ?

sn9c102
Supports a large number of cams also supported by gspca's sonixb / sonixj driver, we're using
#ifdef .... macros to detect if both are being build at the same time to include usb-id's only
in one of the 2.

As seems normal for drivers from this author the driver used to claim a lot of usb-id's it
couldn't actually work with as it only supported the bridge, not the sensor. We've removed all
those and are now slowly moving over the remaining usb-ids to gspca as things get tested
with gspca.
-> Keep on moving over usb-id's then when only a few are left, drop it

Regards,

Hans
