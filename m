Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1352 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbZCMPsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 11:48:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC 0/7] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Fri, 13 Mar 2009 16:48:35 +0100
Cc: chaithrika@ti.com, linux-media@vger.kernel.org
References: <1236934590-31501-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1236934590-31501-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131648.35612.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 March 2009 09:56:30 chaithrika@ti.com wrote:
> Display driver for TI DM646x EVM
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
>
> This patch set is being submitted to get review and opinion on the
> approaches used to implement the sub devices and display drivers.
>
> This set adds the display driver support for TI DM646x EVM.
> This patch set has been tested for basic display functionality for
> Composite and Component outputs.
>
> Patch 1: Display device platform and board setup
> Patch 2: ADV7343 video encoder driver
> Patch 3: THS7303 video amplifier driver
> Patch 4: Defintions for standards supported by display
> Patch 5: Makefile and config files modifications for Display
> Patch 6: VPIF driver
> Patch 7: DM646x display driver
>
> The 'v4l2-subdevice' interface has been used to interact with the encoder
> and video amplifier.
>
> Some of the features like the HBI/VBI support are not yet implemented.
> Also there are some known issues in the code implementation like
> fine tuning to be done to TRY_FMT ioctl and ENUM_OUTPUT ioctl.The USERPTR
> usage has not been tested extensively,also some HD standards are yet to
> be tested.
>
> These patches are based on the drivers written by:
>         Manjunath Hadli <mrh@ti.com>
>         Brijesh Jadav <brijesh.j@ti.com>
>
> -Chaithrika

Thanks!

I'll review these patches in the coming days. I'll probably review the 
ADV7343 and THS7303 first before continuing with the others.

I suspect that the adv7343 and ths7303 can probably be merged quickly after 
a few changes. The main drivers in patches 6 & 7 will probably require some 
more thought. Since I've been working with this device for over a year now 
I can bring in a user-perspective as well :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
