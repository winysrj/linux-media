Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45868 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932653AbeEaDfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:35:04 -0400
Date: Wed, 30 May 2018 22:35:01 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com, sebastian.reichel@collabora.co.uk
Subject: Re: [PATCH v2.2 2/2] smiapp: Support the "rotation" property
Message-ID: <20180531033501.GA26590@rob-hp-laptop>
References: <20180525134055.11121-1-sakari.ailus@linux.intel.com>
 <20180525135235.12386-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525135235.12386-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 04:52:35PM +0300, Sakari Ailus wrote:
> Use the "rotation" property to tell that the sensor is mounted upside
> down. This reverses the behaviour of the VFLIP and HFLIP controls as well
> as the pixel order.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v2.2:
> 
> - Fix property name in code.
> 
>  .../devicetree/bindings/media/i2c/nokia,smia.txt         |  2 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
