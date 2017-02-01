Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34207 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752830AbdBASWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 13:22:25 -0500
Subject: Re: [PATCH] Documentation: devicetree: meson-ir: "linux, rc-map-name"
 is supported
To: Rob Herring <robh@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
 <20170201174726.2vyvxpnie7qclrvk@rob-hp-laptop>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, khilman@baylibre.com, carlo@caione.org,
        linux-amlogic@lists.infradead.org, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <29c4bd35-8723-55fe-2467-2c17d2f75b15@suse.de>
Date: Wed, 1 Feb 2017 19:22:21 +0100
MIME-Version: 1.0
In-Reply-To: <20170201174726.2vyvxpnie7qclrvk@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2017 um 18:47 schrieb Rob Herring:
> On Tue, Jan 31, 2017 at 10:21:12PM +0100, Martin Blumenstingl wrote:
>> The driver already parses the "linux,rc-map-name" property. Add this
>> information to the documentation so .dts maintainers don't have to look
>> it up in the source-code.
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>>  Documentation/devicetree/bindings/media/meson-ir.txt | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> Acked-by: Rob Herring <robh@kernel.org>

Note that the subject has a space in the property name that should be
dropped before applying.

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
