Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23688C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC24D2087C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfC0MjM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:39:12 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36719 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbfC0MjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 08:39:11 -0400
Received: from [IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f] ([IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 97pfhBF1xUjKf97pihotlY; Wed, 27 Mar 2019 13:39:09 +0100
Subject: Re: [PATCH 1/3] media: dt-bindings: media: meson-ao-cec: Add G12A
 AO-CEC-B Compatible
To:     Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190325173501.22863-1-narmstrong@baylibre.com>
 <20190325173501.22863-2-narmstrong@baylibre.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <518678c1-2e1d-ca27-55bd-0dd10965354f@xs4all.nl>
Date:   Wed, 27 Mar 2019 13:39:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190325173501.22863-2-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBTTQbqkqOt2i3TAvKHYs0YrBgPt519lwHiUdXbVmreDq4Rkx0w29c7WAOi5zTfES1EftX1R5wYa88rpAwb602bMMCFdacP6S8JPzom+nRkUhqYhOKh6
 fO2eY2mwqE9jFHfxPeSCmAX52b3U/GwJEiD1S4Q8XbnFa55OV7mBZ8wlBkBH1O8/BwyaHJmL1fxnqGqVH7B2w8q8k6POz6qQuZqfUaC8IiJ3PJeg3vIhVSww
 yxd83kDUaowiBR4qCkq6MmFe+pahnn9IwI7HtqbPiiqv1+zCCbDHUEJWTPqUVm8oYNtBcYD/Igb0dw048IkcDd7pvDSu6avV8m3JFYbddlxZDs7ZpwonVpiI
 KN0AO5iizbQV4Odw+g4S+jJVu04ewh4PqkRxCMlYhjtbqxglkkkHLqvE2YmwiTfujIPBPgLQ0bqI5uoOuexahSSWGmaFFasBZovKnwYx1cNVzudDCEiWLw8o
 SvnybT4sF5wcmLIjjWvEaZYS4nbLQ3oKmtZty9haJtQpGy7H23L5fkjaJXIpfUDqISx/6p+gR1uQbs6+
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/25/19 6:34 PM, Neil Armstrong wrote:
> The Amlogic G12A embeds a second CEC controller named AO-CEC-B, and
> the other one is AO-CEC-A described by the current bindings.
> 
> The registers interface is very close but the internal architecture

registers -> register

> is totally different.
> 
> The other difference is the closk source, the AO-CEC-B takes the

closk -> clock

> "oscin", the Always-On Oscillator clock, as input and embeds a
> dual-divider clock divider to provide the precise 32768Hz base
> clock for CEC communication.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  .../devicetree/bindings/media/meson-ao-cec.txt    | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/meson-ao-cec.txt b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
> index 8671bdb08080..d6e2f9cf0aaf 100644
> --- a/Documentation/devicetree/bindings/media/meson-ao-cec.txt
> +++ b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
> @@ -4,16 +4,23 @@ The Amlogic Meson AO-CEC module is present is Amlogic SoCs and its purpose is
>  to handle communication between HDMI connected devices over the CEC bus.
>  
>  Required properties:
> -  - compatible : value should be following
> -	"amlogic,meson-gx-ao-cec"
> +  - compatible : value should be following depending on the SoC :
> +  	For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
> +  	"amlogic,meson-gx-ao-cec"
> +	For G12A (AO_CEC_B module) :
> +	"amlogic,meson-g12a-ao-cec"

The driver uses "amlogic,meson-g12a-ao-cec-b", so there is a mismatch between
the bindings and the driver.

Please repost since it is important that the two correspond.

Thanks!

	Hans

>  
>    - reg : Physical base address of the IP registers and length of memory
>  	  mapped region.
>  
>    - interrupts : AO-CEC interrupt number to the CPU.
>    - clocks : from common clock binding: handle to AO-CEC clock.
> -  - clock-names : from common clock binding: must contain "core",
> -		  corresponding to entry in the clocks property.
> +  - clock-names : from common clock binding, must contain :
> +		For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
> +		- "core"
> +		For G12A (AO_CEC_B module) :
> +		- "oscin"
> +		corresponding to entry in the clocks property.
>    - hdmi-phandle: phandle to the HDMI controller
>  
>  Example:
> 

