Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36895 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbcF0M5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:57:12 -0400
Received: by mail-wm0-f42.google.com with SMTP id a66so114143874wme.0
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 05:57:12 -0700 (PDT)
Subject: Re: [v2] media: rc: fix Meson IR decoder
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	b.galvani@gmail.com, linux-media@vger.kernel.org,
	linux-amlogic@lists.infradead.org
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
	pawel.moll@arm.com, khilman@baylibre.com, tobetter@gmail.com,
	robh+dt@kernel.org, carlo@caione.org, mchehab@kernel.org,
	linux-arm-kernel@lists.infradead.org
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <577122A5.8000203@baylibre.com>
Date: Mon, 27 Jun 2016 14:57:09 +0200
MIME-Version: 1.0
In-Reply-To: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/2016 12:53 PM, Martin Blumenstingl wrote:
> On Mon, Jun 27, 2016 at 8:27 AM, Neil Armstrong <narmstrong@baylibre.com> wrote:
>> I'm quite sure the registers are good for meson6 actually, and
>> it seems reasonable Amlogic made the HW evolve for the Meson8 and GXBB platforms.
> OK, then from now on I will NOT assume anymore that the reference code
> also works on Meson6 platforms. Thanks for clarifying this.

Yes it's quite safer to assume this !

>> Since we are using devicetree, the correct way to achieve this fix is not
>> to drop support for meson6 (what you do) but add a logic to select the correct
>> register for meson8 and gxbb if their compatible string are encountered.
>
>> I made this fix already but lacked time to actually test it on HW :
>> https://github.com/torvalds/linux/compare/master...superna9999:amlogic/v4.7/ir
>>
>> My patch is missing the meson8b support, and may need a supplementary compatible check or
>> a separate dt match table.
> I can test it on GXBB (only, I do not have Meson8b hardware, but
> according to the datasheet the registers are the same).
> If you want I can start based on your patch series. Should we add only
> a binding for amlogic,meson8b and re-use that in meson-gxbb.dtsi or
> should we add both (8b and gxbb) bindings instead?

Yes, no problem !
Add the two bindings, it's a better practice and we can track more easily which
hardware is really supported from the driver point of view.

>> PS: BTW could you format the cover letter using the git format-patch --cover-letter instead and
>> add the v2 using the -subject-prefix like :
>> # git format-patch --cover-letter --signoff --subject-prefix "PATCH v2" -2
> sounds like this is what other devs are using as well - thanks for
> letting me know
>

Neil

