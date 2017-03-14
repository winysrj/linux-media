Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35184 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdCNQuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 12:50:20 -0400
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
 <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
 <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
 <aa6a5a1d-18fd-8bed-a349-2654d2d1abe0@xs4all.nl>
 <20170313104538.GF21222@n2100.armlinux.org.uk>
 <1489508491.28116.8.camel@ndufresne.ca>
 <20170314164728.GQ21222@n2100.armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8461e333-6867-eecc-db7a-9bf44a2baf18@gmail.com>
Date: Tue, 14 Mar 2017 09:50:14 -0700
MIME-Version: 1.0
In-Reply-To: <20170314164728.GQ21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/14/2017 09:47 AM, Russell King - ARM Linux wrote:
> On Tue, Mar 14, 2017 at 12:21:31PM -0400, Nicolas Dufresne wrote:
>> My main concern here based on what I'm reading, is that this driver is
>> not even able to notice immediately that a produced frame was corrupted
>> (because it's out of sync). From usability perspective, this is really
>> bad. Can't the driver derive a clock from some irq and calculate for
>> each frame if the timing was correct ? And if not mark the buffer with
>> V4L2_BUF_FLAG_ERROR ?
> One of the issues of measuring timing with IRQs is the fact that the
> IRQ subsystem only allows one IRQ to run at a time.  If an IRQ takes
> a relatively long time to process, then it throws the timing of other
> IRQs out.
>
> If you're going to decide that a buffer should be marked in error on
> the basis of an interrupt arriving late, this can trigger spuriously.
>
> It wasn't that long ago that USB HID was regularly eating something
> like 20ms of interrupt time... that's been solved, but that doesn't
> mean all cases are solved - there are still interrupt handlers in the
> kernel that are on the order of milliseconds to complete.
>
> Given the quality I observe of some USB serial devices (eg, running at
> 115200 baud, but feeling like they deliver characters to userspace at
> 9600 baud) I wouldn't be surprised if some USB serial drivers eat a lot
> of IRQ time... and if so, all it'll take is to plug such a device in
> to disrupt capture.
>
> That sounds way too fragile to me.

exactly, hence the imx6 timer input capture support.

Steve
