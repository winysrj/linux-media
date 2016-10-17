Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33866 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932964AbcJQKSa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 06:18:30 -0400
Received: by mail-qk0-f177.google.com with SMTP id f128so216501562qkb.1
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 03:18:29 -0700 (PDT)
Date: Mon, 17 Oct 2016 12:18:20 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
Message-ID: <20161017101820.stfboaeqncadlvfz@t450s.lan>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Fri, Oct 14, 2016 at 07:34:20PM +0200, Philipp Zabel wrote:
> Hi,
> 
> the second round removes the prepare_stream callback and instead lets the
> intermediate subdevices propagate s_stream calls to their sources rather
> than individually calling s_stream on each subdevice from the bridge driver.
> This is similar to how drm bridges recursively call into their next neighbor.
> It makes it easier to do bringup ordering on a per-link level, as long as the
> source preparation can be done at s_power, and the sink can just prepare, call
> s_stream on its source, and then enable itself inside s_stream. Obviously this
> would only work in a generic fashion if all asynchronous subdevices with both
> inputs and outputs would propagate s_stream to their source subdevices.
> 
> Changes since v1:
>  - Propagate field and colorspace in ipucsi_subdev_set_format.
>  - Remove v4l2_media_subdev_prepare_stream and v4l2_media_subdev_s_stream,
>    let subdevices propagate s_stream calls to their upstream subdevices
>    themselves.
>  - Various fixes (see individual patches for details)

For the whole series:
Tested-by: Gary Bisson <gary.bisson@boundarydevices.com>

Tested on Nitrogen6x + BD_HDMI_MIPI daughter board on linux-next
20161016.

This required using your v4l2-ctl patch to set the EDID if the source
output can't be forced:
https://patchwork.kernel.org/patch/6097201/
BTW, do you have any update on this? Because it looks like the
VIDIOC_SUBDEV_QUERYCAP hasn't been implemented since your patch (March
2015).

Then I followed the procedure you gave here:
https://patchwork.kernel.org/patch/9366503/

For those interested in trying it out, note that kmssink requires to use
Gstreamer 1.9.x.

I have a few remarks:
- I believe it would help having a patch that sets imx_v6_v7_defconfig
  with the proper options in this series
- Not related to this series, I couldn't boot the board unless I disable
  the PCIe driver, have you experienced the same issue?
- Is there a way not to set all the links manually using media-ctl? I
  expected all the formats to be negotiated automatically once a stream
  is properly detected.
- As discussed last week, the Nitrogen6x dtsi file shouldn't be
  included, instead an overlay would be more appropriate. Maybe the log
  should contain a comment about this.

Let me know if I need to add that Tested-by to every single patch so it
appears on Patchwork.

Regards,
Gary
