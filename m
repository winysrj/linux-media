Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33871 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934556AbdKCAX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 20:23:57 -0400
Subject: Re: [PATCH 1/2] media: s5p-mfc: check for firmware allocation before
 requesting firmware
To: Andrzej Hajda <a.hajda@samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
 <CGME20171006213015epcas3p2c0d4741e06b2d8c25583fb656b7f5532@epcas3p2.samsung.com>
 <e7c1ad0167ca363cc783be11871a04957127a3fa.1507325072.git.shuahkh@osg.samsung.com>
 <5bbc048a-4b68-de23-373d-eb8a12c5b736@samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <9b86cd70-9063-bf45-6851-73c2f982de5b@osg.samsung.com>
Date: Thu, 2 Nov 2017 18:23:54 -0600
MIME-Version: 1.0
In-Reply-To: <5bbc048a-4b68-de23-373d-eb8a12c5b736@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2017 02:12 AM, Andrzej Hajda wrote:
> Hi Shuah,
> 
> On 06.10.2017 23:30, Shuah Khan wrote:
>> Check if firmware is allocated before requesting firmware instead of
>> requesting firmware only to release it if firmware is not allocated.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> index 69ef9c2..f064a0d1 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> @@ -55,6 +55,11 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
>>  	 * into kernel. */
>>  	mfc_debug_enter();
>>  
>> +	if (!dev->fw_buf.virt) {
>> +		mfc_err("MFC firmware is not allocated\n");
>> +		return -EINVAL;
>> +	}
>> +
>>  	for (i = MFC_FW_MAX_VERSIONS - 1; i >= 0; i--) {
>>  		if (!dev->variant->fw_name[i])
>>  			continue;
>> @@ -75,11 +80,6 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
>>  		release_firmware(fw_blob);
>>  		return -ENOMEM;
>>  	}
>> -	if (!dev->fw_buf.virt) {
>> -		mfc_err("MFC firmware is not allocated\n");
>> -		release_firmware(fw_blob);
>> -		return -EINVAL;
>> -	}
> 
> Is there any scenario in which dev->fw_buf.virt is null and
> s5p_mfc_load_firmware is called?
> I suspect this check is not necessary at all.
> 

I don't believe so. Allocation is done in s5p_mfc_configure_dma_memory()
code path and if that fails it bails out of _probe. I can remove the check
all together.

thanks,
-- Shuah
