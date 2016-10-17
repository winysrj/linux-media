Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46399 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934553AbcJQMld (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 08:41:33 -0400
Message-ID: <1476708091.2488.29.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Gary Bisson <gary.bisson@boundarydevices.com>,
        Lucas Stach <l.stach@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Date: Mon, 17 Oct 2016 14:41:31 +0200
In-Reply-To: <20161017101820.stfboaeqncadlvfz@t450s.lan>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161017101820.stfboaeqncadlvfz@t450s.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

Am Montag, den 17.10.2016, 12:18 +0200 schrieb Gary Bisson:
[...]
> For the whole series:
> Tested-by: Gary Bisson <gary.bisson@boundarydevices.com>
> 
> Tested on Nitrogen6x + BD_HDMI_MIPI daughter board on linux-next
> 20161016.
>
> This required using your v4l2-ctl patch to set the EDID if the source
> output can't be forced:
> https://patchwork.kernel.org/patch/6097201/
> BTW, do you have any update on this? Because it looks like the
> VIDIOC_SUBDEV_QUERYCAP hasn't been implemented since your patch (March
> 2015).
> 
> Then I followed the procedure you gave here:
> https://patchwork.kernel.org/patch/9366503/
> 
> For those interested in trying it out, note that kmssink requires to use
> Gstreamer 1.9.x.
> 
> I have a few remarks:
> - I believe it would help having a patch that sets imx_v6_v7_defconfig
>   with the proper options in this series

I can add that in the next round.

> - Not related to this series, I couldn't boot the board unless I disable
>   the PCIe driver, have you experienced the same issue?

I had not enabled the PCIe driver, but a quick boot test with
CONFIG_PCIE_DW enabled hangs after these messages:

[    1.314298] OF: PCI: host bridge /soc/pcie@0x01000000 ranges:
[    1.317199] OF: PCI:   No bus range found for /soc/pcie@0x01000000, using [bus 00-ff]
[    1.325171] OF: PCI:    IO 0x01f80000..0x01f8ffff -> 0x00000000
[    1.331029] OF: PCI:   MEM 0x01000000..0x01efffff -> 0x01000000

I've asked Lucas to have a look.

> - Is there a way not to set all the links manually using media-ctl? I
>   expected all the formats to be negotiated automatically once a stream
>   is properly detected.

This should be done in userspace, probably libv4l2.

> - As discussed last week, the Nitrogen6x dtsi file shouldn't be
>   included, instead an overlay would be more appropriate. Maybe the log
>   should contain a comment about this.

Ok.

> Let me know if I need to add that Tested-by to every single patch so it
> appears on Patchwork.

It's fine as is, thank you.

regards
Philipp

