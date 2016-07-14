Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:44391 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbcGNRDr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 13:03:47 -0400
Date: Thu, 14 Jul 2016 18:03:40 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: david.brown@arm.com, liviu.dudau@arm.com
Subject: DRM device memory writeback (Mali-DP)
Message-ID: <20160714170340.GA32755@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The Mali-DP display processors have a memory-writeback engine which
can write the result of the composition (CRTC output) to a memory
buffer in a variety of formats.

We're looking for feedback/suggestions on how to expose this in the
mali-dp DRM kernel driver - possibly via V4L2.

We've got a few use cases where writeback is useful:
    - testing, to check the displayed image
    - screen recording
    - wireless display (e.g. Miracast)
    - dual-display clone mode
    - memory-to-memory composition
Note that the HW is capable of writing one of the input planes instead
of the CRTC output, but we've no good use-case for wanting to expose
that.

In our Android ADF driver[1] we exposed the memory write engine as
part of the ADF device using ADF's "MEMORY" interface type. DRM/KMS
doesn't have any similar support for memory output from CRTCs, but we
want to expose the functionality in the mainline Mali-DP DRM driver.

A previous discussion on the topic went towards exposing the
memory-write engine via V4L2[2].

I'm thinking to userspace this would look like two distinct devices:
    - A DRM KMS display controller.
    - A V4L2 video source.
They'd both exist in the same kernel driver.
A V4L2 client can queue up (CAPTURE) buffers in the normal way, and
the DRM driver would see if there's a buffer to dequeue every time a
new modeset is received via the DRM API - if so, it can configure the
HW to dump into it (one-shot operation).

An implication of this is that if the screen is actively displaying a
static scene and the V4L2 client queues up a buffer, it won't get
filled until the DRM scene changes. This seems best, otherwise the
V4L2 driver has to change the HW configuration out-of-band from the
DRM device which sounds horribly racy.

One further complication is scaling. Our HW has a scaler which can
tasked with either scaling an input plane or the buffer being written
to memory, but not both at the same time. This means we need to
arbitrate the scaler between the DRM device (scaling input planes) and
the V4L2 device (scaling output buffers).

I think the simplest approach here is to allow V4L2 to "claim" the
scaler by setting the image size (VIDIOC_S_FMT) to something other
than the CRTC's current resolution. After that, any attempt to use the
scaler on an input plane via DRM should fail atomic_check().

If the V4L2 client goes away or sets the image size to the CRTC's
native resolution, then the DRM device is allowed to use the scaler.
I don't know if/how the DRM device should communicate to userspace
that the scaler is or isn't available for use.

Any thoughts on this approach?
Is it acceptable to both V4L2 and DRM folks?

Thanks for your time,

-Brian

[1] http://malideveloper.arm.com/resources/drivers/open-source-mali-dp-adf-kernel-device-drivers/
[2] https://people.freedesktop.org/~cbrill/dri-log/?channel=dri-devel&date=2016-05-04
