Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:28683 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751735AbdISLxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:53:36 -0400
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
To: Mans Rullgard <mans@mansr.com>, Sean Young <sean@mess.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
 <yw1xd16oyqas.fsf@mansr.com>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <569e41a9-57c9-3d6f-4157-dffb23f997c6@sigmadesigns.com>
Date: Tue, 19 Sep 2017 13:53:30 +0200
MIME-Version: 1.0
In-Reply-To: <yw1xd16oyqas.fsf@mansr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/09/2017 17:33, Måns Rullgård wrote:

> What have you changed compared to my original code?

I forgot to mention one change you may not approve of, so we should
probably discuss it.

Your driver supported an optional DT property "linux,rc-map-name"
to override the RC_MAP_EMPTY map. Since the IR decoder supports
multiple protocols, I found it odd to specify a scancode map in
something as low-level as the device tree.

I saw only one board using that property:
$ git grep "linux,rc-map-name" arch/
arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts:     linux,rc-map-name = "rc-geekbox";

So I removed support for "linux,rc-map-name" and used ir-keytable
to load a given map from user-space, depending on which RC I use.

Mans, Sean, what do you think?

Regards.
