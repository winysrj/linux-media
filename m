Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8ED1C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 894C92081B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 894C92081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbeLEM4V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:56:21 -0500
Received: from mail.bootlin.com ([62.4.15.54]:52267 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbeLEM4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 07:56:21 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 9A41520784; Wed,  5 Dec 2018 13:56:19 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id AA1C420CC5;
        Wed,  5 Dec 2018 13:56:05 +0100 (CET)
Message-ID: <d879761d8c36d8bbefe6da3638f6c3330119cddb.camel@bootlin.com>
Subject: Re: [PATCH for v4.20 0/2] cedrus: move MPEG controls out of the uAPI
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc:     maxime.ripard@bootlin.com
Date:   Wed, 05 Dec 2018 13:56:06 +0100
In-Reply-To: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
References: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2018-12-05 at 13:09 +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The expectation was that the MPEG-2 state controls used by the staging
> cedrus driver were stable, or would only require one final change. However,
> it turns out that more changes are required, and that means that it is not
> such a good idea to have these controls in the public kernel API.
> 
> This patch series moves all the MPEG-2 state control data to a new
> media/mpeg2-ctrls.h header. So none of this is available from the public
> API.
> 
> However, v4l2-ctrls.h includes it for now so the kAPI still knows about it
> allowing the cedrus driver to use it without changes.
> 
> The second patch adds a note to these two controls, mentioning that they
> are likely to change.
> 
> Moving forward, this allows us to take more time in getting the MPEG-2
> (and later H264/5) state controls right.

Thanks a lot for this change, I'm glad we can take time to properly
stabilize these controls!

For the whole series:
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Regards,
> 
> 	Hans
> 
> Hans Verkuil (2):
>   mpeg2-ctrls.h: move MPEG2 state controls to non-public header
>   extended-controls.rst: add note to the MPEG2 state controls
> 
>  .../media/uapi/v4l/extended-controls.rst      | 10 +++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  4 +-
>  include/media/mpeg2-ctrls.h                   | 86 +++++++++++++++++++
>  include/media/v4l2-ctrls.h                    |  6 ++
>  include/uapi/linux/v4l2-controls.h            | 68 ---------------
>  include/uapi/linux/videodev2.h                |  4 -
>  6 files changed, 104 insertions(+), 74 deletions(-)
>  create mode 100644 include/media/mpeg2-ctrls.h
> 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

