Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33992 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZCQEYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 00:24:21 -0400
From: "Subrahmanya, Chaithrika" <chaithrika@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Mar 2009 09:52:45 +0530
Subject: RE: [RFC 0/7] ARM: DaVinci: DM646x Video: DM646x display driver
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02A8764C18@dbde02.ent.ti.com>
References: <1236934590-31501-1-git-send-email-chaithrika@ti.com>,<200903131648.35612.hverkuil@xs4all.nl>
In-Reply-To: <200903131648.35612.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Friday 13 March 2009 09:56:30 chaithrika@ti.com wrote:
> > Display driver for TI DM646x EVM
> >
> > Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> >
> > This patch set is being submitted to get review and opinion on the
> > approaches used to implement the sub devices and display drivers.
> >
> > This set adds the display driver support for TI DM646x EVM.
> > This patch set has been tested for basic display functionality for
> > Composite and Component outputs.
> >
> > Patch 1: Display device platform and board setup
> > Patch 2: ADV7343 video encoder driver
> > Patch 3: THS7303 video amplifier driver
> > Patch 4: Defintions for standards supported by display
> > Patch 5: Makefile and config files modifications for Display
> > Patch 6: VPIF driver
> > Patch 7: DM646x display driver
> >
> > The 'v4l2-subdevice' interface has been used to interact with the
> encoder
> > and video amplifier.
> >
> > Some of the features like the HBI/VBI support are not yet
> implemented.
> > Also there are some known issues in the code implementation like
> > fine tuning to be done to TRY_FMT ioctl and ENUM_OUTPUT ioctl.The
> USERPTR
> > usage has not been tested extensively,also some HD standards are yet
> to
> > be tested.
> >
> > These patches are based on the drivers written by:
> >         Manjunath Hadli <mrh@ti.com>
> >         Brijesh Jadav <brijesh.j@ti.com>
> >
> > -Chaithrika
> 
> Thanks!
> 
> I'll review these patches in the coming days. I'll probably review the
> ADV7343 and THS7303 first before continuing with the others.
> 
> I suspect that the adv7343 and ths7303 can probably be merged quickly
> after
> a few changes. The main drivers in patches 6 & 7 will probably require
> some
> more thought. Since I've been working with this device for over a year
> now
> I can bring in a user-perspective as well :-)
> 

Hans,

Thank you very much for taking time to review these patches and giving 
valuable comments. As you have suggested, I will first work on the review 
comments for ADV7343 and THS7303 drivers. After this is done, I will look 
into the review comments for display driver. 

Thanks,
Chaithrika

> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html