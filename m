Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36065 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbdEHNhd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 09:37:33 -0400
Date: Mon, 8 May 2017 08:37:31 -0500
From: Rob Herring <robh@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 1/2] [media] dt-bindings: Add bindings for
 video-multiplexer device
Message-ID: <20170508133731.lkncknyththquvm4@rob-hp-laptop>
References: <1493911039-10693-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493911039-10693-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 04, 2017 at 05:17:18PM +0200, Philipp Zabel wrote:
> Add bindings documentation for the video multiplexer device.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> ---
> No changes since v3 [1].
> 
> This was previously sent as part of Steve's i.MX media series [2].
> 
> [1] https://patchwork.kernel.org/patch/9711997/
> [2] https://patchwork.kernel.org/patch/9647951/
> ---
>  .../devicetree/bindings/media/video-mux.txt        | 60 ++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt

Acked-by: Rob Herring <robh@kernel.org>
