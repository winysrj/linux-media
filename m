Return-path: <mchehab@pedra>
Received: from 97.mail-out.ovh.net ([91.121.185.90]:55889 "EHLO
	97.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1FHVKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 17:10:36 -0400
Received: from mail185.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by 97.mail-out.ovh.net (Postfix) with SMTP id 0CA4E4A6A96
	for <linux-media@vger.kernel.org>; Wed,  8 Jun 2011 16:02:14 +0200 (CEST)
Date: Wed, 8 Jun 2011 15:48:32 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, lars.haring@atmel.com,
	ryan@bluewatersys.com, arnd@arndb.de
Subject: Re: [PATCH v4] [media] at91: add Atmel Image Sensor Interface
 (ISI) support
Message-ID: <20110608134832.GB17584@game.jcrosoft.org>
References: <1307497219-21496-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307497219-21496-1-git-send-email-josh.wu@atmel.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09:40 Wed 08 Jun     , Josh Wu wrote:
> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
looks fine
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
