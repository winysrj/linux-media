Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34348 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdBMVFC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 16:05:02 -0500
Received: by mail-oi0-f54.google.com with SMTP id s203so58353565oie.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 13:05:01 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/10] ARM: davinci: fix a whitespace error
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-8-git-send-email-bgolaszewski@baylibre.com>
        <m2o9y6djl1.fsf@baylibre.com>
Date: Mon, 13 Feb 2017 13:04:59 -0800
In-Reply-To: <m2o9y6djl1.fsf@baylibre.com> (Kevin Hilman's message of "Mon, 13
        Feb 2017 10:36:10 -0800")
Message-ID: <m260kder9g.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman <khilman@baylibre.com> writes:

> Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:
>
>> There's a stray tab in da850_vpif_legacy_init(). Remove it.
>>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Folding into the original,

Looks like the version in Sekhar's v4.11/soc branch already has this
fixed.

Kevin
