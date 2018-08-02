Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43303 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbeHBMYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 08:24:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id b15-v6so1570249wrv.10
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 03:33:36 -0700 (PDT)
Message-ID: <a5c8d552eaf567a09ba9d3cbc50771c5128cd805.camel@baylibre.com>
Subject: Re: [RFC 4/4] dt-bindings: media: add Amlogic Meson Video Decoder
 Bindings
From: Jerome Brunet <jbrunet@baylibre.com>
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org
Cc: linux-amlogic@lists.infradead.org
Date: Thu, 02 Aug 2018 12:33:34 +0200
In-Reply-To: <20180801193320.25313-5-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
         <20180801193320.25313-5-maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 21:33 +0200, Maxime Jourdan wrote:
> Add documentation for the meson vdec dts node.
> 
> Signed-off-by: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> ---
>  .../bindings/media/amlogic,meson-vdec.txt     | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt

Maxime, when formatting your patchset, remember to put the bindings
documentation before actually using them. This patch could be the first one of
your series.
