Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:44641 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754661AbeEWQmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 12:42:03 -0400
Date: Wed, 23 May 2018 11:42:01 -0500
From: Rob Herring <robh@kernel.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] dt-bindings: media: rcar_vin: fix style for ports and
 endpoints
Message-ID: <20180523164201.GA27830@rob-hp-laptop>
References: <20180516233212.30931-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180516233212.30931-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 01:32:12AM +0200, Niklas Söderlund wrote:
> The style for referring to ports and endpoint are wrong. Refer to them
> using lowercase and a unit address, port@x and endpoint@x.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
