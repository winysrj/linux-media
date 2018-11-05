Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34223 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbeKFFef (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 00:34:35 -0500
Date: Mon, 5 Nov 2018 14:13:12 -0600
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v4 2/4] dt-bindings: media: i2c: Add bindings for IMI
 RDACM20
Message-ID: <20181105201312.GA30170@bogus>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-3-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181102154723.23662-3-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  2 Nov 2018 15:47:21 +0000, Kieran Bingham wrote:
> From: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> The IMI RDACM20 is a Gigabit Multimedia Serial Link (GMSL) camera
> capable of transmitting video and I2C control messages on a coax cable
> physical link for automotive applications.
> 
> Document its device tree binding interface.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> ---
> v2:
>  - Provide imi vendor prefix
>  - Fix minor spelling
> 
> v3:
>  - update binding descriptions
> ---
>  .../bindings/media/i2c/imi,rdacm20.txt        | 65 +++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.txt   |  1 +
>  2 files changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/imi,rdacm20.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
