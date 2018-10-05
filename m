Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39459 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJFDhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 23:37:15 -0400
Date: Fri, 5 Oct 2018 15:36:52 -0500
From: Rob Herring <robh@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 2/6] [media] ad5820: DT new optional field enable-gpios
Message-ID: <20181005203652.GA12732@bogus>
References: <20181002111356.32298-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002111356.32298-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue,  2 Oct 2018 13:13:56 +0200, Ricardo Ribalda Delgado wrote:
> Document new enable-gpio field. It can be used to disable the part
> without turning down its regulator.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
