Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933157AbdGKSqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 14:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <20170711115241.cprjvqirp7pyuhye@gofer.mess.org>
References: <cover.1499419624.git.sean@mess.org> <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
 <20170710150538.ql26gswdf2obch6o@rob-hp-laptop> <20170710151016.5iaokchdejxozrte@gofer.mess.org>
 <20170711115241.cprjvqirp7pyuhye@gofer.mess.org>
From: Rob Herring <robh+dt@kernel.org>
Date: Tue, 11 Jul 2017 13:45:44 -0500
Message-ID: <CAL_JsqLPHYOEdj2sEikA=NRJwForL0EFE3GYyzfeZ_gUXyL08w@mail.gmail.com>
Subject: Re: [PATCH v3] [media] dt-bindings: gpio-ir-tx: add support for GPIO
 IR Transmitter
To: Sean Young <sean@mess.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 6:52 AM, Sean Young <sean@mess.org> wrote:
> Document the device tree bindings for the GPIO Bit Banging IR
> Transmitter.
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../devicetree/bindings/leds/irled/gpio-ir-tx.txt          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt

Acked-by: Rob Herring <robh@kernel.org>
