Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33875 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753287AbeA2UJY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 15:09:24 -0500
Date: Mon, 29 Jan 2018 14:09:23 -0600
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        David Airlie <airlied@linux.ie>,
        Mark Rutland <mark.rutland@arm.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for
 i2c_new_secondary_device
Message-ID: <20180129200923.dp5maqyfh2v3wlnd@rob-hp-laptop>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
 <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 22, 2018 at 12:50:01PM +0000, Kieran Bingham wrote:
> The ADV7511 has four 256-byte maps that can be accessed via the main I²C
> ports. Each map has it own I²C address and acts as a standard slave
> device on the I²C bus.
> 
> Allow a device tree node to override the default addresses so that
> address conflicts with other devices on the same bus may be resolved at
> the board description level.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> ---
>  .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-

Reviewed-by: Rob Herring <robh@kernel.org>

>  drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++
>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++++++++--------
>  3 files changed, 37 insertions(+), 13 deletions(-)
