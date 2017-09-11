Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44167 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751087AbdIKJk6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:40:58 -0400
Subject: Re: [PATCH v10 20/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-21-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6cf99eb6-7b59-661a-963a-d46747d51f1f@xs4all.nl>
Date: Mon, 11 Sep 2017 11:40:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-21-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> Document optional lens-focus and flash properties for the smiapp driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> index 855e1faf73e2..33f10a94c381 100644
> --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> @@ -27,6 +27,8 @@ Optional properties
>  - nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
>    the NVM contents will not be read.
>  - reset-gpios: XSHUTDOWN GPIO
> +- flash-leds: See ../video-interfaces.txt
> +- lens-focus: See ../video-interfaces.txt
>  
>  
>  Endpoint node mandatory properties
> 
