Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34818 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933573AbcKXAEp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 19:04:45 -0500
Received: by mail-oi0-f43.google.com with SMTP id b126so33715718oia.2
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 16:04:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161119003208.10550-4-khilman@baylibre.com>
References: <20161119003208.10550-1-khilman@baylibre.com> <20161119003208.10550-4-khilman@baylibre.com>
From: Kevin Hilman <khilman@baylibre.com>
Date: Wed, 23 Nov 2016 16:04:44 -0800
Message-ID: <CAOi56cWkrX2wWH+PfjYHj+f0SrcEpV=9Lb7=LnSaZ0Nh1k3L3A@mail.gmail.com>
Subject: Re: [PATCH 4/4] [media] dt-bindings: add TI VPIF documentation
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: devicetree <devicetree@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 18, 2016 at 4:32 PM, Kevin Hilman <khilman@baylibre.com> wrote:
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  .../devicetree/bindings/media/ti,vpif-capture.txt  | 65 ++++++++++++++++++++++
>  .../devicetree/bindings/media/ti,vpif.txt          |  8 +++
>  2 files changed, 73 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/ti,vpif-capture.txt
>  create mode 100644 Documentation/devicetree/bindings/media/ti,vpif.txt

@DT maintainers: this can be ignored, I'm reworking this after some
discussion with Laurent.

Kevin
