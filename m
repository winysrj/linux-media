Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60738 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab2DQJqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 05:46:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 07/13] davinci: vpif: add support to use videobuf_iolock()
Date: Tue, 17 Apr 2012 11:46:50 +0200
Message-ID: <11508400.1umVUoMoqL@avalon>
In-Reply-To: <1334652791-15833-8-git-send-email-manjunath.hadli@ti.com>
References: <1334652791-15833-1-git-send-email-manjunath.hadli@ti.com> <1334652791-15833-8-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

Thanks for the patch.

On Tuesday 17 April 2012 14:23:05 Manjunath Hadli wrote:
> add support to use videobuf_iolock() instead of VPIF
> defined vpif_uservirt_to_phys API. Use videobuf_to_dma_contig
> API for both memory-mapped and userptr buffer allocations.
> Correspondingly removed vpif_uservirt_to_phys() VPIF defined API.

What about using videobuf2 instead ? :-)

-- 
Regards,

Laurent Pinchart

