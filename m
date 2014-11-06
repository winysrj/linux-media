Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:54928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027AbaKFDhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 22:37:19 -0500
From: Chris Kohn <christian.kohn@xilinx.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Michal Simek <michals@xilinx.com>, Hyun Kwon <hyunk@xilinx.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v3 11/13] v4l: xilinx: Add Xilinx Video IP core
Date: Thu, 6 Nov 2014 03:05:27 +0000
References: <1414940018-3016-12-git-send-email-laurent.pinchart@ideasonboard.com>
 <1415212587-5003-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1415212587-5003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Message-ID: <678b94ef89b04748accfa49858f6cb47@BN1BFFO11FD030.protection.gbl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, November 05, 2014 10:36 AM
> To: linux-media@vger.kernel.org
> Cc: Michal Simek; Chris Kohn; Hyun Kwon; devicetree@vger.kernel.org
> Subject: [PATCH v3 11/13] v4l: xilinx: Add Xilinx Video IP core
>
> Xilinx platforms have no hardwired video capture or video processing
> interface. Users create capture and memory to memory processing
> pipelines in the FPGA fabric to suit their particular needs, by
> instantiating video IP cores from a large library.
>
> The Xilinx Video IP core is a framework that models a video pipeline
> described in the device tree and expose the pipeline to userspace
> through the media controller and V4L2 APIs.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>
> ---
>
> I'd appreciate if DT reviewers could have a look at the xlnx,video-format and
> xlnx,video-width properties if nothing else.
>
> Changes since v2:
>
> - Remove explicit trailing \0 after snprintf
> - Don't hardcode colorspace

I've split these two up based on the individual patches in the tree you pointed me to yesterday. The first one I squashed into

v4l: xilinx: dma: Fix querycap capabilities and bus_info reporting

for the colorspace I created a new patch. I don't want to take credit for it, so if you can send me a patch I'll apply it to my local branch.

Other than that, it's working fine on my end.

Cheers,
Chris


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

