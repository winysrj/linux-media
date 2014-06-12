Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45623 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaFLQuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:50:46 -0400
Message-ID: <1402591841.3444.136.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Date: Thu, 12 Jun 2014 18:50:41 +0200
In-Reply-To: <5398FC95.1070504@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402485696.4107.107.camel@paszta.hi.pengutronix.de>
	 <5398FC95.1070504@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

[Added Russell to Cc: because of the question how to send IPU core 
 patches to drm-next]

Am Mittwoch, den 11.06.2014, 18:04 -0700 schrieb Steve Longerbeam:
> Hi Philipp and Sascha,
> 
> First of all, thanks for the detailed review.

You are welcome. I am tasked to prepare our own capture drivers for
mainline submission, but they are not quite there yet. I'd be very
interested in getting this worked out together, especially since we
seem to be interested in orthogonal features (we had no use for the
preview and and encoder IC tasks or MIPI CSI-2 so far, but we need
media controller support and mem2mem scaling via the post-processor IC
task).
I'm going to post our current series as is, if only to illustrate my
point of view.

> I think it's obvious that this patch set should be split into two: first,
> the changes to IPU core driver submitted to drm-next, and the capture driver
> to media-tree.

I agree.

> Or, do you prefer I submit the IPU core patches to your own pengutronix git
> tree, and we can correspond on one of your internal mailing lists?

Why would we move discussion to an internal mailing list? Since we are
sitting right inbetween dri-devel and linux-media with the IPU core
code, I think either mailing list is an appropriate place for discussing
these patches, depending on the context.

> I can then leave it to you to push those changes to drm-next.

I think a central place to collect IPU core patches before sending them
off to drm-next is a good idea. I offer to do the collecting in my tree.
I also know Russell volunteered to collect and send off imx-drm patches
towards staging. Russell, I'm not sure if this offer extends to non-DRM
IPU core patches to be submitted to drm-next? (And if yes, whether you'd
rather keep at it or have this taken off your hands.)

> I agree with most of your feedback, and most is specific to the IPU core
> changes.

Excellent. For the core changes, rebasing them onto next and then
integrating some remaining changes from our patchset shouldn't be a
problem.
The big issue I have with the media parts is the missing media
controller support and the code organization around the IC tasks
instead of around hardware submodules.

>  We can discuss those in detail elsewhere, but just in summary here,
> some of your comments seem to conflict:
> 
> 1. Regarding the input muxes to the CSI and IC, Philipp you acked those
> functions but would like to see these muxes as v4l2 subdevs and configured
> in the DT, but Sascha, you had a comment that this should be a job for
> mediactrl.

No conflict here, there are different multiplexers to talk about.

First, there are two external multiplexers controlled by IOMUXC (on
i.MX6, these don't exist on i.MX5): MIPI_IPU1/2_MUX on i.MX6Q and
IPU_CSI0/1_MUX. They are not part of the IPU.
They each sit between a set of parallel input pads and the CSI2IPU
gasket on one side and one CSI on the other side.
In my opinion, these should be handled by separate v4l2_subdev drivers
and their connections described in the device tree. The links between
subdevices can then be controlled via the media controller framework.
This is what my comments on patches 05/43 and 08/43 are about.

Second, there are the CSI0/1_DATA_SOURCE muxes and the CSI_SEL/IC_INPUT
muxes controlled by the IPU_CONF register. These should not be described
in the device tree. Just as CSI and IC, they are an IPU internal detail.

The CSI0/1_DATA_SOURCE, if I understand correctly, muxes not the data
bus, but the 8-bit mct_di bus which carries the MIPI channel id and data
type. This should be controlled by the CSI subdevice driver directly
when choosing its input format.

The CSI_SEL/IC_INPUT multiplexer selects the input to the IC to come
from either CSI0, CSI1, or the VDI. Each of those subunits would fit
the media entity abstraction well. This multiplexer should be controlled
by the media controller framework.

I acked the CSI/IC source mux functions in patch 06/43 because I think
those functions are in the right place and useful in the above scenario.

> 2. Philipp, you would like to see CSI, IC, and SMFC units moved out of IPU
> core and become v4l2 subdevs. I agree with that, but drm-next has ipu-smfc
> as part of IPU core, and SMFC is most definitely v4l2 capture specific.

About the CSI I'm just a tiny bit conflicted myself, that seems to show.

>From an organizational standpoint, with all the other register access
code in gpu/ipu-v3, having the ipu-csi code in there too looks nice and
as expected. On the other hand, this should really be only used by one
v4l2_subdev driver. When I look at it this way, I see a driver that is
split in two parts, wasting exported symbol space for no very good
reason.

The IC I'd like to describe as a v4l2_subdev. But I'd also like to use
the IC from the DRM driver. So the IC core code has to stay in
gpu/ipu-v3. I'd just like to pool all V4L2 code that uses this into a IC
v4l2_subdev driver if possible. The only use we have for the IC
currently is 

The SMFC code is small and, more importantly, its functionality is
limited enough that it doesn't warrant its own v4l2_subdev. I see not
enough reason to move this away from the other IPU core code, since the
v4l2_device capture driver that uses it certainly is not the right place
to map SMFC registers directly.

So the CSI only is a special case because the code in ipu-csi.c aligns
so well with a single v4l2_subdev driver.

regards
Philipp

