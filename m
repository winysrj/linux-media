Return-path: <mchehab@pedra>
Received: from linux-sh.org ([111.68.239.195]:60465 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647Ab1CWN7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 09:59:33 -0400
Date: Wed, 23 Mar 2011 22:59:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ARM: mach-shmobile: add coherent DMA mask to CEU camera devices
Message-ID: <20110323135928.GB4010@linux-sh.org>
References: <Pine.LNX.4.64.1103231025560.6836@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103231025560.6836@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 23, 2011 at 10:29:16AM +0100, Guennadi Liakhovetski wrote:
> Cameras are currently broken on ARM sh-mobile platforms. They need a
> suitable coherent DMA mask.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Applied, thanks.
