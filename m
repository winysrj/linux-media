Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:37908 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750837AbeECHbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 03:31:55 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [RESEND PATCH v9 1/2] media: dt-bindings: Add bindings for
 Dongwoon DW9807 voice coil
Date: Thu, 3 May 2018 07:31:50 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D58F56E@PGSMSX111.gar.corp.intel.com>
References: <1525276428-17379-1-git-send-email-andy.yeh@intel.com>
 <1525276428-17379-2-git-send-email-andy.yeh@intel.com>
 <20180502213637.ycvksj33edrkprpn@kekkonen.localdomain>
In-Reply-To: <20180502213637.ycvksj33edrkprpn@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks to add to your tree. And I am not familiar with the process. So I wonder how the patchset will be applied to the Linux media tree eventually?

Regards, Andy

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com] 
Sent: Thursday, May 3, 2018 5:37 AM
To: Yeh, Andy <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org; devicetree@vger.kernel.org; tfiga@chromium.org; jacopo@jmondi.org; Chiang, AlanX <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v9 1/2] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil

On Wed, May 02, 2018 at 11:53:47PM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
> 
> Dongwoon DW9807 is a voice coil lens driver.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

I don't remember seeing these two on the first patch nor giving mine. For what it's worth, I've applied v8 to my tree here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.18-3>

I.e. there's no need to resend the same patch to just add the regular acked-by or reviewed-by tags. "RESEND" in the subject suggests you're sending exactly the same patch, and in that case the version would be unchanged as well.

> Acked-by: Rob Herring <robh@kernel.org>
> 
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 
> +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 
> Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> 
> diff --git 
> a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt 
> b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> new file mode 100644
> index 0000000..0a1a860
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> @@ -0,0 +1,9 @@
> +Dongwoon Anatech DW9807 voice coil lens driver
> +
> +DW9807 is a 10-bit DAC with current sink capability. It is intended 
> +for controlling voice coil lenses.
> +
> +Mandatory properties:
> +
> +- compatible: "dongwoon,dw9807"
> +- reg: I2C slave address

--
Sakari Ailus
sakari.ailus@linux.intel.com
