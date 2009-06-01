Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47601 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZFAOs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 10:48:28 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 1 Jun 2009 09:48:21 -0500
Subject: RE: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401354ECDB2@dlee06.ent.ti.com>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
 <200905281518.18879.laurent.pinchart@skynet.be>
In-Reply-To: <200905281518.18879.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Thanks for reviewing this. I have not gone through all of your comments, but would like to respond to the following one first. I will respond to the rest as I do the rework.

>I've had a quick look at the DM355 and DM6446 datasheets. The CCDC and VPSS
>registers share the same memory block. Can't you use a single resource ?
>
>One nice (and better in my opinion) solution would be to declare a
>structure
>with all the VPSS/CCDC registers as they are implemented in hardware and
>access the structure fields with __raw_read/write*. You would then store a
>single pointer only. Check arch/powerpc/include/asm/immap_cpm2.h for an
>example.

I think, a better solution will be to move the vpss system module part to the board specific file dm355.c or dm6446.c and export functions to configure them as needed by the different drivers. The vpss has evolved quite a lot from DM6446 to DM355 to DM365. Registers such as INTSEL and INTSTAT and others are applicable to other modules as well, not just the ccdc module. The VPBE and resizer drivers will need to configure them too. Also the vpss system module features available in DM365 is much more than that in DM355. Interrupts line to ARM are programmable in DM365 vpss and multiple vpss irq lines can be muxed to the ARM side. So I would imaging functions enable/disable irq line to arm, clearing irq bits, enabling various clocks etc can be done in a specific soc specific file (dm355.c, dm365.c or dm6446.c) and can be exported for use in specific drivers. I just want to get your feedback so that I can make this change. With this change, there is no need to use structures for holding register offsets as you have suggested.
