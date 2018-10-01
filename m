Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr690081.outbound.protection.outlook.com ([40.107.69.81]:59672
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729182AbeJAUGm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 16:06:42 -0400
Subject: Re: [PATCH] [media] v4l: xilinx: fix typo in formats table
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Andrea Merello <andrea.merello@gmail.com>, <hyun.kwon@xilinx.com>,
        <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        Mirco Di Salvo <mirco.disalvo@iit.it>
References: <20180928073213.10022-1-andrea.merello@gmail.com>
 <1859576.n3v8JWS4oW@avalon> <05f39fbf-7097-9d89-c019-c2398aed2201@xilinx.com>
 <118342352.6u92UtmAFX@avalon>
From: Michal Simek <michal.simek@xilinx.com>
Message-ID: <1e89141f-e05f-ecd0-9ac1-561db42494fe@xilinx.com>
Date: Mon, 1 Oct 2018 15:28:32 +0200
MIME-Version: 1.0
In-Reply-To: <118342352.6u92UtmAFX@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 1.10.2018 15:26, Laurent Pinchart wrote:
> Hi Michal,
> 
> On Monday, 1 October 2018 15:45:49 EEST Michal Simek wrote:
>> On 28.9.2018 14:52, Laurent Pinchart wrote:
>>> On Friday, 28 September 2018 10:32:13 EEST Andrea Merello wrote:
>>>> In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
>>>> This patch fixes it.
>>>>
>>>> Cc: linux-media@vger.kernel.org
>>>> Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
>>>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>>>
>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>
>>> Michal, should I take the patch in my tree ?
>>
>> definitely. I am not collecting patches for media tree.
> 
> Taken in my tree.
> 
> By the way, have we reached any conclusion regarding https://lkml.org/lkml/
> 2017/12/18/112 ?

Xilinx has started to use SPDX without any issue. It means conversion
should be fine to do.

Thanks,
Michal
