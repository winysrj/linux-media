Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33720 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933320AbdGTKP0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 06:15:26 -0400
Date: Thu, 20 Jul 2017 13:15:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 04/23] dt-bindings: media: Binding document for
 Qualcomm Camera subsystem driver
Message-ID: <20170720101522.gwizeu4ganovshe2@valkosipuli.retiisi.org.uk>
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
> 
> diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
> new file mode 100644
> index 0000000..f698498
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/qcom,camss.txt

qcom,camss.txt or qcom,camss-8x16.txt?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
