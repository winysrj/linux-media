Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38743 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751332AbdJEPpo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 11:45:44 -0400
Message-ID: <1507218340.8473.19.camel@pengutronix.de>
Subject: Re: platform: coda: how to use firmware-imx binary releases?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Date: Thu, 05 Oct 2017 17:45:40 +0200
In-Reply-To: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-10-04 at 10:44 +0200, Martin Kepplinger wrote:
> Hi,
> 
> Commit
> 
>      be7f1ab26f42 media: coda: mark CODA960 firmware versions 2.3.10
> and 
> 3.1.1 as supported
> 
> says firmware version 3.1.1 revision 46072 is contained in 
> "firmware-imx-5.4.bin", that's probably
> 
>      sha1  78a416ae88ff01420260205ce1d567f60af6847e  firmware-imx-
> 5.4.bin
> 
> How do I use this in order to get a VPU firmware blob that the coda 
> platform driver can work with?
> 
> 
> 
> (Maybe it'd be worth adding some short documentation on this. There 
> doesn't seem to be a devicetree bindings doc for coda in 
> Documentation/devicetree/bindings/media 

I was mistaken, Documentation/devicetree/bindings/media/coda.txt exists.
It was added in commit 657eee7d25fb ("media: coda: use genalloc API").

regards
Philipp
