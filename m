Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43186 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbZJEC0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 22:26:25 -0400
Date: Mon, 5 Oct 2009 11:25:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] SH: add support for the RJ54N1CB0C camera for the kfr2r09 platform
Message-ID: <20091005022500.GD3185@linux-sh.org>
References: <Pine.LNX.4.64.0910031319320.5857@axis700.grange> <Pine.LNX.4.64.0910031320170.5857@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910031320170.5857@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 03, 2009 at 01:21:30PM +0200, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  arch/sh/boards/mach-kfr2r09/setup.c |  139 +++++++++++++++++++++++++++++++++++
>  1 files changed, 139 insertions(+), 0 deletions(-)
> 
This seems to depend on the RJ54N1CB0C driver, so I'll queue this up
after that has been merged in the v4l tree. If it's available on a topic
branch upstream that isn't going to be rebased, then I can pull that in,
but this is not so critical either way.
