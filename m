Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38691 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLZTDO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 14:03:14 -0500
Date: Tue, 26 Dec 2017 13:03:11 -0600
From: Rob Herring <robh@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 3/6] media: dt-bindings: Add bindings for TDA1997X
Message-ID: <20171226190311.fkarrmgrytbirfgq@rob-hp-laptop>
References: <1513447230-30948-1-git-send-email-tharvey@gateworks.com>
 <1513447230-30948-4-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513447230-30948-4-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 16, 2017 at 10:00:27AM -0800, Tim Harvey wrote:
> Cc: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
> v5:
>  - added Sakari's ack
> 
> v4:
>  - move include/dt-bindings/media/tda1997x.h to bindings patch
>  - clarify port node details
> 
> v3:
>  - fix typo
> 
> v2:
>  - add vendor prefix and remove _ from vidout-portcfg
>  - remove _ from labels
>  - remove max-pixel-rate property
>  - describe and provide example for single output port
>  - update to new audio port bindings
> ---
>  .../devicetree/bindings/media/i2c/tda1997x.txt     | 179 +++++++++++++++++++++
>  include/dt-bindings/media/tda1997x.h               |  78 +++++++++
>  2 files changed, 257 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
>  create mode 100644 include/dt-bindings/media/tda1997x.h

Acked-by: Rob Herring <robh@kernel.org>
