Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65181 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3JSTDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Oct 2013 15:03:39 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so4998129wgh.25
        for <linux-media@vger.kernel.org>; Sat, 19 Oct 2013 12:03:38 -0700 (PDT)
Message-ID: <5262D787.50807@gmail.com>
Date: Sat, 19 Oct 2013 21:03:35 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] v4l: vb2-dma-contig: add support for file access
 mode flags for DMABUF exporting
References: <1369123895-10574-1-git-send-email-p.zabel@pengutronix.de>  <52303E57.8070102@samsung.com> <1381226795.4013.16.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1381226795.4013.16.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 10/08/2013 12:06 PM, Philipp Zabel wrote:
> Ping?
>
> This patch is needed to map videobuf2 exported dmabuf fds writeable from
> userspace, for example for timestamp software rendering into frames
> passing from a v4l2 capture device to a v4l2 output device.

I have added this patch to my tree for v3.13.

Thanks,
Sylwester
