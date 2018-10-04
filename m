Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbeJDVr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 17:47:59 -0400
Date: Thu, 4 Oct 2018 11:54:16 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v3] media: docs: add glossary.rst with common terms used
 at V4L2 spec
Message-ID: <20181004115416.01a57738@coco.lan>
In-Reply-To: <20181004102706.53d5eb97@coco.lan>
References: <02e399c34a614182ecfa4212cc610fe7d57024f4.1537902727.git.mchehab+samsung@kernel.org>
        <2646453.94SmjfbUfy@avalon>
        <20181004102706.53d5eb97@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 4 Oct 2018 10:27:06 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:


> > > +	For V4L2 hardware, this is also known as V4L2 main driver.    
> > 
> > Do we use the term V4L2 main driver in the V4L2 spec ?  
> 
> Right now, I don't think we use, but this is something that we'll
> need to, in order to define hardware controls.
> 
> Anyway, I'll remove the reference for a V4L2 hardware from this patch,
> moving to the one that talks about vdev-centric/mc-centric.

In time: I'll remove the reference for *V4L2 main driver*, with is
what you asked for


Thanks,
Mauro
