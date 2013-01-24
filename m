Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45730 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3AXAPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 19:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130123091202.GA11828@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
	<CAF6AEGvFNA1gc_5XWqL_baEnn8DTn0R-xqui034rg3Eo-V_6Qw@mail.gmail.com>
	<20130123091202.GA11828@pengutronix.de>
Date: Thu, 24 Jan 2013 10:15:54 +1000
Message-ID: <CAPM=9txadRcm4j7_GryvxgosEhF8S3-1rGxqR_bw8UXMaoVWug@mail.gmail.com>
Subject: Re: [PATCH v16 RESEND 0/7] of: add display helper
From: Dave Airlie <airlied@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Rob Clark <robdclark@gmail.com>,
	devicetree-discuss@lists.ozlabs.org,
	David Airlie <airlied@linux.ie>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> > Hi!
>> >
>> > There was still no maintainer, that commented, ack'd, nack'd, apply'd the
>> > series. So, this is just a resend.
>> > The patches were tested with:
>> >
>> >         - v15 on Tegra by Thierry
>> >         - sh-mobile-lcdcfb by Laurent
>> >         - MX53QSB by Marek
>> >         - Exynos: smdk5250 by Leela
>> >         - AM335X EVM & AM335X EVM-SK by Afzal
>> >         - imx6q: sabrelite, sabresd by Philipp and me
>> >         - imx53: tqma53/mba53 by me
>>
>>
>> btw, you can add my tested-by for this series..  I've been using them
>> for the tilcdc lcd-panel output driver support.
>>
>
> Thanks. The more drivers the merrier ;-)
>

I'll probably merge these via my tree for lack of anyone else doing
it. I just don't want to end up as the fbdev maintainer by default,
maybe if we move the console stuff out of drivers/video to somewhere
else I'd be willing to look after it, but the thought of maintaining
fbdev drivers would drive me to a liver transplant.

Dave.
