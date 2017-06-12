Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbdFLOhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 10:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <20170609175401.40204-3-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl> <20170609175401.40204-3-hverkuil@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Mon, 12 Jun 2017 09:37:13 -0500
Message-ID: <CAL_JsqKaYhrhPQvmL-kc2XObkDFZ3e=FJfY=-En9w9QuNF9trw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: media/s5p-cec.txt, media/stih-cec.txt:
 refer to cec.txt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 12:54 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Now that there is a cec.txt with common CEC bindings, update the two
> driver-specific bindings to refer to cec.txt.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/s5p-cec.txt  | 6 ++----
>  Documentation/devicetree/bindings/media/stih-cec.txt | 2 +-
>  2 files changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
