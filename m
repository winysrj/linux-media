Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:36112 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbbE0TOS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 15:14:18 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH 0/4] media: pxa_camera conversion to dmaengine
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
Date: Wed, 27 May 2015 21:12:52 +0200
In-Reply-To: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Sun, 22 Mar 2015 00:21:20 +0100")
Message-ID: <87oal5zvez.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Hi Guennadi,
>
> I've been cooking this since 2012. At that time, I thought the dmaengine API was
> not rich enough to support the pxa_camera subtleties (or complexity).
>
> I was wrong. I submitted a driver to Vinod for a dma pxa driver which would
> support everything needed to make pxa_camera work normally.
>
> As a consequence, I wrote this serie. Should the pxa-dma driver be accepted,
> then this serie will be my next move towards pxa conversion to dmaengine. And to
> parallelize the review work, I'll submit it right away to receive a review and
> fix pxa_camera so that it is ready by the time pxa-dma is also reviewed.
>
> Happy review.
>
> --
> Robert
>
> Robert Jarzmik (4):
>   media: pxa_camera: fix the buffer free path
>   media: pxa_camera: move interrupt to tasklet
>   media: pxa_camera: trivial move of dma irq functions
>   media: pxa_camera: conversion to dmaengine
>
>  drivers/media/platform/soc_camera/pxa_camera.c | 518 +++++++++++++------------
>  1 file changed, 266 insertions(+), 252 deletions(-)

Hi Guennadi,

Any update on this serie ? The pxa-dma driver is upstreamed now.

Cheers.

-- 
Robert
