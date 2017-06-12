Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752338AbdFLOgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 10:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <20170609175401.40204-2-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl> <20170609175401.40204-2-hverkuil@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Mon, 12 Jun 2017 09:36:24 -0500
Message-ID: <CAL_JsqKcabSk5knCwdiHx3QS56_tSTNpJi8tr6=5EzDoGKN1yA@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: add media/cec.txt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 12:54 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Document common HDMI CEC bindings. Add this to the MAINTAINERS file
> as well.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/cec.txt | 8 ++++++++
>  MAINTAINERS                                     | 1 +
>  2 files changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec.txt

Reviewed-by: Rob Herring <robh@kernel.org>

Thanks for doing this.

Rob
