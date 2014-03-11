Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52361 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaCKLPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 07:15:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 36/47] adv7604: Make output format configurable through pad format operations
Date: Tue, 11 Mar 2014 12:16:53 +0100
Message-ID: <5198476.Eg6VVVrCH7@avalon>
In-Reply-To: <531ED1BC.3020904@xs4all.nl>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1662851.xYrCTEPdFE@avalon> <531ED1BC.3020904@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 March 2014 10:05:00 Hans Verkuil wrote:
> On 03/10/14 23:43, Laurent Pinchart wrote:
> > On Wednesday 12 February 2014 16:01:17 Hans Verkuil wrote:
> >> On 02/05/14 17:42, Laurent Pinchart wrote:
> >>> Replace the dummy video format operations by pad format operations that
> >>> configure the output format.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> ---
> >>> 
> >>>  drivers/media/i2c/adv7604.c | 243 ++++++++++++++++++++++++++++++++-----
> >>>  include/media/adv7604.h     |  47 ++-------
> >>>  2 files changed, 225 insertions(+), 65 deletions(-)
> >> 
> >> <snip>
> >> 
> >>> diff --git a/include/media/adv7604.h b/include/media/adv7604.h
> >>> index 22811d3..2cc8e16 100644
> >>> --- a/include/media/adv7604.h
> >>> +++ b/include/media/adv7604.h
> >>> @@ -32,16 +32,6 @@ enum adv7604_ain_sel {
> >>>  	ADV7604_AIN9_4_5_6_SYNC_2_1 = 4,
> >>>  };
> >>> 
> >>> -/* Bus rotation and reordering (IO register 0x04, [7:5]) */
> >>> -enum adv7604_op_ch_sel {
> >>> -	ADV7604_OP_CH_SEL_GBR = 0,
> >>> -	ADV7604_OP_CH_SEL_GRB = 1,
> >>> -	ADV7604_OP_CH_SEL_BGR = 2,
> >>> -	ADV7604_OP_CH_SEL_RGB = 3,
> >>> -	ADV7604_OP_CH_SEL_BRG = 4,
> >>> -	ADV7604_OP_CH_SEL_RBG = 5,
> >>> -};
> >>> -
> >>>  /* Input Color Space (IO register 0x02, [7:4]) */
> >>>  enum adv7604_inp_color_space {
> >>>  	ADV7604_INP_COLOR_SPACE_LIM_RGB = 0,
> >>> @@ -55,29 +45,11 @@ enum adv7604_inp_color_space {

[snip]

> >>> @@ -104,11 +76,8 @@ struct adv7604_platform_data {
> >>> 
> >>>  	/* Analog input muxing mode */
> >>>  	enum adv7604_ain_sel ain_sel;
> >>> 
> >>> -	/* Bus rotation and reordering */
> >>> -	enum adv7604_op_ch_sel op_ch_sel;
> >> 
> >> I would keep this as part of the platform_data. This is typically used if
> >> things are wired up in a non-standard way and so is specific to the
> >> hardware. It is not something that will change from format to format.
> > 
> > Right, some level of configuration is needed to account for non-standard
> > wiring. However I'm not sure where that should be handled.
> > 
> > With exotic wiring the format at the receiver will be different than the
> > format output by the ADV7604. From a pure ADV7604 point of view, the
> > output format doesn't depend on the wiring. I wonder whether this
> > shouldn't be a link property instead of being a subdev property. There's
> > of course the question of where to store that link property if it's not
> > part of either subdev.
> > 
> > Even if we decide that the wiring is a property of the source subdev, I
> > don't think we should duplicate bus reordering code in all subdev
> > drivers. This should thus be handled by the v4l2 core (either directly or
> > as helper functions).
> 
> There are two reasons why you might want to use op_ch_sel: one is to
> implement weird formats like RBG. Something like that would have to be
> controlled through mbus and pixel fourcc codes and not by hardcoding this
> register.

Agreed. This patch only adds a subset of the possible output formats. More 
formats can be added later as needed.

> The other is to compensate for a wiring problem: we have a card where two
> channels were accidentally swapped. You can either redo the board or just
> set this register. In this case this register is IMHO a property of this
> subdev. It needs to know about it, because if it ever needs to output RBG
> in the future then it needs to compensate for reordering for wiring
> issues.
> 
> So you set this field if you have to compensate for wiring errors, making
> this part of the DT/platform_data. You do not set this field when you
> want to support special formats, that is done in the driver itself through
> fourcc codes (or could be done as this isn't implemented at the moment).

I agree with the use case, but I'm not sure whether that's the best way to 
support it. Let's say the system is design for RGB, but the G and B channels 
have been swapped by mistake on the board. To make it work, the ADV7604 would 
need to output RBG, and the bridge would receive RGB. Data reordering would 
thus happen on the link.

There's two ways to expose this to userspace. One of them would be to make the 
real formats visible to applications. We would need to extend the link API to 
show that reordering occurs. Userspace would need to explicitly configure the 
adv7604 driver with RBG at its source pad and the bridge driver with RGB at 
its sink pad. This has the advantage of correctly modeling the hardware, and 
not pushing workarounds for board-level issues to individual drivers.

Another solution would be to hide the wiring problem from userspace and handle 
it inside the adv7604 driver. Note that, depending on the hardware 
configuration, it could be the bridge driver that need to implement 
reordering. Userspace would configure both ends of the link to RGB and 
wouldn't be aware of the problem.  This has the advantage of hiding the 
problem in the kernel. However, it would require implementing the same 
workaround in potentially many drivers.

If we decide to go for the second solution I would like to make it a bit more 
generic than just keeping the op_ch_sel field in platform data. I think we 
should instead have a generic representation of the reordering in platform 
data, and implement a V4L2 core function that would translate the format on 
the link to the format required at the device. For instance, still assuming G 
and B are swapped, userspace would configure the ADV7604 output to 
V4L2_MBUS_FMT_RGB888_1X24, the adv7604 driver would pass 
V4L2_MBUS_FMT_RGB888_1X24 along with the reordering information to a V4L2 core 
function which would return V4L2_MBUS_FMT_RBG888_1X24, and the driver would 
then configure the device to output RBG instead of RGB.

This leaves three open questions :

- Should the workaround be visible to userspace ?
- If not, how should reordering be expressed in platform data (and DT) ?
- Does this need to be part of this patch set or can it be implemented later ?

-- 
Regards,

Laurent Pinchart

