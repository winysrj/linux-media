Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:42154 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbeEaELc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 00:11:32 -0400
Date: Wed, 30 May 2018 23:11:29 -0500
From: Rob Herring <robh@kernel.org>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] media: dt: bindings: tegra-vde: Document new optional
 Memory Client reset property
Message-ID: <20180531041129.GA566@rob-hp-laptop>
References: <20180526143355.24288-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180526143355.24288-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 26, 2018 at 05:33:55PM +0300, Dmitry Osipenko wrote:
> Recently binding of the Memory Controller has been extended, exposing
> the Memory Client reset controls and hence it is now a reset controller.
> Tegra video-decoder device is among the Memory Controller reset users,
> document the new optional VDE HW reset property.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  .../devicetree/bindings/media/nvidia,tegra-vde.txt    | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
