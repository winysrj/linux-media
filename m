Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:46230 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbeEOJk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:40:28 -0400
Received: by mail-wr0-f179.google.com with SMTP id a12-v6so15238774wrn.13
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 02:40:27 -0700 (PDT)
Subject: Re: [PATCH v2 27/29] venus: implementing multi-stream support
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-28-stanimir.varbanov@linaro.org>
 <3008410e-3311-b836-a6a8-f95f1161a2e9@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <e59f146d-bcf1-e402-2e82-23802291cf7a@linaro.org>
Date: Tue, 15 May 2018 12:40:24 +0300
MIME-Version: 1.0
In-Reply-To: <3008410e-3311-b836-a6a8-f95f1161a2e9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/15/2018 11:17 AM, Hans Verkuil wrote:
> Hi Stanimir,
> 
> On 05/15/18 09:58, Stanimir Varbanov wrote:
>> This is implementing a multi-stream decoder support. The multi
>> stream gives an option to use the secondary decoder output
>> with different raw format (or the same in case of crop).
> 
> You told me that multi-stream support is currently internal only.
> 
> It would be good if you could elaborate a bit about that in this
> commit log and (I think) also add some comments in the code that
> reflect this.
> 
> It's also not clear to me how and why this is used in the driver
> if this is just internal. Does it enable a feature you would
> otherwise not be able to use?
> 
> I have no complaints about the code, I would just like to see a
> bit more background information in the source and commit log.

Thanks for the fast comments! Sure I will try to document multi-stream
support in the patch description and in the code if it makes sense.

-- 
regards,
Stan
