Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbEZOod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 10:44:33 -0400
Date: Tue, 26 May 2015 07:44:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 03/13] serial: 8250_dma: Support for deferred probing
 when requesting DMA channels
Message-ID: <20150526144432.GA23156@kroah.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2015 at 04:25:58PM +0300, Peter Ujfalusi wrote:
> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
> channels. In case of error, return the error code we received including
> -EPROBE_DEFER

I think you typed the function name wrong here :(

