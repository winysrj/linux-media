Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34121 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751027AbeDYCbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 22:31:31 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Rob Herring <robh@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [RESEND PATCH v7 1/2] media: dt-bindings: Add bindings for
 Dongwoon DW9807 voice coil
Date: Wed, 25 Apr 2018 02:31:26 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D572C15@PGSMSX111.gar.corp.intel.com>
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com>
 <1523375324-27856-2-git-send-email-andy.yeh@intel.com>
 <20180413151042.lqovgxupubjbgrey@rob-hp-laptop>
In-Reply-To: <20180413151042.lqovgxupubjbgrey@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Apologize missed your comment before sent out v8. I will definitely add acks/reviewed-bys in next version.

Regards, Andy

-----Original Message-----
From: Rob Herring [mailto:robh@kernel.org] 
Sent: Friday, April 13, 2018 11:11 PM
To: Yeh, Andy <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; devicetree@vger.kernel.org; tfiga@chromium.org; jacopo@jmondi.org; Chiang, AlanX <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v7 1/2] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil

On Tue, Apr 10, 2018 at 11:48:43PM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
> 
> Dongwoon DW9807 is a voice coil lens driver.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt

Please add acks/reviewed-bys when posting new versions.

Rob
