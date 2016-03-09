Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:40235 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcCICGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 21:06:42 -0500
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
To: Tim Harvey <tharvey@gateworks.com>
References: <20160223114943.GA10944@frolo.macqel>
 <20160223141258.GA5097@frolo.macqel> <4956050.OLrYA1VK2G@avalon>
 <56D79B49.50009@mentor.com> <56D7E59B.6050605@xs4all.nl>
 <20160303083643.GA4303@frolo.macqel> <56D87824.8000707@mentor.com>
 <CAJ+vNU2kPgESnjTZokU3qNR6QAbU3G8HGwc7ahg4jDpeS_xjHg@mail.gmail.com>
CC: Philippe De Muyter <phdm@macq.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <56DF852A.30702@mentor.com>
Date: Tue, 8 Mar 2016 18:06:34 -0800
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2kPgESnjTZokU3qNR6QAbU3G8HGwc7ahg4jDpeS_xjHg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2016 08:19 AM, Tim Harvey wrote:
> On Thu, Mar 3, 2016 at 9:45 AM, Steve Longerbeam
> <steve_longerbeam@mentor.com> wrote:
>> Hi Philippe,
>>
>> On 03/03/2016 12:36 AM, Philippe De Muyter wrote:
>>> Just to be sure : do you mean  https://github.com/slongerbeam/mediatree.git
>>> or something else ?
>> Sorry, yes I meant https://github.com/slongerbeam/mediatree.git.
>>
>>>>> So far I have retested video capture with the SabreAuto/ADV7180 and
>>>>> the SabreSD/OV5640-mipi-csi2, and video capture is working fine on
>>>>> those platforms.
>>>>>
>>>>> There is also a mem2mem that should work fine, but haven't tested yet.
>>>>>
>>>>> I removed camera preview support. At Mentor Graphics we have made
>>>>> quite a few changes to ipu-v3 driver to allow camera preview to initialize
>>>>> and control an overlay display plane independently of imx-drm, by adding
>>>>> a subsystem independent ipu-plane sub-unit. Note we also have a video
>>>>> output overlay driver that also makes use of ipu-plane. But those changes are
>>>>> extensive and touch imx-drm as well as ipu-v3, so I am leaving camera preview
>>>>> and the output overlay driver out (in fact, camera preview is not of much
>>>>> utility so I probably won't bring it back in upstream version).
>>>>>
>>>>> The video capture driver is not quite ready for upstream review yet. It still:
>>>>>
>>>>> - uses the old cropping APIs but should move forward to selection APIs.
>>>>>
>>>>> - uses custom sensor subdev drivers for ADV7180 and OV564x. Still
>>>>>   need to switch to upstream subdevs.
>>> Is it only a problem of those sensor drivers (which exact files ?) or
>>> is it a problem of the capture driver itself ?
>> The camera interface driver (drivers/staging/media/imx6/capture/mx6-camif.c)
>> is binding to these subdevs:
>>
>> drivers/staging/media/imx6/capture/adv7180.c
>> drivers/staging/media/imx6/capture/ov5642.c
>> drivers/staging/media/imx6/capture/ov5640-mipi.c
>>
>> But instead should use the subdevs under drivers/media/i2c, specifically:
>>
>> drivers/media/i2c/adv7180.c (and adding whatever standard subdev features
>> the imx6 interface driver requires).
>>
>> There is a drivers/media/i2c/soc_camera/ov5642.c, but there is no mipi-csi2
>> capable subdev for the ov5640 with the mipi-csi2 interface, so that would have
>> to be created.
>>
> Steve,
>
> I've built your mx6-media-staging branch and added device-tree config
> for the Gateworks Ventana boards which have an on-board ADV7180 and it
> works great. I've tested it capturing frames via v4l2-ctl as well as
> gstreamer.
>
> Please let me know what kind of testing you need. I would love to see
> this get mainlined!
>


Hi Tim, good to hear it works for you on the Ventana boards.

I've just pushed some more commits to the mx6-media-staging branch that
get the drivers/media/i2c/adv7180.c subdev working with the imx6 capture
backend. Images look perfect when switching to UYVY8_2X8 mbus code instead
of YUYV8_2X8. But I'm holding off on that change because this subdev is used
by Renesas targets and would likely corrupt captured images for those
targets. But I believe UYVY is the correct transmit order according to the
BT.656 standard.

Another thing that should also be changed in drivers/media/i2c/adv7180.c
is the field type. It should be V4L2_FIELD_SEQ_TB for NTSC and V4L2_FIELD_SEQ_BT
for PAL.

Steve


