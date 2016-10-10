Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:33628 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbcJJPsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 11:48:39 -0400
Received: by mail-yb0-f181.google.com with SMTP id e20so39450805ybb.0
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:48:38 -0700 (PDT)
Date: Mon, 10 Oct 2016 17:48:31 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Subject: Re: [16/22] ARM: dts: nitrogen6x: Add dtsi for BD_HDMI_MIPI HDMI to
 MIPI CSI-2 receiver board
Message-ID: <20161010154831.gyopknmklf4sxdt6@t450s.lan>
References: <20161007160107.5074-17-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007160107.5074-17-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, All,

On Fri, Oct 07, 2016 at 06:01:01PM +0200, Philipp Zabel wrote:
> Add device tree nodes for the BD_HDMI_MIPI HDMI to MIPI CSI-2 receiver
> board with a TC358743 connected to the Nitrogen6X MIPI CSI-2 input
> connector.

I've tested this series on my Nitrogen6x + BD_HDMI_MIPI daughter board
and have a few questions.

First, why is the tc358743 node in a separate dtsi file? Is this in
order to avoid a failed probe during bootup if the daughter board is
not present? Is this what should be done for every capture device that
targets this platform (like the OV5640 or OV5642)?

Can you provide some details on your testing procedure? In my case I've
reached a point where I get the same 'media-ctl --print-dot' output as
the one from your cover letter but I can't seem to set the EDID nor to
have a gstreamer pipeline (to fakesink). All the EDID v4l2-ctl commands
return "Inappropriate ioctl for device".

Do not hesitate to CC me to Boundary Devices related patches so I can
test them and give some feedback.

Regards,
Gary
