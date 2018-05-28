Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40101 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936585AbeE1X6m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 19:58:42 -0400
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
From: Dmitry Osipenko <digetx@gmail.com>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com> <20180528131501.GK23723@intel.com>
 <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
Message-ID: <2fe5b5ba-af52-5cdf-b022-9c04f9024e86@gmail.com>
Date: Tue, 29 May 2018 02:58:38 +0300
MIME-Version: 1.0
In-Reply-To: <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.05.2018 02:48, Dmitry Osipenko wrote:
> inversion=true" if mask has form of 0x11000111, though this could be not

For clarity: I meant s/0x11000111/0xFF000FFF/.
