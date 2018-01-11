Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:39132 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754264AbeAKUkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 15:40:24 -0500
Date: Thu, 11 Jan 2018 14:40:22 -0600
From: Rob Herring <robh@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 2/2] media: ov9650: add device tree binding
Message-ID: <20180111204022.rhcttpptc4id6fk6@rob-hp-laptop>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
 <1515344064-23156-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515344064-23156-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 08, 2018 at 01:54:24AM +0900, Akinobu Mita wrote:
> Now the ov9650 driver supports device tree probing.  So this adds a
> device tree binding documentation.
> 
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * Changelog v2
> - Split binding documentation, suggested by Rob Herring and Jacopo Mondi
> - Improve the wording for compatible property in the binding documentation,
>   suggested by Jacopo Mondi
> - Improve the description for the device node in the binding documentation,
>   suggested by Sakari Ailus
> 
>  .../devicetree/bindings/media/i2c/ov9650.txt       | 36 ++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt

Reviewed-by: Rob Herring <robh@kernel.org>
