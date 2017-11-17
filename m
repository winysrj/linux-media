Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:58883 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965138AbdKQPf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:35:56 -0500
Date: Fri, 17 Nov 2017 07:35:52 -0800
From: Simon Horman <horms@verge.net.au>
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH v2 2/4] dt-bindings: media: rcar_vin: add device tree
 support for r8a774[35]
Message-ID: <20171117153551.xdnr74k7az4f76vf@verge.net.au>
References: <1510856571-30281-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510856571-30281-3-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510856571-30281-3-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 16, 2017 at 06:22:49PM +0000, Fabrizio Castro wrote:
> Add compatible strings for r8a7743 and r8a7745. No driver change
> is needed as "renesas,rcar-gen2-vin" will activate the right code.
> However, it is good practice to document compatible strings for the
> specific SoC as this allows SoC specific changes to the driver if
> needed, in addition to document SoC support and therefore allow
> checkpatch.pl to validate compatible string values.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
