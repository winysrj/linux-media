Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40139 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0FORQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jun 2010 13:16:00 -0400
Message-ID: <4C17AFE3.6080007@gmail.com>
Date: Tue, 15 Jun 2010 09:52:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8]ieee1394/sdp2 Fix warning: variable 'unit_characteristics'
 set but not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>	<1276547208-26569-8-git-send-email-justinmattock@gmail.com> <20100615133830.55afdddf@hyperion.delvare>
In-Reply-To: <20100615133830.55afdddf@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2010 04:38 AM, Jean Delvare wrote:
> On Mon, 14 Jun 2010 13:26:47 -0700, Justin P. Mattock wrote:
>> Temporary fix until something is resolved
>
> This is wrong by design, sorry. Warnings aren't blocking, and thus need
> no "temporary fix". Such temporary fixes would be only hiding the
> warning, cancelling the good work of gcc developers. Nack nack nack.
>

o.k.

>> to fix the below warning:
>>    CC [M]  drivers/ieee1394/sbp2.o
>> drivers/ieee1394/sbp2.c: In function 'sbp2_parse_unit_directory':
>> drivers/ieee1394/sbp2.c:1353:6: warning: variable 'unit_characteristics' set but not used
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/ieee1394/sbp2.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
>> index 4565cb5..fcf8bd5 100644
>> --- a/drivers/ieee1394/sbp2.c
>> +++ b/drivers/ieee1394/sbp2.c
>> @@ -1356,6 +1356,8 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
>>
>>   	management_agent_addr = 0;
>>   	unit_characteristics = 0;
>> +	if (!unit_characteristics)
>> +		unit_characteristics = 0;
>>   	firmware_revision = SBP2_ROM_VALUE_MISSING;
>>   	model = ud->flags&  UNIT_DIRECTORY_MODEL_ID ?
>>   				ud->model_id : SBP2_ROM_VALUE_MISSING;
>
>

Thanks for the response and info on this.

Justin P. Mattock
