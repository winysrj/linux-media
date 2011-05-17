Return-path: <mchehab@pedra>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37934 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab1EQWqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 18:46:44 -0400
Date: Tue, 17 May 2011 23:46:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com,
	stern@rowland.harvard.edu, rjw@sisk.pl
Subject: Re: [PATCH 3/3 v5] v4l: Add v4l2 subdev driver for S5P/EXYNOS4
	MIPI-CSI receivers
Message-ID: <20110517224640.GA30588@sirena.org.uk>
References: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com> <201105141729.58363.laurent.pinchart@ideasonboard.com> <4DCF9DDA.4060600@gmail.com> <201105152310.07178.laurent.pinchart@ideasonboard.com> <4DD2D53F.8020403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2D53F.8020403@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 17, 2011 at 10:06:23PM +0200, Sylwester Nawrocki wrote:

> As we have I2C, SPI and platform device v4l subdevs ideally those buses should
> support Runtime PM.

They all do so.
