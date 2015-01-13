Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54443 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbAMObi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 09:31:38 -0500
Received: by mail-ig0-f169.google.com with SMTP id z20so16596209igj.0
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 06:31:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418836704-15689-3-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
	<1418836704-15689-3-git-send-email-hdegoede@redhat.com>
Date: Tue, 13 Jan 2015 15:31:37 +0100
Message-ID: <CACRpkdb8wzjAc+14tK=d7coi6H8gts7TrvwELqo0e0RHLsB6Rw@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] pinctrl: sun6i: Add A31s pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 17, 2014 at 6:18 PM, Hans de Goede <hdegoede@redhat.com> wrote:

> The A31s is a stripped down version of the A31, as such it is missing some
> pins and some functions on some pins.
>
> The new pinctrl-sun6i-a31s.c this commit adds is a copy of pinctrl-sun6i-a31s.c
> with the missing pins and functions removed.
>
> Note there is no a31s specific version of pinctrl-sun6i-a31-r.c, as the
> prcm pins are identical between the A31 and the A31s.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Sync i2c3 muxing with v2 of "pinctrl: sun6i: Add some missing functions"
> -Add myself to the copyright header

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
