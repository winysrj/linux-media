Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF33C282CA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C34222BA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 11:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfBMLEx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:04:53 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:49553 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfBMLEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 06:04:53 -0500
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 84F17240011;
        Wed, 13 Feb 2019 11:04:49 +0000 (UTC)
Message-ID: <e19f0821a831c45829c2921ab091b7c6ed80c8f5.camel@bootlin.com>
Subject: Re: [PATCH v3] media: docs-rst: Document m2m stateless video
 decoder interface
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 13 Feb 2019 12:04:49 +0100
In-Reply-To: <7caf9381-e920-f5fc-e8f9-a54ac2733add@xs4all.nl>
References: <20190213055317.192029-1-acourbot@chromium.org>
         <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
         <b24e3e67-9fb3-3602-8a90-826f8c51eadf@xs4all.nl>
         <3de0825971b91ea0b8fd349f4ecf8164de14254a.camel@bootlin.com>
         <7caf9381-e920-f5fc-e8f9-a54ac2733add@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2019-02-13 at 10:57 +0100, Hans Verkuil wrote:
> On 2/13/19 10:20 AM, Paul Kocialkowski wrote:
> > Hi,
> > 
> > On Wed, 2019-02-13 at 09:59 +0100, Hans Verkuil wrote:
> > > On 2/13/19 6:58 AM, Alexandre Courbot wrote:
> > > > On Wed, Feb 13, 2019 at 2:53 PM Alexandre Courbot <acourbot@chromium.org> wrote:
> > > > > [snip]
> > > > > +Buffers used as reference frames can be queued back to the ``CAPTURE`` queue as
> > > > > +soon as all the frames they are affecting have been queued to the ``OUTPUT``
> > > > > +queue. The driver will refrain from using the reference buffer as a decoding
> > > > > +target until all the frames depending on it are decoded.
> > > > 
> > > > Just want to highlight this part in order to make sure that this is
> > > > indeed what we agreed on. The recent changes to vb2_find_timestamp()
> > > > suggest this, but maybe I misunderstood the intent. It makes the
> > > > kernel responsible for tracking referenced buffers and not using them
> > > > until all the dependent frames are decoded, something the client could
> > > > also do.
> > > 
> > > I don't think this is quite right. Once this patch https://patchwork.linuxtv.org/patch/54275/
> > > is in the vb2 core will track when a buffer can no longer be used as a
> > > reference buffer because the underlying memory might have disappeared.
> > > 
> > > The core does not check if it makes sense to use a buffer as a reference
> > > frame, just that it is valid memory.
> > > 
> > > So the driver has to check that the timestamp refers to an existing
> > > buffer, but userspace has to check that it queues everything in the
> > > right order and that the reference buffer won't be overwritten
> > > before the last output buffer using that reference buffer has been
> > > decoded.
> > > 
> > > So I would say that the second sentence in your paragraph is wrong.
> > > 
> > > The first sentence isn't quite right either, but I am not really sure how
> > > to phrase it. It is possible to queue a reference buffer even if
> > > not all output buffers referring to it have been decoded, provided
> > > that by the time the driver starts to use this buffer this actually
> > > has happened.
> > 
> > Is there a way we can guarantee this? Looking at the rest of the spec,
> > it says that capture buffers "are returned in decode order" but that
> > doesn't imply that they are picked up in the order they are queued.
> > 
> > It seems quite troublesome for the core to check whether each queued
> > capture buffer is used as a reference for one of the queued requests to
> > decide whether to pick it up or not.
> 
> The core only checks that the timestamp points to a valid buffer.
> 
> It is not up to the core or the driver to do anything else. If userspace
> gives a reference to a wrong buffer or one that is already overwritten,
> then you just get bad decoded video, but nothing crashes.

Yes, that makes sense. My concern was mainly about cases where the
capture buffers could be consumed by the driver in a different order
than they are queued by userspace (which could lead to the reference
buffer being reused too early). But thinking about it twice, I don't
see a reason why this could happen.

> > > But this is an optimization and theoretically it can depend on the
> > > driver behavior. It is always safe to only queue a reference frame
> > > when all frames depending on it have been decoded. So I am leaning
> > > towards not complicating matters and keeping your first sentence
> > > as-is.
> > 
> > Yes, I believe it would be much simpler to require userspace to only
> > queue capture buffers once they are no longer needed as references.
> 
> I think that's what we should document, but in cases where you know
> the hardware (i.e. an embedded system) it should be allowed to optimize
> and have the application queue a capture buffer containing a reference
> frame even if it is still in use by already queued output buffers.
> 
> That way you can achieve optimal speed and memory usage.
> 
> I think this is a desirable feature.

Yes, definitely.

> > This also means that the dmabuf fd can't be changed so we are
> > guaranteed that memory will still be there.
> 
> This is easy enough to check for, so I rather have some checks in
> the core for this than prohibiting optimizing the decoder memory
> usage.

Cheers,

Paul

-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

