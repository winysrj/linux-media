Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3788 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZKIPPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 10:15:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: S_FMT @ sensor driver & bridge driver
Date: Mon, 9 Nov 2009 16:15:42 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE401558AB985@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401558AB985@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911091615.43017.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 09 November 2009 15:48:35 Karicheri, Muralidharan wrote:
> Hello,
> 
> Currently the S_FMT IOCTL is used to configure the image resolution
> and (there by scaler settings) at the sensor (example MT9T031).
> Platforms like TI's DMxxx VPFE has Resizer in the pipeline that can
> be used as well by application to either zoom in a specific region
> of the capture image from the sensor or scale it up for some other
> reason. To do this we need to issue two S_FMT commands, 1st to set
> the capture frame resolution at the sensor and second to configure
> resize ration at the SOC Resizer. With the current API, I don't see
> a way this can be done. I wish we had some extra bytes in the S_FMT structure to add a flag that can indicate if S_FMT applies to the
> sensor or at the SOC (bridge). One way to implement this is to add
> a control to tell the bridge driver to send a specific IOCTL command
> to the sensor. Another use of such a command will be for control.
> For example if a specific control such as White balance is available
> at the SOC pipeline as well as at the sensor, then application can
> use the above control to direct that IOCTL command to the specific
> device.
> 
> You might argue that Media controller will allow you to direct
> such commands directly to the target device. This is true for
> control example I have mentioned above. But when applying
> S_FMT at the sensor, we might want to passing it through the
> bridge driver (as is the case with VPFE) so that it can request
> extra lines to be captured as overhead to allow processing the
> frame at the SOC pipeline in real time. So I do see this control
> command staying even after we have media controller. Let me know
> if you disagree with this proposal or have alternative to implement
> the same. If I don't hear anything against this approach, I would
> like to send patch to implement this control for vpfe capture
> driver.

I don't think this is a good idea. This is something that is highly
hw dependent and as such should be done as part of the hw-specific
subdev API that we will get in the future.

The S_FMT ioctl is really a best-effort when it comes to SoCs. I.e.
the S_FMT driver implementation should just try to do the best setup
it can do (within reason).

I wonder if we shouldn't start implementing the code needed to get subdev
device nodes: if we have those, then it becomes much easier to start
implementing hw-specific features. We don't need the media controller for
that initially.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
