Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36345 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3DVO2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:28:54 -0400
Date: Mon, 22 Apr 2013 15:28:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC v2] video: ARM CLCD: Add DT & CDF support
Message-ID: <20130422142845.GO14496@n2100.arm.linux.org.uk>
References: <20130418102444.GL14496@n2100.arm.linux.org.uk> <1366306402-21651-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366306402-21651-1-git-send-email-pawel.moll@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 18, 2013 at 06:33:21PM +0100, Pawel Moll wrote:
> This patch adds basic DT bindings for the PL11x CLCD cells
> and make their fbdev driver use them, together with the
> Common Display Framework.
> 
> The DT provides information about the hardware configuration
> and limitations (eg. the largest supported resolution)
> but the video modes come exclusively from the Common
> Display Framework drivers, referenced to by the standard CDF
> binding.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Much better.

I will point out though that there be all sorts of worms here when you
come to the previous ARM evaluation boards (which is why the capabilities
stuff got written in the first place) where there's a horrid mixture of
BGR/RGB ordering at various levels of the system - some of which must be
set correctly because the CLCD output isn't strictly used as R bits
G bits and B bits (to support different formats from the CLCD's native
formats.)
