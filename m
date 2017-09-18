Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbdIRUCA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 16:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <20170917101546.16993-4-hverkuil@xs4all.nl>
References: <20170917101546.16993-1-hverkuil@xs4all.nl> <20170917101546.16993-4-hverkuil@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Mon, 18 Sep 2017 15:01:38 -0500
Message-ID: <CAL_JsqL47W337yMbGuYPFbo8ROJzZHLNvX+rufw1uBNjnwgzgg@mail.gmail.com>
Subject: Re: [PATCHv6 3/5] dt-bindings: document the CEC GPIO bindings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 17, 2017 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Document the bindings for the cec-gpio module for hardware where the
> CEC line and optionally the HPD line are connected to GPIO lines.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  .../devicetree/bindings/media/cec-gpio.txt         | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt

Reviewed-by: Rob Herring <robh@kernel.org>
