Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-193.synserver.de ([212.40.185.193]:1074 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbbG1Hrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 03:47:46 -0400
Message-ID: <55B7339E.4010300@metafoo.de>
Date: Tue, 28 Jul 2015 09:47:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Looijmans <mike.looijmans@topic.nl>,
	linux-media@vger.kernel.org
CC: dragos.bogdan@analog.com, mchehab@osg.samsung.com
Subject: Re: [PATCH] [media] imageon-bridge: Add module license information
References: <1438061985-2786-1-git-send-email-mike.looijmans@topic.nl> <55B72BBE.8050902@xs4all.nl>
In-Reply-To: <55B72BBE.8050902@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2015 09:14 AM, Hans Verkuil wrote:
> On 07/28/2015 07:39 AM, Mike Looijmans wrote:
>> Comment header specifies GPL-2, so add a MODULE_LICENSE("GPL v2").
>> This fixes the driver failing to load when built as module:
>>    imageon_bridge: module license 'unspecified' taints kernel.
>>    imageon_bridge: Unknown symbol ...
>> As an extra service, also add a description.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>>   drivers/media/platform/imageon-bridge.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/platform/imageon-bridge.c b/drivers/media/platform/imageon-bridge.c
>> index 9550695..a69b6da 100644
>> --- a/drivers/media/platform/imageon-bridge.c
>> +++ b/drivers/media/platform/imageon-bridge.c
>> @@ -317,3 +317,6 @@ static struct platform_driver imageon_bridge_driver = {
>>   	.remove = imageon_bridge_remove,
>>   };
>>   module_platform_driver(imageon_bridge_driver);
>> +
>> +MODULE_DESCRIPTION("Imageon video bridge");
>> +MODULE_LICENSE("GPL v2");
>>
>
> Lovely, but unfortunately the imageon driver is not part of the official linux kernel.
>
> So we can't do anything with this patch.

I've applied the patch, thanks. Hopefully the driver will find its way 
upstream soon.

- Lars

