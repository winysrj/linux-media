Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:50339 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761713AbcALBUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 20:20:49 -0500
Date: Tue, 12 Jan 2016 10:20:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] media: soc_camera: rcar_vin: Add rcar fallback
 compatibility string
Message-ID: <20160112012045.GE3860@verge.net.au>
References: <1452539418-28480-1-git-send-email-ykaneko0929@gmail.com>
 <1452539418-28480-2-git-send-email-ykaneko0929@gmail.com>
 <Pine.LNX.4.64.1601112210040.31467@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1601112210040.31467@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Jan 11, 2016 at 10:13:30PM +0100, Guennadi Liakhovetski wrote:
> Hello Kaneko-san,
> 
> On Tue, 12 Jan 2016, Yoshihiro Kaneko wrote:
> 
> > Add fallback compatibility string for R-Car Gen2 and Gen3, This is
> > in keeping with the fallback scheme being adopted wherever appropriate
> > for drivers for Renesas SoCs.
> > 
> > Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> > ---
> 
> Have you seen this patch:
> 
> http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commit/?h=for-4.6-1&id=8e7825d38bbfcf8af8b0422c88f5e22701d89786
> 
> that I pushed yesterday? Is it wrong then? Do we have to cancel it, if
> Mauro hasn't pulled it yet? Or would you like to rebase and work on top of
> it?

Sorry about this. There are multiple threads of execution going on
regarding enhancing drivers used by Renesas SoCs and sometimes things
get a little mixed up: this is one of those times.

My opinion is that the patch at the URL above is fine and
that it would be best for Kaneko-san to rebase his work on top of it.
