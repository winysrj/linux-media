Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33357 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdGJDw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 23:52:58 -0400
Date: Sun, 9 Jul 2017 22:52:55 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 1/3] media: adv748x: Add adv7481, adv7482 bindings
Message-ID: <20170710035255.rxivzur6zggcnx5s@rob-hp-laptop>
References: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
 <0f27988a8f89e54c9e89eaeadf03396e6e98118a.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f27988a8f89e54c9e89eaeadf03396e6e98118a.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 06, 2017 at 12:01:15PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Create device tree bindings documentation for the ADV748x.
> The ADV748x supports both the ADV7481 and ADV7482 chips which
> provide analogue decoding and HDMI receiving capabilities
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> ---
> v6:
>  - Clean up description and remove redundant text regarding optional
>    nodes
> 
> v6.1:
>  - Fix commit title
> 
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 95 ++++++++++-
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt

Acked-by: Rob Herring <robh@kernel.org>
