Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59439 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbAMO3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 09:29:38 -0500
Received: by mail-ie0-f178.google.com with SMTP id vy18so2958512iec.9
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 06:29:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418836704-15689-2-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
	<1418836704-15689-2-git-send-email-hdegoede@redhat.com>
Date: Tue, 13 Jan 2015 15:29:38 +0100
Message-ID: <CACRpkdZMv0VNjSmhB0VoGt=wo02+g56YQtekD9MnxYUSmJDXEw@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] pinctrl: sun6i: Add some missing functions
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

> While working on pinctrl for the A31s, I noticed that function 4 of
> PA15 - PA18 was missing, add these.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Drop the changes to the muxing of i2c3 this was based on
>  "A31s Datasheet v1.40.pdf", but all other A31 related info puts them at the
>  pins where we already have them, so leave this as is

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
