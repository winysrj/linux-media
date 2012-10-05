Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56367 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297Ab2JESpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 14:45:18 -0400
Date: Fri, 5 Oct 2012 19:45:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Message-ID: <20121005184514.GF4360@opensource.wolfsonmicro.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1210021142210.15778@axis700.grange>
 <506ABE40.9070504@samsung.com>
 <201210051241.52205.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
 <506F2763.6050808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506F2763.6050808@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 05, 2012 at 08:30:59PM +0200, Sylwester Nawrocki wrote:

> The deferred probing was introduced in Linux to resolve resource 
> inter-dependencies in case of FDT based booting AFAIK.

It's completely unrelated to FDT, it's a general issue.  There's no sane
way to use hacks like link ordering to resolve boot time dependencies -
start getting things like regulators connected to I2C or SPI controllers
which may also use GPIOs for some signals and may be parents for other
regulators and mapping out the dependency graph becomes unreasonably
complicated.  Deferred probing is designed to solve this problem by
working things out dynamically at runtime.
