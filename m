Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47070 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbbCRNkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 09:40:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/2] of: Add vendor prefix for Aptina Imaging
Date: Wed, 18 Mar 2015 15:40:15 +0200
Message-ID: <7715060.bEeyxqYSht@avalon>
In-Reply-To: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Gentle ping to the DT maintainers for this (hopefully) simple bikeshedding 
question.

On Saturday 14 March 2015 16:57:36 Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> Aptina has recently been acquired by ON Semiconductor, but the name Aptina
> is still widely used. Should the onnn prefix be used instead ?
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
> b/Documentation/devicetree/bindings/vendor-prefixes.txt index
> 389ca13..4326f52 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -20,6 +20,7 @@ amlogic	Amlogic, Inc.
>  ams	AMS AG
>  amstaos	AMS-Taos Inc.
>  apm	Applied Micro Circuits Corporation (APM)
> +aptina	Aptina Imaging
>  arm	ARM Ltd.
>  armadeus	ARMadeus Systems SARL
>  asahi-kasei	Asahi Kasei Corp.

-- 
Regards,

Laurent Pinchart

