Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51AAC04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 07:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2D920811
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 07:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544601540;
	bh=IYk/K4LrzuKx/M7dmQTz9RZBwVWhIoQsjGRrt9apfxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=kmeXF/9dx6AFsTPg+ZAsZvj3yuWP3SG4J8iiWR2Cw5p1k4we7NpmFrxnj3JhMzoyC
	 P8Ncw6UD5ettv4q2L83fctLIyA1C9a1ek2gJQ239w1FlmCfmcX4pGpx1z7FlcLqQ+q
	 beF4ak0qWBmmWnQyOhw8XkGiuD3X6qEtNVOglmBY=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA2D920811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbeLLH67 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:58:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:53264 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbeLLH67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 02:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nvVJdgw51dCFxMDamuyXBopGwZyIM5/NW8cdZZ+Em7Q=; b=n2isnFf5Q9nID6HUVPWIvk4yoo
        dRGooq3s1QSmgqfW3tiVq2ChQ7OU8AzZRFsTdlYM/W+OgIoTYwJRdrvBT2+97Q95F/75odJX0ciPC
        54+64v1WLCR7UNWaMaFj2gekQ/hcsUmHR8MIyqVGNpha8Vmh1T3yjHtOsJU51tWMQeqFEfhnnT5z2
        CZGqyNRjukgWMmZ6PKzWrivZBVtkqnjxNDJ4KhFXZDQNj4K+81RvekGe8++MyNfYPqo6Rd7Jw0nMF
        NVgPz7IyPZH3J8h4im5KdYl9u0bThM3hCSdlV5qaphDuEWd75+RpPAYWYYrzL5J40fL8aIXu9zTOp
        pn878/Cw==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gWzQ1-00058j-TC; Wed, 12 Dec 2018 07:58:58 +0000
Date:   Wed, 12 Dec 2018 05:58:54 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org
Subject: Re: [RFCv4 PATCH 0/3] This RFC patch series implements properties
 for the media controller.
Message-ID: <20181212055854.0a92c404@coco.lan>
In-Reply-To: <20181121154024.13906-1-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Em Wed, 21 Nov 2018 16:40:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The main changes since RFCv3 are:
> 
> - Add entity index to media_v2_pad
> - Add source/sink pad index to media_v2_link
> - Add owner_idx and owner type flags to media_v2_prop

Sorry, but I didn't get why this is needed for properties to work
(if the changes are not directly related to properties, please add
on separate patches, in order to make easier for review/understanding).

The lack of an uAPI documentation at the patchset makes it harder
to understand.

For the last one, you added a documentation at kAPI:

> + * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
> + *		type.

But it doesn't really explain anything. Is it the new owner_id
field? Is it something else? Why do we need bot owner_id and 
owner_idx?

> 
> An updated v4l2-ctl and v4l2-compliance that can report properties
> is available here:
> 
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
> 
> Currently I support u64, s64 and const char * property types. And also
> a 'group' type that groups sub-properties. But it can be extended to any
> type including binary data if needed. No array support (as we have for
> controls), but there are enough reserved fields in media_v2_prop
> to add this if needed.
> 
> I added properties for entities and pads to vimc, so I could test this.
> 
> Note that the changes to media_device_get_topology() are hard to read
> from the patch. It is easier to just look at the source code:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/media/media-device.c?h=mc-props
> 
> I have some ideas to improve this some more:
> 
> 1) Add the properties directly to media_gobj. This would simplify some
>    of the code, but it would require a media_gobj_init function to
>    initialize the property list. In general I am a bit unhappy about
>    media_gobj_create: it doesn't really create the graph object, instead
>    it just adds it to the media_device. It's confusing and it is something
>    I would like to change.
> 
> 2) The links between pads are stored in media_entity instead of in media_pad.
>    This is a bit unexpected and makes it harder to traverse the data
>    structures since to find the links for a pad you need to walk the entity
>    links and find the links for that pad. Putting all links in the entity
>    also mixes up pad and interface links, and it would be much cleaner if
>    those are separated.
> 
> 3) I still think adding support for backlinks to G_TOPOLOGY is a good idea.
>    Since the current data structure represents a flattened tree that is easy
>    to navigate the only thing missing for userspace is backlink support.
>    This is still something that userspace needs to figure out when the kernel
>    has this readily available. I think that with this in place applications
>    can just do all the lookups directly on the topology data structure.

Apps don't need to follow the exact data struct model as the Kernel,
and can dynamically create any indexes they need in order to quickly
seek for a link (if search performance would be a problem).

I don't like the idea of reporting all links twice to userspace. 
Specially after Spectre/Meltdown, context switches are expensive.

Duplicating data is a very bad idea, as it will enforce an specific
data model at the application and at userspace. We want to be able
to change the internals (on both sides) if needed for whatever
reason. 

Also, what happens if the duplicated information is not really
the same (that could happen due to a bug somewhere)? Should
apps validate it? Worse than that, if we report the same link
twice (on both directions), userspace will send link changes
at the backlinks, making the Kernel code more complex (and
bound forever to an specific implementation) for no good reason.

> 
> 1+2 are internal cleanups that can be done later.
> 
> 3 is a low-priority future enhancement. This might become easier to implement
> once 1+2 are done.
> 
> This is pretty much the last RFC. If everyone agree with this approach, then
> I can make a final patch series, adding documentation etc.
> 
> Regards,
> 
>         Hans
> 
> 
> Hans Verkuil (3):
>   uapi/linux/media.h: add property support
>   media controller: add properties support
>   vimc: add property test code
> 
>  drivers/media/media-device.c              | 335 +++++++++++++++++-----
>  drivers/media/media-entity.c              | 107 ++++++-
>  drivers/media/platform/vimc/vimc-common.c |  50 ++++
>  include/media/media-device.h              |   6 +
>  include/media/media-entity.h              | 318 ++++++++++++++++++++
>  include/uapi/linux/media.h                |  88 +++++-
>  6 files changed, 819 insertions(+), 85 deletions(-)
> 



Thanks,
Mauro
