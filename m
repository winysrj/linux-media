Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:29889 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbGLRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 13:36:01 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] media: pxa_camera: conversion to dmaengine
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
	<1436120872-24484-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1507121859030.32193@axis700.grange>
Date: Sun, 12 Jul 2015 19:33:09 +0200
In-Reply-To: <Pine.LNX.4.64.1507121859030.32193@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 12 Jul 2015 19:05:49 +0200 (CEST)")
Message-ID: <87y4iljn6y.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>>  		/* init DMA for Y channel */
>
> How about taking the loop over the sg list out of pxa_init_dma_channel() 
> to avoid having to iterate it from the beginning each time? Then you would 
> be able to split it into channels inside that global loop? Would that 
> work? Of course you might need to rearrange functions to avoid too deep 
> code nesting.

Ok, will try that.
The more I think of it, the more it looks to me like a generic thing : take an
sglist, and an array of sizes, and split the sglist into several sglists, each
of the defined size in the array.

Or more code-like speaking :
  - sglist_split(struct scatterlist *sg_int, size_t *sizes, int nb_sizes,
                 struct scatterlist **sg_out)
  - and sg_out is an array of nb_sizes (struct scatterlist *sg)

So I will try that out. Maybe if that works out for pxa_camera, Jens or Russell
would accept that into lib/scatterlist.c.

Cheers.

--
Robert
