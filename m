Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36259 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbcKORPI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 12:15:08 -0500
Received: by mail-wm0-f44.google.com with SMTP id g23so180478560wme.1
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2016 09:15:07 -0800 (PST)
Subject: Re: [PATCH v3 1/9] doc: DT: vidc: binding document for Qualcomm video
 driver
To: Rob Herring <robh@kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-2-git-send-email-stanimir.varbanov@linaro.org>
 <20161114170410.56izii5gcwpofvc4@rob-hp-laptop>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d0bd8de7-7679-336d-1cbd-c25280172cf0@linaro.org>
Date: Tue, 15 Nov 2016 19:15:03 +0200
MIME-Version: 1.0
In-Reply-To: <20161114170410.56izii5gcwpofvc4@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thanks for the comments!

On 11/14/2016 07:04 PM, Rob Herring wrote:
> On Mon, Nov 07, 2016 at 07:33:55PM +0200, Stanimir Varbanov wrote:
>> Add binding document for Venus video encoder/decoder driver
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,venus.txt       | 98 ++++++++++++++++++++++
>>  1 file changed, 98 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> new file mode 100644
>> index 000000000000..b2af347fbce4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> @@ -0,0 +1,98 @@
>> +* Qualcomm Venus video encode/decode accelerator
>> +
>> +- compatible:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Value should contain one of:
>> +		- "qcom,venus-msm8916"
>> +		- "qcom,venus-msm8996"
> 
> The normal ordering is <vendor>,<soc>-<block>

OK.

> 
>> +- reg:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Register ranges as listed in the reg-names property.
>> +- reg-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain following entries:
>> +		- "venus"	Venus register base
>> +- reg-names:
> 
> I'd prefer these grouped as one entry for reg-names.
> 
>> +	Usage: optional for msm8996
> 
> Why optional?

The Venus hw block can work without internal video memory in which case
just performance will be impacted.

> 
>> +	Value type: <stringlist>
>> +	Definition: Should contain following entries:
>> +		- "vmem"	Video memory register base
>> +- interrupts:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Should contain interrupts as listed in the interrupt-names
>> +		    property.
>> +- interrupt-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain following entries:
>> +		- "venus"	Venus interrupt line
>> +- interrupt-names:
>> +	Usage: optional for msm8996
>> +	Value type: <stringlist>
>> +	Definition: Should contain following entries:
>> +		- "vmem"	Video memory interrupt line
>> +- clocks:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A List of phandle and clock specifier pairs as listed
>> +		    in clock-names property.
>> +- clock-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "core"	Core video accelerator clock
>> +		- "iface"	Video accelerator AHB clock
>> +		- "bus"		Video accelerator AXI clock
>> +- clock-names:
>> +	Usage: required for msm8996
> 
> Plus the 3 above?

Yes, 'required' without 'for xxx' means that the clocks are required for
all hw versions (SoCs) and msm8996 needs the extra clocks below.

> 
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "subcore0"		Subcore0 video accelerator clock
>> +		- "subcore1"		Subcore1 video accelerator clock
>> +		- "mmssnoc_axi"		Multimedia subsystem NOC AXI clock
>> +		- "mmss_mmagic_iface"	Multimedia subsystem MMAGIC AHB clock
>> +		- "mmss_mmagic_mbus"	Multimedia subsystem MMAGIC MAXI clock
>> +		- "mmagic_video_bus"	MMAGIC video AXI clock
>> +		- "video_mbus"		Video MAXI clock
>> +- clock-names:
>> +	Usage: optional for msm8996
> 
> Clocks shouldn't be optional unless you failed to add in an initial 
> binding.

These clocks are needed by video memory block which I noted as
'optional'. There is another way to model this video memory hw block
i.e. by a child node of the venus node. Is that sounds better?

<snip>

-- 
regards,
Stan
