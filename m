Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46729 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751952AbdGAPSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Jul 2017 11:18:04 -0400
Date: Sat, 1 Jul 2017 16:18:15 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Anton Sviridenko <anton@corp.bluecherry.net>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: fix detection of TW2864B chips
Message-ID: <20170701151814.GA31746@dell-m4800>
References: <20170701112558.GA18352@magpie-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170701112558.GA18352@magpie-gentoo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 01, 2017 at 03:26:01PM +0400, Anton Sviridenko wrote:
> This patch enables support for non-Bluecherry labeled solo6110
> based PCI cards which have 3 x TW2864B chips and one TW2865.
> These cards are displayed by lspci -nn as
> 
> "Softlogic Co., Ltd. SOLO6110 H.264 Video encoder/decoder [9413:6110]"
> 
> Bluecherry cards have 4 x TW2864A. According to datasheet register 0xFF
> of TW2864B chips contains value 0x6A or 0x6B depending on revision 
> which being shifted 3 bits right gives value 0x0d.
> Existing version of solo6x10 fails on these cards with
> 
> [276582.344942] solo6x10 0000:07:00.0: Probing Softlogic 6110
> [276582.402151] solo6x10 0000:07:00.0: Could not initialize any techwell chips
> [276582.402781] solo6x10: probe of 0000:07:00.0 failed with error -22
> 
> Signed-off-by: Anton Sviridenko <anton@corp.bluecherry.net>

Acked-by: Andrey Utkin <andrey_utkin@fastmail.com>

I have looked into same case long time ago, just haven't managed to
conclude.
