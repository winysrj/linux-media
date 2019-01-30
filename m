Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C572C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5F920855
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbfA3O5K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:57:10 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39514 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3O5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 09:57:10 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id DCB2627DD0A
Message-ID: <755a24c6fd7ccc34f3d3ccda8caa1dda715241ea.camel@collabora.com>
Subject: Re: [PATCH 2/3] media: vim2m: use per-file handler work queue
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Anton Leontiev <scileont@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Wed, 30 Jan 2019 11:56:58 -0300
In-Reply-To: <20190130111933.313ed5a0@silica.lan>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
         <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
         <0f25ab2f936e3fcb8cd68b55682838027e46eec5.camel@collabora.com>
         <20190130111933.313ed5a0@silica.lan>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hey Mauro,

On Wed, 2019-01-30 at 11:19 -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 30 Jan 2019 09:41:44 -0300
> Ezequiel Garcia <ezequiel@collabora.com> escreveu:
> 
> > On Tue, 2019-01-29 at 14:00 -0200, Mauro Carvalho Chehab wrote:
> > > It doesn't make sense to have a per-device work queue, as the
> > > scheduler should be called per file handler. Having a single
> > > one causes failures if multiple streams are filtered by vim2m.
> > >   
> > 
> > Having a per-device workqueue should emulate a real device more closely.
> 
> Yes.
> 
> > But more importantly, why would having a single workqeueue fail if multiple
> > streams are run? The m2m should take care of the proper serialization
> > between multiple contexts, unless I am missing something here.
> 
> Yes, the m2m core serializes the access to m2m src/dest buffer per device.
> 
> So, two instances can't access the buffer at the same time. That makes
> sense for a real physical hardware, although specifically for the virtual
> one, it doesn't (any may not make sense for some stateless codec, if
> the codec would internally be able to handle multiple requests at the same
> time).
> 
> Without this patch, when multiple instances are used, sometimes it ends 
> into a dead lock preventing to stop all of them.
> 
> I didn't have time to debug where exactly it happens, but I suspect that
> the issue is related to using the same mutex for both VB and open/release
> instances.
> 
> Yet, I ended by opting to move all queue-specific mutex/semaphore to be
> instance-based, as this makes a lot more sense, IMHO. Also, if some day
> we end by allowing support for some hardware that would have support to
> run multiple m2m instances in parallel, vim2m would already be ready.
> 

I don't oppose to the idea of having a per-context workqueue.

However, I'm not too comfortable with having a bug somewhere (and not knowing
whert) and instead of fixing it, working around it. I'd rather
fix the bug instead, then decide about the workqueue.

Thanks,
Eze

