Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35046 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcGACvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 22:51:05 -0400
Date: Thu, 30 Jun 2016 21:51:01 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: laurent.pinchart@ideasonboard.com, mark.rutland@arm.com,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] dt-bindings: Add Renesas R-Car FDP1 bindings
Message-ID: <20160701025101.GA3652@rob-hp-laptop>
References: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
 <1467305430-25660-4-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467305430-25660-4-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 30, 2016 at 05:50:30PM +0100, Kieran Bingham wrote:
> The FDP1 is a de-interlacing module which converts interlaced video to
> progressive video. It is also capable of performing pixel format conversion
> between YCbCr/YUV formats and RGB formats.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
> Changes since v1:
>  - title fixed
>  - Interrupts property documented
>  - version specific compatibles removed as we have a hw version register
>  - label removed from device node example
>    * (fdp1 is not referenced by other nodes)
> 
>  .../devicetree/bindings/media/renesas,fdp1.txt     | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt

Acked-by: Rob Herring <robh@kernel.org>
