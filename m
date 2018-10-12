Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39740 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbeJMAUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 20:20:12 -0400
Date: Fri, 12 Oct 2018 11:46:49 -0500
From: Rob Herring <robh@kernel.org>
To: Luis Oliveira <Luis.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao.Pinto@synopsys.com, festevam@gmail.com,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [V2, 2/5] Documentation: dt-bindings: Document the Synopsys MIPI
 DPHY Rx bindings
Message-ID: <20181012164649.GA31690@bogus>
References: <20180920111648.27000-1-lolivei@synopsys.com>
 <20180920111648.27000-3-lolivei@synopsys.com>
 <20181012164548.GA11873@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012164548.GA11873@bogus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2018 at 11:45:48AM -0500, Rob Herring wrote:
> On Thu, Sep 20, 2018 at 01:16:40PM +0200, Luis Oliveira wrote:
> > Add device-tree bindings documentation for SNPS DesignWare MIPI D-PHY in
> > RX mode.
> 
> "dt-bindings: phy: ..." for the subject.
> 
> > 
> > Signed-off-by: Luis Oliveira <lolivei@synopsys.com>

Also, checkpatch.pl complains the author and S-o-b emails don't match.

Rob
