Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37083 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2CKL7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 07:59:19 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH - stable v3.2] omap3isp: ccdc: Fix crash in HS/VS
 interrupt handler
Date: Sun, 11 Mar 2012 11:59:12 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6317F1421@DBDE01.ent.ti.com>
References: <1331466608-3277-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331466608-3277-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 11, 2012 at 17:20:08, Laurent Pinchart wrote:
> The HS/VS interrupt handler needs to access the pipeline object. It
> erronously tries to get it from the CCDC output video node, which isn't
> necessarily included in the pipeline. This leads to a NULL pointer
> dereference.
> 
> Fix the bug by getting the pipeline object from the CCDC subdev entity.
> 
> Reported-by: Gary Thomas <gary@mlbassoc.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/omap3isp/ispccdc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> The patch fixes a v3.2 bug and has been included in v3.3-rc1. Could you please
> add it to the stable v3.2 series ?

AFAIK, stable@kernel.org is down and the correct address is
stable@vger.kernel.org.

Also, you need to include the upstream commit id in the commit
message (See Documentation/stable_kernel_rules.txt)

Thanks,
Sekhar

