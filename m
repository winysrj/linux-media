Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753235AbdJIB1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Oct 2017 21:27:46 -0400
MIME-Version: 1.0
In-Reply-To: <3d911a4a-1945-08a7-ae19-0cd0dc6aaacd@sigmadesigns.com>
References: <3d911a4a-1945-08a7-ae19-0cd0dc6aaacd@sigmadesigns.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Sun, 8 Oct 2017 20:27:24 -0500
Message-ID: <CAL_JsqJTiVFY+ewiTAu1H51tZnnOUgXq4WezLbPNkn62Vwm+fQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] media: dt: bindings: Add binding for tango HW IR decoder
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>, DT <devicetree@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 6, 2017 at 7:23 AM, Marc Gonzalez
<marc_gonzalez@sigmadesigns.com> wrote:
> Add DT binding for the HW IR decoder embedded in SMP86xx/SMP87xx.
>
> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> ---
>  .../devicetree/bindings/media/tango-ir.txt          | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt

Acked-by: Rob Herring <robh@kernel.org>
