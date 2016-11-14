Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45656 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753692AbcKNPAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 10:00:05 -0500
Subject: Re: [PATCH v3 0/9] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Javier Martinez Canillas <javier@dowhile0.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <f5120730-0e1d-f93c-eed9-7b71ff79f5db@xs4all.nl>
 <CABxcv=nop8h5U0Kt5yjmSVX3ZZbUb7O6yVzOf5AxzsiWUucjwA@mail.gmail.com>
 <2b178a80-2fa1-de90-a675-470150d07cf9@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9bca815b-7f51-bf9a-45b5-f97d98f6c3ef@xs4all.nl>
Date: Mon, 14 Nov 2016 15:59:58 +0100
MIME-Version: 1.0
In-Reply-To: <2b178a80-2fa1-de90-a675-470150d07cf9@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2016 03:59 PM, Stanimir Varbanov wrote:
> Hi,
> 
> On 11/11/2016 02:11 PM, Javier Martinez Canillas wrote:
>> Hello Hans,
>>
>> On Fri, Nov 11, 2016 at 8:49 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Hi Stanimir,
>>>
>>> Overall it looks good. As you saw, I do have some comments but nothing major.
>>>
>>> One question: you use qcom as the directory name. How about using qualcomm?
>>>
>>> It's really not that much longer and a bit more obvious.
>>>
>>> Up to you, though.
>>>
>>
>> It seems qcom is more consistent to the name used in most subsystems
>> for Qualcomm:
>>
>> $ find -name *qcom
>> ./arch/arm/mach-qcom
>> ./arch/arm64/boot/dts/qcom
>> ./Documentation/devicetree/bindings/soc/qcom
>> ./sound/soc/qcom
>> ./drivers/pinctrl/qcom
>> ./drivers/soc/qcom
>> ./drivers/clk/qcom
>>
>> $ find -name *qualcomm
>> ./drivers/net/ethernet/qualcomm
> 
> Also qcom is the vendor prefix used in [1]
> 
> [1] Documentation/devicetree/bindings/vendor-prefixes.txt
> 

qcom it is, then :-)

	Hans
