Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33325 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOWDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 17:03:24 -0500
Date: Wed, 15 Feb 2017 16:03:22 -0600
From: Rob Herring <robh@kernel.org>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 03/10] media: dt-bindings: vpif: extend the example with
 an output port
Message-ID: <20170215220322.7oulu7qgxelrqquo@rob-hp-laptop>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
 <1486485683-11427-4-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486485683-11427-4-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 07, 2017 at 05:41:16PM +0100, Bartosz Golaszewski wrote:
> This makes the example more or less correspond with the da850-evm
> hardware setup.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  .../devicetree/bindings/media/ti,da850-vpif.txt    | 35 ++++++++++++++++++----
>  1 file changed, 29 insertions(+), 6 deletions(-)

Acked-by: Rob Herring <robh@kernel.org> 
