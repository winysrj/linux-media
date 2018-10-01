Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:56483
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729152AbeJATXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 15:23:47 -0400
Subject: Re: [PATCH] [media] v4l: xilinx: fix typo in formats table
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrea Merello <andrea.merello@gmail.com>
CC: <hyun.kwon@xilinx.com>, <mchehab@kernel.org>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        Mirco Di Salvo <mirco.disalvo@iit.it>
References: <20180928073213.10022-1-andrea.merello@gmail.com>
 <1859576.n3v8JWS4oW@avalon>
From: Michal Simek <michal.simek@xilinx.com>
Message-ID: <05f39fbf-7097-9d89-c019-c2398aed2201@xilinx.com>
Date: Mon, 1 Oct 2018 14:45:49 +0200
MIME-Version: 1.0
In-Reply-To: <1859576.n3v8JWS4oW@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 28.9.2018 14:52, Laurent Pinchart wrote:
> Hi Andrea,
> 
> Thank you for the patch.
> 
> On Friday, 28 September 2018 10:32:13 EEST Andrea Merello wrote:
>> In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
>> This patch fixes it.
>>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Michal, should I take the patch in my tree ?

definitely. I am not collecting patches for media tree.

Thanks,
Michal
