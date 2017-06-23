Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58349 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754606AbdFWJxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:53:34 -0400
Message-ID: <1498211613.2487.3.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/3] [media] coda: first step at error recovery
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, patchwork-lst@pengutronix.de,
        Lucas Stach <l.stach@pengutronix.de>
Date: Fri, 23 Jun 2017 11:53:33 +0200
In-Reply-To: <c294fe89-092f-65fd-9901-6c1b88cb21e0@xs4all.nl>
References: <20170608085513.26857-1-p.zabel@pengutronix.de>
         <20170608085513.26857-2-p.zabel@pengutronix.de>
         <c294fe89-092f-65fd-9901-6c1b88cb21e0@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-06-23 at 11:29 +0200, Hans Verkuil wrote:
> On 06/08/17 10:55, Philipp Zabel wrote:
> > From: Lucas Stach <l.stach@pengutronix.de>
> > 
> > This implements a simple handler for the case where decode did not finish
> > successfully. This might be helpful during normal streaming, but for now it
> > only handles the case where the context would deadlock with userspace,
> > i.e. userspace issued DEC_CMD_STOP and waits for EOS, but after the failed
> > decode run we would hold the context and wait for userspace to queue more
> > buffers.
> > 
> > Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> > Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> > [p.zabel@pengutronix.de: renamed error_decode/run to run/decode_timeout]
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v1 [1]:
> > - Rename error_run/decode callback to run/decode_timeout, as
> >   this error handler is called on device_run timeouts only.
> > 
> > [1] https://patchwork.linuxtv.org/patch/40603
> 
> It appears the v1 version was merged, not the v2. I'm not sure if the v2 version
> was posted after v1 was already merged, or if I missed this v2 series.
> 
> I'm marking this as Obsoleted, and if you want to still get these v2 changes
> in, then please post a new patch.
> 
> Sorry for the mix up,

Thank you for the heads up, I'll send a patch.

regards
Philipp
