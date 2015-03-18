Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36511 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbCRQAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 12:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 18 Mar 2015 10:59:49 -0500
Message-ID: <CAL_Jsq+pfYG-UowKVgeqW2yu_iSO_Yoo6q=9ZrdaOeW1Hu3vTw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] of: Add vendor prefix for Aptina Imaging
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	=?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 14, 2015 at 9:57 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> Aptina has recently been acquired by ON Semiconductor, but the name Aptina is
> still widely used. Should the onnn prefix be used instead ?

Using aptina is fine.

Acked-by: Rob Herring <robh@kernel.org>

Rob

>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 389ca13..4326f52 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -20,6 +20,7 @@ amlogic       Amlogic, Inc.
>  ams    AMS AG
>  amstaos        AMS-Taos Inc.
>  apm    Applied Micro Circuits Corporation (APM)
> +aptina Aptina Imaging
>  arm    ARM Ltd.
>  armadeus       ARMadeus Systems SARL
>  asahi-kasei    Asahi Kasei Corp.
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
