Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34872 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178AbcCIWo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 17:44:59 -0500
Received: by mail-ob0-f180.google.com with SMTP id fp4so62613642obb.2
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 14:44:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56DF852A.30702@mentor.com>
References: <20160223114943.GA10944@frolo.macqel>
	<20160223141258.GA5097@frolo.macqel>
	<4956050.OLrYA1VK2G@avalon>
	<56D79B49.50009@mentor.com>
	<56D7E59B.6050605@xs4all.nl>
	<20160303083643.GA4303@frolo.macqel>
	<56D87824.8000707@mentor.com>
	<CAJ+vNU2kPgESnjTZokU3qNR6QAbU3G8HGwc7ahg4jDpeS_xjHg@mail.gmail.com>
	<56DF852A.30702@mentor.com>
Date: Wed, 9 Mar 2016 14:44:58 -0800
Message-ID: <CAJ+vNU0cWUZNcP=suP0rnhG-EqVov5ODk0fKpd4rqf9Setw7Gw@mail.gmail.com>
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
From: Tim Harvey <tharvey@gateworks.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philippe De Muyter <phdm@macq.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 8, 2016 at 6:06 PM, Steve Longerbeam
<steve_longerbeam@mentor.com> wrote:
> On 03/07/2016 08:19 AM, Tim Harvey wrote:
<snip>
>
>
> Hi Tim, good to hear it works for you on the Ventana boards.
>
> I've just pushed some more commits to the mx6-media-staging branch that
> get the drivers/media/i2c/adv7180.c subdev working with the imx6 capture
> backend. Images look perfect when switching to UYVY8_2X8 mbus code instead
> of YUYV8_2X8. But I'm holding off on that change because this subdev is used
> by Renesas targets and would likely corrupt captured images for those
> targets. But I believe UYVY is the correct transmit order according to the
> BT.656 standard.
>
> Another thing that should also be changed in drivers/media/i2c/adv7180.c
> is the field type. It should be V4L2_FIELD_SEQ_TB for NTSC and V4L2_FIELD_SEQ_BT
> for PAL.
>
> Steve
>
>

Steve,

with your latest patches, I'm crashing with an null-pointer-deref in
adv7180_set_pad_format. What is your kernel config for
CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API?

Your tree contains about 16 or so patches on top of linux-media for
imx6 capture. Are you close to the point where you will be posting a
patch series? If so, please CC me for testing with the adv7180 sensor.

Tim
