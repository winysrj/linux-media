Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35456 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933900AbeAKLTu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 06:19:50 -0500
Date: Thu, 11 Jan 2018 13:19:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] media: ov7670: Implement mbus configuration
Message-ID: <20180111111946.4ucvgkkhucdgnwyb@valkosipuli.retiisi.org.uk>
References: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Jan 04, 2018 at 10:52:31AM +0100, Jacopo Mondi wrote:
> Hello,
>    this series adds mbus configuration properties to ov7670 sensor driver.
> 
> I have sent v1 a few days ago and forgot to cc device tree people. Doing it
> now with bindings description and implementation split in 2 separate patches.
> 
> I have fixed Sakari's comment on v1, and I'm sending v2 out with support for
> "pll-bypass" custom property as it was in v1. If we decide it is not worth
> to make an OF property out of it, I will drop it in v3. Technically it is not
> even an mbus configuration option, so I'm fine dropping it eventually.
> 
> Thanks
>   j
> 
> v1->v2:
> - Split bindings description and implementation
> - Addressed Sakari's comments on v1
> - Check for return values of register writes in set_fmt()
> - TODO: decide if "pll-bypass" should be an OF property.

The register lists in the sensor driver likely assume certain external clock
frequency, and the pll-bypass bit can be used to avoid dividing this
frequency by four.

As the driver should be aware of the actual clock frequency as well as the
desired clock frequency, it should be possible for the driver to determine
whether to divide the external clock frequency by four or not.

> 
> Jacopo Mondi (2):
>   v4l2: i2c: ov7670: Implement OF mbus configuration
>   media: dt-bindings: Add OF properties to ov7670
> 
>  .../devicetree/bindings/media/i2c/ov7670.txt       |  14 +++
>  drivers/media/i2c/ov7670.c                         | 124 ++++++++++++++++++---
>  2 files changed, 124 insertions(+), 14 deletions(-)
> 
> --
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
