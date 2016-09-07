Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37419 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757190AbcIGI5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 04:57:23 -0400
Received: by mail-wm0-f51.google.com with SMTP id w12so19389280wmf.0
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 01:57:22 -0700 (PDT)
Subject: Re: [PATCH 0/8] Qualcomm video decoder/encoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
 <51878905-ca77-b972-f374-9bf2b4be9204@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8c79f249-ade9-59db-7bef-d46e8b1fc936@linaro.org>
Date: Wed, 7 Sep 2016 11:57:19 +0300
MIME-Version: 1.0
In-Reply-To: <51878905-ca77-b972-f374-9bf2b4be9204@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/05/2016 05:47 PM, Hans Verkuil wrote:
> On 08/22/2016 03:13 PM, Stanimir Varbanov wrote:
>> This patchset introduces a basic support for Qualcomm video
>> acceleration hardware used for video stream decoding/encoding.
>> The video IP can found on various qcom SoCs like apq8084, msm8916
>> and msm8996, hence it is widly distributed but the driver is 
>> missing in the mainline.
>>
>> The v4l2 driver is something like a wrapper over Host Firmware
>> Interface. The HFI itself is a set of command and message packets
>> send/received through shared memory, and its purpose is to
>> comunicate with the firmware which is run on remote processor.
>> The Venus is the name of the video hardware IP that doing the
>> video acceleration.
>>
>> From the software point of view the HFI interface is implemented
>> in the files with prefix hfi_xxx. It acts as a translation layer
>> between HFI and v4l2 layer. There is one special file in the 
>> driver called hfi_venus which doing most of the driver
>> orchestration work. Something more it setups Venus core, run it
>> and handle commands and messages from low-level point of view with
>> the help of provided functions by HFI interface.
>>
>> I think that the driver is in good shape for mainline kernel, and
>> I hope the review comments will help to improve it, so please
>> do review and make comments.
> 
> I was hoping that I could finish reviewing this patch series today,
> but that didn't work out.
> 
> I have more time next week, but I wonder if it isn't better if you make a
> v2 first, taking my comments into account. Then I can review v2 next week.

OK, I have more of your comments addressed plus few of Bjorn's too.

> 
> Also test with the latest v4l2-compliance (i.e. as of today) since I improved
> a few tests relating to g/s_selection and g/s_parm.

Sure, I will retest and post the results in cover letter.

-- 
regards,
Stan
