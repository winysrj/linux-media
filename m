Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:49340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1E0Ntw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 09:49:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Fri, 27 May 2011 15:49:45 +0200
Cc: mchehab@redhat.com, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, lars.haring@atmel.com,
	ryan@bluewatersys.com, plagnioj@jcrosoft.com
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271549.46099.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 27 May 2011, Josh Wu wrote:
> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Looks good to me now.

Acked-by: Arnd Bergmann <arnd@arndb.de>
