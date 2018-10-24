Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46774 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbeJYCK6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 22:10:58 -0400
Date: Wed, 24 Oct 2018 12:41:58 -0500
From: Rob Herring <robh@kernel.org>
To: Luis Oliveira <luis.oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.pinto@synopsys.com, festevam@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [V3, 3/4] Documentation: dt-bindings: media: Document bindings
 for DW MIPI CSI-2 Host
Message-ID: <20181024174158.GB2902@bogus>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 19, 2018 at 02:52:25PM +0200, Luis Oliveira wrote:
> Add bindings for Synopsys DesignWare MIPI CSI-2 host.

Also, drop "Documentation: " from the subject. All bindings are 
documentation and the preferred prefix is 'dt-bindings: <binding dir>: '.

> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> ---
> Changelog
> v2-V3
> - removed IPI settings
> 
>  .../devicetree/bindings/media/snps,dw-csi-plat.txt | 52 ++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
