Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57926 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQP1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 11:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <1371236911-15131-15-git-send-email-g.liakhovetski@gmx.de>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de> <1371236911-15131-15-git-send-email-g.liakhovetski@gmx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 17 Jun 2013 20:57:16 +0530
Message-ID: <CA+V-a8u67RqLeQWs4iNHs7S9UXTBOFFw0wu+9hwndUBiwbHaMw@mail.gmail.com>
Subject: Re: [PATCH v11 14/21] V4L2: add temporary clock helpers
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Sat, Jun 15, 2013 at 12:38 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Typical video devices like camera sensors require an external clock source.
> Many such devices cannot even access their hardware registers without a
> running clock. These clock sources should be controlled by their consumers.
> This should be performed, using the generic clock framework. Unfortunately
> so far only very few systems have been ported to that framework. This patch
> adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> Platforms, adopting the clock API, should switch to using it. Eventually
> this temporary API should be removed.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
