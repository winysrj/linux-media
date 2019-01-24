Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37487C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02AC921855
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfAXMlC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 07:41:02 -0500
Received: from mail.bootlin.com ([62.4.15.54]:36769 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfAXMlC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 07:41:02 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 602812078C; Thu, 24 Jan 2019 13:40:59 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id F1FF82074E;
        Thu, 24 Jan 2019 13:40:58 +0100 (CET)
Message-ID: <45abf365151956ca8d0a746791fdb8cc09fd5c48.camel@bootlin.com>
Subject: Re: [PATCH] Revert "media: cedrus: Allow using the current dst
 buffer as reference"
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Thu, 24 Jan 2019 13:40:59 +0100
In-Reply-To: <20190124103226.GA20129@kroah.com>
References: <20190124095542.22321-1-paul.kocialkowski@bootlin.com>
         <20190124103226.GA20129@kroah.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Thu, 2019-01-24 at 11:32 +0100, Greg KH wrote:
> On Thu, Jan 24, 2019 at 10:55:42AM +0100, Paul Kocialkowski wrote:
> > This reverts commit cf20ae1535eb690a87c29b9cc7af51881384e967.
> > 
> > The vb2_find_timestamp helper was modified to allow finding buffers
> > regardless of their current state in the queue. This means that we
> > no longer have to take particular care of references to the current
> > capture buffer.
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
> >  drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
> >  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
> >  3 files changed, 4 insertions(+), 21 deletions(-)
> 
> No signed-off-by?  :(

Woops, sorry about that. Will fix in v2!

Cheers,

Paul

-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

