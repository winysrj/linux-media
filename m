Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36198 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbdBAW0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 17:26:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170201221415.22794-1-martin.blumenstingl@googlemail.com>
References: <20170131212112.5582-1-martin.blumenstingl@googlemail.com> <20170201221415.22794-1-martin.blumenstingl@googlemail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 1 Feb 2017 23:26:14 +0100
Message-ID: <CAFBinCDF2d36E2hp7w_ehqdErdZPK9maQLpBmqMoGMPZmTTqqQ@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: devicetree: meson-ir:
 "linux,rc-map-name" is supported
To: mchehab@kernel.org
Cc: linux-media <linux-media@vger.kernel.org>, carlo@caione.org,
        khilman@baylibre.com, linux-amlogic@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com, narmstrong@baylibre.com,
        linux-arm-kernel@lists.infradead.org, afaerber@suse.de,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 1, 2017 at 11:14 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> The driver already parses the "linux,rc-map-name" property. Add this
> information to the documentation so .dts maintainers don't have to look
> it up in the source-code.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> Changes since v1:
> - removed character which shows up as whitespace from subject
I have verified that I really sent this without a whitespace (I'm
using git send-email, so the patch is not mangled by some webmailer) -
unfortunately it seems to appear again (maybe one of the receiving
mail-servers or the mailing-list software does something weird here).

@Mauro: can you handle this when you merge the patch - or do you want
me to push this to some git repo from which you can pull?

> - added Rob Herring's ACK
>
>  Documentation/devicetree/bindings/media/meson-ir.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/media/meson-ir.txt
> index e7e3f3c4fc8f..efd9d29a8f10 100644
> --- a/Documentation/devicetree/bindings/media/meson-ir.txt
> +++ b/Documentation/devicetree/bindings/media/meson-ir.txt
> @@ -8,6 +8,9 @@ Required properties:
>   - reg         : physical base address and length of the device registers
>   - interrupts  : a single specifier for the interrupt from the device
>
> +Optional properties:
> + - linux,rc-map-name:  see rc.txt file in the same directory.
> +
>  Example:
>
>         ir-receiver@c8100480 {
> --
> 2.11.0
>
