Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54063 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750774AbdBBNEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 08:04:25 -0500
Subject: Re: [PATCH v2] Documentation: devicetree: meson-ir:
 "linux,rc-map-name" is supported
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        mchehab@kernel.org
References: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
 <20170201221415.22794-1-martin.blumenstingl@googlemail.com>
 <CAFBinCDF2d36E2hp7w_ehqdErdZPK9maQLpBmqMoGMPZmTTqqQ@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>, carlo@caione.org,
        khilman@baylibre.com, linux-amlogic@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com, narmstrong@baylibre.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <cccd0fef-fa2c-bdfd-b7dd-b26ef288dfa0@suse.de>
Date: Thu, 2 Feb 2017 14:04:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAFBinCDF2d36E2hp7w_ehqdErdZPK9maQLpBmqMoGMPZmTTqqQ@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2017 um 23:26 schrieb Martin Blumenstingl:
> On Wed, Feb 1, 2017 at 11:14 PM, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>> The driver already parses the "linux,rc-map-name" property. Add this
>> information to the documentation so .dts maintainers don't have to look
>> it up in the source-code.
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Acked-by: Rob Herring <robh@kernel.org>
>> ---
>> Changes since v1:
>> - removed character which shows up as whitespace from subject
> I have verified that I really sent this without a whitespace (I'm
> using git send-email, so the patch is not mangled by some webmailer) -
> unfortunately it seems to appear again (maybe one of the receiving
> mail-servers or the mailing-list software does something weird here).

Shows up fine here now,

Reviewed-by: Andreas Färber <afaerber@suse.de>

Didn't expect a resend for that btw.

Thanks,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
