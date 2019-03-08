Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C7C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F90120684
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="E4xN7RaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfCHL04 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:26:56 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:53130 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfCHL04 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 06:26:56 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 260C7309;
        Fri,  8 Mar 2019 12:26:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552044414;
        bh=kvkLuZGlgKA7JWuXozLIz3UE1JGPA8ZSdEWGkO14DLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4xN7RaLu6EFg4KJpBp9+dmBwLus66a7AIc95FmwZ/ep5EkbKQ+A+XJmylOk6Mgif
         rt6x1e4bvRQ8XU0+BuT4qbQCJcmf+mw6HQOqjcylcoM9K5bpa3M0H6rPC2QVtqNDbN
         w+np6H1z4yuYfyncCAFNv7dWoeY/IEyEH00knCqo=
Date:   Fri, 8 Mar 2019 13:26:48 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv2 4/9] media-entity: set ent_enum->bmap to NULL after
 freeing it
Message-ID: <20190308112648.GD4802@pendragon.ideasonboard.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
 <20190305193913.GF14928@pendragon.ideasonboard.com>
 <8ea050d7-8827-9432-9737-3a704ea8cfe4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ea050d7-8827-9432-9737-3a704ea8cfe4@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Thu, Mar 07, 2019 at 10:23:03AM +0100, Hans Verkuil wrote:
> On 3/5/19 8:39 PM, Laurent Pinchart wrote:
> > On Tue, Mar 05, 2019 at 10:58:42AM +0100, hverkuil-cisco@xs4all.nl wrote:
> >> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> Ensure that this pointer is set to NULL after it is freed.
> >> The vimc driver has a static media_entity and after
> >> unbinding and rebinding the vimc device the media code will
> >> try to free this pointer again since it wasn't set to NULL.
> > 
> > I still think the problem lies in the vimc driver. Reusing static
> > structures is really asking for trouble. I'm however not opposed to
> > merging this patch, as you mentioned the problem will be fixed in vimc
> > too. I still wonder, though, if merging this couldn't make it easier for
> > drivers to do the wrong thing.
> 
> I'm keeping this patch :-)
> 
> I don't think that what vimc is doing is wrong in principle, just very unusual.

I disagree here. We've developed the media controller (and V4L2) core
code with many assumptions that structures are zeroed on allocation. For
the structures that are meant to be registered once only, the code
assumes, explicitly and implicitly, that some of the fields are zeroed.
Removing that assumption for the odd case of vimc will require you to
chase bugs for a long time. You've caught a few of the easier ones here,
I'm sure other will linger for a much longer time before they get fixed.
In the vimc case, the best option is to zero the structure manually if
you don't want to allocate it dynamically (and I think it should be
allocated dynamically).

For the record, I ran into a similar problem before when trying to
unregister and re-register a struct device. I reported what I considered
to be a bug, and Greg very clearly told me it was plain wrong. You will
run into similar issues due to the platform_device embedded in struct
vimc_device. Let's just allocate it dynamically.

> Also I think it makes the mc framework more robust by properly zeroing this
> pointer.

This patch is not wrong per-se, and I'm not opposed to it, but we should
fix issues in drivers, which would render this patch unneeded.

-- 
Regards,

Laurent Pinchart
