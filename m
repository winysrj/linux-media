Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35677 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdGXQnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 12:43:17 -0400
Date: Mon, 24 Jul 2017 11:43:15 -0500
From: Rob Herring <robh@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 04/23] dt-bindings: media: Binding document for
 Qualcomm Camera subsystem driver
Message-ID: <20170724164315.axenfak62hu57rdd@rob-hp-laptop>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-5-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500287629-23703-5-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 17, 2017 at 01:33:30PM +0300, Todor Tomov wrote:
> Add DT binding document for Qualcomm Camera subsystem driver.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: devicetree@vger.kernel.org
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,camss.txt       | 191 +++++++++++++++++++++
>  1 file changed, 191 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt

Acked-by: Rob Herring <robh@kernel.org>
