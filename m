Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33688 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760659AbaCULVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 07:21:35 -0400
Date: Fri, 21 Mar 2014 11:21:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/6] drm/i2c: Move tda998x to a couple
	encoder/connector
Message-ID: <20140321112118.GH7528@n2100.arm.linux.org.uk>
References: <cover.1395397665.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1395397665.git.moinejf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 21, 2014 at 11:27:45AM +0100, Jean-Francois Moine wrote:
> The 'slave encoder' structure of the tda998x driver asks for glue
> between the DRM driver and the encoder/connector structures.

Given how close we are to the coming merge window, that the discussion
about the of-graph bindings is still going on without concensus being
reached, and that this driver is not in staging, this needs to be
delayed until the following merge window when hopefully we have a
clearer picture about the DT side of this.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
