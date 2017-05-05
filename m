Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34853 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753323AbdEEN3I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 09:29:08 -0400
Received: by mail-wm0-f49.google.com with SMTP id w64so23984945wma.0
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 06:29:07 -0700 (PDT)
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
To: Bjorn Andersson <bjorn.andersson@linaro.org>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
 <20170429222141.GK7456@valkosipuli.retiisi.org.uk>
 <d4f46814-41b3-b3a2-2e8f-d9f3cb7638a0@linaro.org>
 <20170502185241.GX15143@minitux>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7fbca77f-b783-efcb-a39a-4d42ed8db310@linaro.org>
Date: Fri, 5 May 2017 16:29:05 +0300
MIME-Version: 1.0
In-Reply-To: <20170502185241.GX15143@minitux>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn

On 05/02/2017 09:52 PM, Bjorn Andersson wrote:
> On Tue 02 May 01:52 PDT 2017, Stanimir Varbanov wrote:
> 
>> Hei Sakari,
>>
>> On 04/30/2017 01:21 AM, Sakari Ailus wrote:
>>> Hi, Stan!!
>>>
>>> On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
>>> ...
>>>> +int helper_get_bufreq(struct venus_inst *inst, u32 type,
>>>> +		      struct hfi_buffer_requirements *req)
>>>> +{
>>>> +	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
>>>> +	union hfi_get_property hprop;
>>>> +	int ret, i;
>>>
>>> unsigned int i ? It's an array index...
>>
>> Thanks for pointing that out, I have to revisit all similar places as
>> well ...
>>
> 
> It's perfectly fine to index an array with an int and you are comparing
> the index with a integer constant in the loop - so don't clutter the
> code unnecessarily.

I personally prefer unsigned for iterator variable type (because
unsigned type has defined behavior on overflow), but having the fact
that I'm comparing with int I will keep it int.

Also it seems that -Wsign-compare is not enabled by default in kernel,
no? So I have modified my Makefile and catch few occurrences of warnings
about signed with unsigned compare and fixed them.

-- 
regards,
Stan
