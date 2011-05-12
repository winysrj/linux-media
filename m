Return-path: <mchehab@gaivota>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52609 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1ELHrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 03:47:41 -0400
Date: Thu, 12 May 2011 08:47:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	lars.haring@atmel.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
	support
Message-ID: <20110512074725.GA1356@n2100.arm.linux.org.uk>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
> +err_alloc_isi:
> +	clk_disable(pclk);

clk_put() ?
