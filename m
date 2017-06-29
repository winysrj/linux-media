Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37281 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdF2ML0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 08:11:26 -0400
Received: by mail-wm0-f47.google.com with SMTP id i127so12363753wma.0
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 05:11:25 -0700 (PDT)
Subject: Re: [PATCH v2 01/19] doc: DT: camss: Binding document for Qualcomm
 Camera subsystem driver
To: Rob Herring <robh@kernel.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-2-git-send-email-todor.tomov@linaro.org>
 <20170623204153.jpjecbzgnaptypbu@rob-hp-laptop>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <3b349fe9-c11c-199f-50c7-1ddf09494c53@linaro.org>
Date: Thu, 29 Jun 2017 15:11:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170623204153.jpjecbzgnaptypbu@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for review, Rob.

On 06/23/2017 11:41 PM, Rob Herring wrote:
> On Mon, Jun 19, 2017 at 05:48:21PM +0300, Todor Tomov wrote:
>> Add DT binding document for Qualcomm Camera subsystem driver.
> 
> "dt-bindings: media: ..." for the subject please.

I'll change it in the next version.

> 
>>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: devicetree@vger.kernel.org
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,camss.txt       | 196 +++++++++++++++++++++
>>  1 file changed, 196 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> new file mode 100644
>> index 0000000..5213b03
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> @@ -0,0 +1,196 @@
>> +Qualcomm Camera Subsystem
>> +
>> +* Properties
>> +
>> +- compatible:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain:
>> +		- "qcom,msm8916-camss"
> 
> Okay if it is one node, but I'd like to see some agreement from other QC 
> folks that 1 node is appropriate.

Ok.

> 
>> +- reg:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Register ranges as listed in the reg-names property.
>> +- reg-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "csiphy0"
>> +		- "csiphy0_clk_mux"
>> +		- "csiphy1"
>> +		- "csiphy1_clk_mux"
>> +		- "csid0"
>> +		- "csid1"
>> +		- "ispif"
>> +		- "csi_clk_mux"
>> +		- "vfe0"
>> +- interrupts:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Interrupts as listed in the interrupt-names property.
>> +- interrupt-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "csiphy0"
>> +		- "csiphy1"
>> +		- "csid0"
>> +		- "csid1"
>> +		- "ispif"
>> +		- "vfe0"
>> +- power-domains:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A phandle and power domain specifier pairs to the
>> +		    power domain which is responsible for collapsing
>> +		    and restoring power to the peripheral.
>> +- clocks:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A list of phandle and clock specifier pairs as listed
>> +		    in clock-names property.
>> +- clock-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "camss_top_ahb_clk"
>> +		- "ispif_ahb_clk"
>> +		- "csiphy0_timer_clk"
>> +		- "csiphy1_timer_clk"
>> +		- "csi0_ahb_clk"
>> +		- "csi0_clk"
>> +		- "csi0_phy_clk"
>> +		- "csi0_pix_clk"
>> +		- "csi0_rdi_clk"
>> +		- "csi1_ahb_clk"
>> +		- "csi1_clk"
>> +		- "csi1_phy_clk"
>> +		- "csi1_pix_clk"
>> +		- "csi1_rdi_clk"
>> +		- "camss_ahb_clk"
>> +		- "camss_vfe_vfe_clk"
>> +		- "camss_csi_vfe_clk"
>> +		- "iface_clk"
>> +		- "bus_clk"
> 
> "_clk" is redundant.

Yes, it will be better without it.

-- 
Best regards,
Todor Tomov
