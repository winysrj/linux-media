Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56637 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1KWPTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 10:19:51 -0500
Received: by eaak14 with SMTP id k14so23565eaa.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 07:19:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322061227-6631-3-git-send-email-javier.martin@vista-silicon.com>
References: <1322061227-6631-1-git-send-email-javier.martin@vista-silicon.com>
	<1322061227-6631-3-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 23 Nov 2011 13:19:49 -0200
Message-ID: <CAOMZO5AEZZEYSMXtXwCw4Qx9sY5hzZmd7t7b4teROntskBmbVQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
From: Fabio Estevam <festevam@gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Javier,

On Wed, Nov 23, 2011 at 1:13 PM, Javier Martin
<javier.martin@vista-silicon.com> wrote:
> Changes since v2:
> - Use devres to simplify error handling.
> - Remove unused structures.
> - Fix clock handling.
> - Other minor problems.

It would be better if you put such comments below the --- line.

For the commit message you can use the one you did for the cover
letter (0/2) patch:

"i.MX2x SoCs have a PrP which is capable of resizing and format
conversion of video frames. This driver provides support for
resizing and format conversion from YUYV to YUV420.

This operation is of the utmost importance since some of these
SoCs like i.MX27 include an H.264 video codec which only
accepts YUV420 as input."
