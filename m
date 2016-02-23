Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbcBWTuh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 14:50:37 -0500
Date: Tue, 23 Feb 2016 13:50:32 -0600
From: Rob Herring <robh@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devicetree@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Revert "[media] tvp5150: document input connectors DT
 bindings"
Message-ID: <20160223195032.GA21259@rob-hp-laptop>
References: <1456253288-397-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1456253288-397-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2016 at 03:48:08PM -0300, Javier Martinez Canillas wrote:
> This reverts commit 82c2ffeb217a ("[media] tvp5150: document input
> connectors DT bindings") since the DT binding is too device driver
> specific and should instead be more generic and use the bindings
> in Documentation/devicetree/bindings/display/connector/ and linked
> to the tvp5150 using the OF graph port and endpoints.
> 
> There are still ongoing discussions about how the input connectors
> will be supported by the Media Controller framework so until that
> is settled, it is better to revert the connectors portion of the
> bindings to avoid known to be broken bindings docs to hit mainline.
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 43 ----------------------
>  1 file changed, 43 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
