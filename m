Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36193 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcGACtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 22:49:50 -0400
Date: Thu, 30 Jun 2016 21:49:47 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: laurent.pinchart@ideasonboard.com, mark.rutland@arm.com,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: Document Renesas R-Car FCP
 power-domains usage
Message-ID: <20160701024947.GA3219@rob-hp-laptop>
References: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
 <1467305430-25660-3-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467305430-25660-3-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 30, 2016 at 05:50:29PM +0100, Kieran Bingham wrote:
> The power domain must be specified to bring the device out of module
> standby. Document this in the bindings provided, so that new additions
> are not missed.
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 5 +++++
>  1 file changed, 5 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
