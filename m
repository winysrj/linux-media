Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39924 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbcEKNF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 09:05:28 -0400
Date: Wed, 11 May 2016 08:05:18 -0500
From: Rob Herring <robh@kernel.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2.1] dt-bindings: Add Renesas R-Car FCP DT bindings
Message-ID: <20160511130518.GA1383@rob-hp-laptop>
References: <1461620198-13428-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1462970190-588-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462970190-588-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 11, 2016 at 03:36:30PM +0300, Laurent Pinchart wrote:
> The FCP is a companion module of video processing modules in the Renesas
> R-Car Gen3 SoCs. It provides data compression and decompression, data
> caching, and conversion of AXI transactions in order to reduce the
> memory bandwidth.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../devicetree/bindings/media/renesas,fcp.txt      | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt

Acked-by: Rob Herring <robh@kernel.org>
