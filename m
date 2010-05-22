Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55544 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0EVHqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 03:46:37 -0400
Date: Sat, 22 May 2010 16:46:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] SH: add Video Output Unit and AK8813 video encoder support on ecovec
Message-ID: <20100522074632.GC17814@linux-sh.org>
References: <Pine.LNX.4.64.1004211039220.5292@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1004211039220.5292@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 21, 2010 at 10:45:25AM +0200, Guennadi Liakhovetski wrote:
> Ecovec uses the AK8813 video envoder similarly to the ms7724se platform with
> the only difference, that on ecovec GPIOs are used for resetting and powering
> up and down the chip.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This patch extends the SuperH VOU / AK881x patch series: 
> http://thread.gmane.org/gmane.linux.ports.sh.devel/7751/focus=7753
> 
>  arch/sh/boards/mach-ecovec24/setup.c |   78 ++++++++++++++++++++++++++++++++++
>  1 files changed, 78 insertions(+), 0 deletions(-)
> 
Applied, thanks.
