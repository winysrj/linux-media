Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33755 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751575AbdKVKkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 05:40:03 -0500
Message-ID: <1511347200.17007.1.camel@pengutronix.de>
Subject: Re: media: coda: sources of coda_regs.h?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>
Cc: linux-media@vger.kernel.org
Date: Wed, 22 Nov 2017 11:40:00 +0100
In-Reply-To: <15f29890-d029-95a3-c00d-73ed566ff172@posteo.de>
References: <15f29890-d029-95a3-c00d-73ed566ff172@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Thu, 2017-11-09 at 23:14 +0100, Martin Kepplinger wrote:
> Hi Philipp,
> 
> As I'm reading up on the coda driver a little, I can't seem to find the
> vendor's sources for the coda_regs.h definitions. Could you point me to
> them?

I don't know for sure what information Javier based the CodaDx6 register
names on, but I assume that he used the old LGPLed i.MX VPU libraries
that Freescale once distributed. At least that's what I looked at for
the CODA960 additions: The BSP "L3.0.35_12.09.01.01_GA_source.tar.gz"
contained a tarball "pkgs/imx-lib-12.09.01.tar.gz" with a header file
"imx-lib-12.09.01/vpu/vpu_reg.h" inside. I believe the current BSP
versions distributed by NXP do not include this library anymore.

regards
Philipp
