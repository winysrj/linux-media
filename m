Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1BDKaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 05:30:02 -0500
Date: Fri, 4 Feb 2011 10:29:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] arm: omap3evm: Add support for an MT9M032 based
	camera board.
Message-ID: <20110204102943.GC15004@n2100.arm.linux.org.uk>
References: <1295389936-3238-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295389936-3238-1-git-send-email-martin@neutronstar.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 18, 2011 at 11:32:16PM +0100, Martin Hostettler wrote:
> +#include <asm/gpio.h>

Please use linux/gpio.h in future.
