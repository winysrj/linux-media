Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA504C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 16:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB2D20684
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 16:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfCGQHl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:07:41 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37396 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726161AbfCGQHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 11:07:40 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 9F982634C7B;
        Thu,  7 Mar 2019 18:06:31 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1h1vXU-0002ky-C9; Thu, 07 Mar 2019 18:06:32 +0200
Date:   Thu, 7 Mar 2019 18:06:32 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv2 7/9] v4l2-subdev: handle module refcounting here
Message-ID: <20190307160632.zjd2uohsnusvciop@valkosipuli.retiisi.org.uk>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-8-hverkuil-cisco@xs4all.nl>
 <20190305195214.GH14928@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305195214.GH14928@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent, Hans,

On Tue, Mar 05, 2019 at 09:52:14PM +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> (CC'ing Sakari)
> 
> Thank you for the patch.
> 
> On Tue, Mar 05, 2019 at 10:58:45AM +0100, hverkuil-cisco@xs4all.nl wrote:
> > From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > 
> > The module ownership refcounting was done in media_entity_get/put,
> > but that was very confusing and it did not work either in case an
> > application had a v4l-subdevX device open and the module was
> > unbound. When the v4l-subdevX device was closed the media_entity_put
> > was never called and the module refcount was left one too high, making
> > it impossible to unload it.

Hmm. This is not really a proper fix for the problem although it lets you
unload the module in the case things got horribly wrong. Instead the media
device may not be allowed to disappear while it is being accessed
elsewhere.

I think that the merit of this patch is cleaning the code, not really
fixing a bug. But keeping the owner you can't access later because you've
released the memory isn't neat either.

How about adding a comment next to the owner field, e.g. "TODO: address
refcounting properly"?

> > 
> > Since v4l2-subdev.c was the only place where media_entity_get/put was
> > called, just move the functionality to v4l2-subdev.c and drop those
> > confusing entity functions.
> 
> I wonder if we will later need to refcount media entities, but we can
> reintroduce a different version of those two functions then, it doesn't
> prevent their removal now.

I agree.

> 
> Sakari, when working on lifetime management of objects in the media and
> V4L2 core, did you come across a need to refcount entities ?

We will need to do that to allow removing entities safely. The current
patchset only deals with the media device and it's stille pending on DVB
framework issues.

-- 
Regards,

Sakari Ailus
