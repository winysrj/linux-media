Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39791 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbeJLFjk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 01:39:40 -0400
Date: Thu, 11 Oct 2018 17:10:23 -0500
From: Rob Herring <robh@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        jacopo@jmondi.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v11 1/3] [media] imx214: device tree binding
Message-ID: <20181011221023.GA29071@bogus>
References: <20181005225011.3269-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005225011.3269-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat,  6 Oct 2018 00:50:11 +0200, Ricardo Ribalda Delgado wrote:
> Document bindings for imx214 camera sensor
> 
> Cc: devicetree@vger.kernel.org
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> Changelog from v10:
> 
> Sakari Ailus:
> -Re-introduce clock-frequency property
> 
>  .../bindings/media/i2c/sony,imx214.txt        | 53 +++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/sony,imx214.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
