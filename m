Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40801 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751521AbdGXHVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 03:21:06 -0400
Message-ID: <1500880863.2391.13.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: prpencvf: enable double write reduction
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Jul 2017 09:21:03 +0200
In-Reply-To: <a3299b77-917a-f946-d9fc-33efcf3f2721@gmail.com>
References: <1500758501-5394-1-git-send-email-steve_longerbeam@mentor.com>
         <a3299b77-917a-f946-d9fc-33efcf3f2721@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sat, 2017-07-22 at 15:04 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> This is the same as your patch to CSI, applied to ic-prpencvf.
> 
> I'm not really sure what this cpmem bit is doing. The U/V planes
> in memory are already subsampled by 2 in both width and height.
> This must be referring to what the IDMAC is transferring on the bus,

Right, the IDMAC is just receiving AYUV 4:4:4 pixels from the FIFO, the
CPMEM settings decide how they are written to the AXI bus. If this bit
is not enabled, all pixels are written fully, even though chroma samples
of even and odd lines end up in the same place for 4:2:0 chroma
subsampled output formats. If the bit is set, the chroma writes for odd
lines are skipped, so there is no overdraw.

Unfortunately this does not work for reading, unless there is a line
buffer (which only the VDIC has), because otherwise odd lines end up
without chroma information. This one of the reasons that YUY2 is the
most memory efficient format to read, not NV12.

> but why would it place duplicate U/V samples on the bus in the first
> place?

Don't ask me why the hardware was designed this way :)
I see no reason to ever disable this bit for YUV420 or NV12 write
channels.

> Anyway, thanks for the heads-up on this.

regards
Philipp
