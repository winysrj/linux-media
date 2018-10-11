Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:1740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbeJKRQH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 13:16:07 -0400
Subject: Re: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
To: kieran.bingham+renesas@ideasonboard.com,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>
Cc: tfiga@chromium.org
References: <20181009234245.25830-1-rajmohan.mani@intel.com>
 <33c53caf-633a-f359-4312-9c2dc317efc5@ideasonboard.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <39c26dd4-4454-f557-f510-ae973f5d9c89@linux.intel.com>
Date: Thu, 11 Oct 2018 17:53:45 +0800
MIME-Version: 1.0
In-Reply-To: <33c53caf-633a-f359-4312-9c2dc317efc5@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/11/2018 05:33 PM, Kieran Bingham wrote:
> Hi Rajmohan
>
> Thank you for the patch,
>
> On 10/10/18 00:42, Rajmohan Mani wrote:
>> Removed redundant CIO2_IMAGE_MAX_* definitions
>>
>> Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
>>
>> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Looks like this {sh,c}ould be bundled in with
>  "[PATCH 0/2] Trivial CIO2 patches" from Sakari at integration.
Raj and Sakari, I think this change could be bundled into the Trivial
patch sets, what do you think?
>
> --
> Regards
>
> Kieran Bingham
>
>> ---
>>  drivers/media/pci/intel/ipu3/ipu3-cio2.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
>> index 240635be7a31..7caab9b8c2b9 100644
>> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
>> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
>> @@ -10,8 +10,6 @@
>>  #define CIO2_PCI_ID					0x9d32
>>  #define CIO2_PCI_BAR					0
>>  #define CIO2_DMA_MASK					DMA_BIT_MASK(39)
>> -#define CIO2_IMAGE_MAX_WIDTH				4224
>> -#define CIO2_IMAGE_MAX_LENGTH				3136
>>  
>>  #define CIO2_IMAGE_MAX_WIDTH				4224
>>  #define CIO2_IMAGE_MAX_LENGTH				3136
>>
>
