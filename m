Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab2EKF0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 01:26:53 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v2 07/13] davinci: vpif: add support to use
 videobuf_iolock()
Date: Fri, 11 May 2012 05:26:44 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E927B5D@DBDE01.ent.ti.com>
References: <1334652791-15833-1-git-send-email-manjunath.hadli@ti.com>
 <1334652791-15833-8-git-send-email-manjunath.hadli@ti.com>
 <11508400.1umVUoMoqL@avalon>
In-Reply-To: <11508400.1umVUoMoqL@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 17, 2012 at 15:16:50, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> Thanks for the patch.
> 
> On Tuesday 17 April 2012 14:23:05 Manjunath Hadli wrote:
> > add support to use videobuf_iolock() instead of VPIF defined 
> > vpif_uservirt_to_phys API. Use videobuf_to_dma_contig API for both 
> > memory-mapped and userptr buffer allocations.
> > Correspondingly removed vpif_uservirt_to_phys() VPIF defined API.
> 
> What about using videobuf2 instead ? :-)
  
We will definitely migrate to videobuf2 in the near future, but I wish to go ahead with the implementation as of now.

Thx,
--Manju

> --
> Regards,
> 
> Laurent Pinchart
> 
> 

