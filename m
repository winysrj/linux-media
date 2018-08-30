Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60480 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728195AbeH3O5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 10:57:07 -0400
Date: Thu, 30 Aug 2018 13:55:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: robh@kernel.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        alanx.chiang@intel.com, andy.yeh@intel.com
Subject: Re: [PATCH 1/2] dt-bindings: dw9714, dw9807-vcm: Add files to
 MAINTAINERS, rename files
Message-ID: <20180830105531.53o3afx5k3cank5z@valkosipuli.retiisi.org.uk>
References: <20180723105039.20110-1-sakari.ailus@linux.intel.com>
 <20180723105039.20110-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723105039.20110-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping?

On Mon, Jul 23, 2018 at 01:50:38PM +0300, Sakari Ailus wrote:
> Add the DT binding documentation for dw9714 and dw9807-vcm to the
> MAINTAINERS file. The dw9807-vcm binding documentation file is renamed to
> match the dw9807's VCM bit's compatible string.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} | 0
>  MAINTAINERS                                                             | 2 ++
>  2 files changed, 2 insertions(+)
>  rename Documentation/devicetree/bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} (100%)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> rename to Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bbd9b9b3d74f..44e917de2c8c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4410,6 +4410,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/i2c/dw9714.c
> +F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt
>  
>  DONGWOON DW9807 LENS VOICE COIL DRIVER
>  M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> @@ -4417,6 +4418,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/i2c/dw9807.c
> +F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
>  
>  DOUBLETALK DRIVER
>  M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
> -- 
> 2.11.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
