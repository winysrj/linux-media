Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34850 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcFJRh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 13:37:27 -0400
Date: Fri, 10 Jun 2016 12:37:24 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-media@vger.kernel.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-renesas-soc@vger.kernel.org>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
	<devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: Update Renesas R-Car FCP DT binding
Message-ID: <20160610173724.GA19923@rob-hp-laptop>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 09, 2016 at 02:41:32PM +0100, Kieran Bingham wrote:
> The FCP driver, can also support the FCPF variant for FDP1 compatible

Drop the comma.

> processing.
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

With that,

Acked-by: Rob Herring <robh@kernel.org>
