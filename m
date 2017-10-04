Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34763 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751161AbdJDJWr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 05:22:47 -0400
Message-ID: <1507108964.11691.6.camel@pengutronix.de>
Subject: Re: platform: coda: how to use firmware-imx binary releases?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Date: Wed, 04 Oct 2017 11:22:44 +0200
In-Reply-To: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wed, 2017-10-04 at 10:44 +0200, Martin Kepplinger wrote:
> Hi,
> 
> Commit
> 
>      be7f1ab26f42 media: coda: mark CODA960 firmware versions 2.3.10 and 3.1.1 as supported
> 
> says firmware version 3.1.1 revision 46072 is contained in 
> "firmware-imx-5.4.bin", that's probably
> 
>      sha1  78a416ae88ff01420260205ce1d567f60af6847e  firmware-imx-5.4.bin

Yes.

> How do I use this in order to get a VPU firmware blob that the coda 
> platform driver can work with?

These are self-extracting shell scripts with an attached compressed tar
archive. This particular file can be extracted by skipping the first
34087 bytes:

dd if=firmware-imx-5.4.bin bs=34087 skip=1 | tar xjv

> (Maybe it'd be worth adding some short documentation on this. There 
> doesn't seem to be a devicetree bindings doc for coda in 
> Documentation/devicetree/bindings/media which would
> be a good place for documenting how to use these binaries too)

Thank you for pointing this out, the device tree binding docs for coda
are indeed missing.
I'm not sure the device tree binding docs are the right place to
document driver and firmware though. For that, adding a coda.rst entry
to Documentation/media/v4l-drivers would probably be a better place.

regards
Philipp
