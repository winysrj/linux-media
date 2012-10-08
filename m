Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:38959 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2JHUMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 16:12:38 -0400
Message-ID: <507333B2.60109@wwwdotorg.org>
Date: Mon, 08 Oct 2012 14:12:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2012 08:07 AM, Guennadi Liakhovetski wrote:
> This patch adds a document, describing common V4L2 device tree bindings.
> 
> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I think this looks reasonable now, touch wood:-) I guess I won't ack the
binding until the v4l2 -> something-generic rename happens, but I don't
see anything stopping me from doing so once the rename happens.
