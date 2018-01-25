Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42500 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeAYMFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 07:05:41 -0500
Subject: Re: [PATCH v3 2/3] media: MAINTAINERS: add entry for ov9650 driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <b6ad0b4f-4731-9ecc-0347-1023f2a38887@samsung.com>
Date: Thu, 25 Jan 2018 13:05:22 +0100
MIME-version: 1.0
In-reply-to: <1516547656-3879-3-git-send-email-akinobu.mita@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
        <1516547656-3879-3-git-send-email-akinobu.mita@gmail.com>
        <CGME20180125120538epcas1p3f4f24d080cf92be8ba91bfc66eded51e@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2018 04:14 PM, Akinobu Mita wrote:
> This adds an entry to the MAINTAINERS file for ov9650 driver.  The
> following persons are added in this entry.
> 
> * Sakari as a person who looks after media sensor driver patches
> * Sylwester as a module author
> * Myself as a person who has the hardware and can test the patches
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Feel free to add my:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e358141..8924e39 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10052,6 +10052,15 @@ S:	Maintained
>  F:	drivers/media/i2c/ov7670.c
>  F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
>  
> +OMNIVISION OV9650 SENSOR DRIVER
> +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +R:	Akinobu Mita <akinobu.mita@gmail.com>
> +R:	Sylwester Nawrocki <s.nawrocki@samsung.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/ov9650.c

Regards,
Sylwester
