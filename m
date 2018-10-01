Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0068.outbound.protection.outlook.com ([104.47.42.68]:45726
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728979AbeJAUoq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 16:44:46 -0400
Subject: Re: [PATCH] [media] v4l: xilinx: fix typo in formats table
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Andrea Merello <andrea.merello@gmail.com>, <hyun.kwon@xilinx.com>,
        <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        Mirco Di Salvo <mirco.disalvo@iit.it>
References: <20180928073213.10022-1-andrea.merello@gmail.com>
 <118342352.6u92UtmAFX@avalon>
 <1e89141f-e05f-ecd0-9ac1-561db42494fe@xilinx.com>
 <41582264.lkmszr6VXR@avalon>
From: Michal Simek <michal.simek@xilinx.com>
Message-ID: <fc59d581-f2fe-52f1-2e73-7d3688cecacf@xilinx.com>
Date: Mon, 1 Oct 2018 16:06:28 +0200
MIME-Version: 1.0
In-Reply-To: <41582264.lkmszr6VXR@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1.10.2018 15:36, Laurent Pinchart wrote:
> Hi Michal,
> 
> On Monday, 1 October 2018 16:28:32 EEST Michal Simek wrote:
>> On 1.10.2018 15:26, Laurent Pinchart wrote:
>>> On Monday, 1 October 2018 15:45:49 EEST Michal Simek wrote:
>>>> On 28.9.2018 14:52, Laurent Pinchart wrote:
>>>>> On Friday, 28 September 2018 10:32:13 EEST Andrea Merello wrote:
>>>>>> In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
>>>>>> This patch fixes it.
>>>>>>
>>>>>> Cc: linux-media@vger.kernel.org
>>>>>> Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
>>>>>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>>>>>
>>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>>
>>>>> Michal, should I take the patch in my tree ?
>>>>
>>>> definitely. I am not collecting patches for media tree.
>>>
>>> Taken in my tree.
>>>
>>> By the way, have we reached any conclusion regarding
>>> https://lkml.org/lkml/
>>> 2017/12/18/112 ?
>>
>> Xilinx has started to use SPDX without any issue. It means conversion
>> should be fine to do.
> 
> That's good to know, I'll resubmit the patch then, and CC you to get an ack.
> 

Sure go ahead.
M
