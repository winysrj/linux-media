Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37586 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759040Ab2CTMhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 08:37:31 -0400
Received: by eekc41 with SMTP id c41so3018695eek.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 05:37:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203200851300.20315@axis700.grange>
References: <1329761467-14417-1-git-send-email-festevam@gmail.com>
	<Pine.LNX.4.64.1202201916410.2836@axis700.grange>
	<CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
	<4F67E4FD.2070709@redhat.com>
	<Pine.LNX.4.64.1203200851300.20315@axis700.grange>
Date: Tue, 20 Mar 2012 09:37:29 -0300
Message-ID: <CAOMZO5CJHkb1JrAd+DYvYP-DrV6XsqO3wtoxJGe_s9sE1tQktw@mail.gmail.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 3/20/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Don't think so. vzalloc() is used in mx3_camera to allocate driver private
> data objects and are never used for DMA, so, it doesn't have any
> restrictions on contiguity, coherency, alignment etc.

Is this valid only for mx3_camera driver?

All other soc camera drivers use kzalloc.

What makes mx3_camera different in this respect?
