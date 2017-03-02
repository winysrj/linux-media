Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:36551 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdCBT1u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 14:27:50 -0500
Date: Thu, 2 Mar 2017 13:08:21 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [Patch 0/2] media: ti-vpe: allow user specified stride
Message-ID: <20170302190821.GS16339@ti.com>
References: <20170213130658.31907-1-bparrot@ti.com>
 <2aeeb8ff-879d-9f56-9b4d-3e8b01c880a2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2aeeb8ff-879d-9f56-9b4d-3e8b01c880a2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Mauro,

Ping.

Regards,
Benoit

Tomi Valkeinen <tomi.valkeinen@ti.com> wrote on Fri [2017-Feb-17 11:45:41 +0200]:
> On 13/02/17 15:06, Benoit Parrot wrote:
> > This patch series enables user specified buffer stride to be used
> > instead of always forcing the stride from the driver side.
> > 
> > Benoit Parrot (2):
> >   media: ti-vpe: vpdma: add support for user specified stride
> >   media: ti-vpe: vpe: allow use of user specified stride
> > 
> >  drivers/media/platform/ti-vpe/vpdma.c | 14 ++++----------
> >  drivers/media/platform/ti-vpe/vpdma.h |  6 +++---
> >  drivers/media/platform/ti-vpe/vpe.c   | 34 ++++++++++++++++++++++++----------
> >  3 files changed, 31 insertions(+), 23 deletions(-)
> 
> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> 
>  Tomi
> 
