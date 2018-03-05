Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:41554 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbeCEWHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 17:07:07 -0500
Date: Mon, 5 Mar 2018 16:07:05 -0600
From: Rob Herring <robh@kernel.org>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media: dt-bindings: Add bindings for
 panasonic,amg88xx
Message-ID: <20180305220705.rf6gnfzf7kcidz7o@rob-hp-laptop>
References: <20180227061136.5532-1-matt.ranostay@konsulko.com>
 <20180227061136.5532-2-matt.ranostay@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180227061136.5532-2-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 26, 2018 at 10:11:35PM -0800, Matt Ranostay wrote:
> Define the device tree bindings for the panasonic,amg88xx i2c
> video driver.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
>  .../bindings/media/i2c/panasonic,amg88xx.txt          | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt

Reviewed-by: Rob Herring <robh@kernel.org>
