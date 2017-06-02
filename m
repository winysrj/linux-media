Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58857 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751126AbdFBMfm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 08:35:42 -0400
Subject: Re: [PATCH 0/3] tc358743: minor driver fixes
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl>
Date: Fri, 2 Jun 2017 14:35:36 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/17 14:18, Dave Stevenson wrote:
> These 3 patches for TC358743 came out of trying to use the
> existing driver with a new Raspberry Pi CSI-2 receiver driver.

Nice! Doing that has been on my todo list for ages but I never got
around to it. I have one of these and using the Raspberry Pi with
the tc358743 would allow me to add a CEC driver as well.

> A couple of the subdevice API calls were not implemented or
> otherwise gave odd results. Those are fixed.
> 
> The TC358743 interface board being used didn't have the IRQ
> line wired up to the SoC. "interrupts" is listed as being
> optional in the DT binding, but the driver didn't actually
> function if it wasn't provided.
> 
> Dave Stevenson (3):
>   [media] tc358743: Add enum_mbus_code
>   [media] tc358743: Setup default mbus_fmt before registering
>   [media] tc358743: Add support for platforms without IRQ line

All looks good, I'll take this for 4.12.

Regards,

	Hans

> 
>  drivers/media/i2c/tc358743.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 58 insertions(+), 1 deletion(-)
> 
