Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34852 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZKFGts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 01:49:48 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 6 Nov 2009 12:19:47 +0530
Subject: RE: Finished my email backlog, let me know if I missed anything
Message-ID: <19F8576C6E063C45BE387C64729E73940436F93B96@dbde02.ent.ti.com>
References: <200911051730.53642.hverkuil@xs4all.nl>
In-Reply-To: <200911051730.53642.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> Sent: Thursday, November 05, 2009 10:01 PM
> To: linux-media@vger.kernel.org
> Subject: Finished my email backlog, let me know if I missed anything
> 
> Hi all,
> 
> As I've been away/busy for a few weeks I had a large pile of pending
> emails.
> I went through it all today, but if I missed anything then please
> remind me.
> 
[Hiremath, Vaibhav] Hans, there are some patches which I posted which need to be merged. Can you have look at it?

VPFE - 6 patches
 - Davinci VPFE Capture: Specify device pointer in videobuf_queue_dma_contig_init
- Davinci VPFE Capture:Replaced IRQ_VDINT1 with vpfe_dev->ccdc_irq1
- Davinci VPFE Capture: Add support for Control ioctls[note: posting again]
- TVP514x:Switch to automode for s_input/querystd
- Davinci VPFE Capture: Take i2c adapter id through platform data

OMAP - 2 patches

- V4L2: Added CID's V4L2_CID_ROTATE/BG_COLOR
- v4l2 doc: Added S/G_ROTATE, S/G_BG_COLOR information
- V4L2: Add Capability and Flag field for Croma Key
- OMAP2/3 V4L2:Add support for OMAP2/3 V4L2 driver ontop of DSS2[Note: need to repost again]


Thanks,
Vaibhav

> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

