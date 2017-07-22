Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34605 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755152AbdGVLbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:06 -0400
Subject: Re: [PATCHv2 5/5] media-device: remove driver_version
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org
References: <20170721105706.40703-1-hverkuil@xs4all.nl>
 <CGME20170721105717epcas3p354c2aa0c7a7fc333a5442866e77498dc@epcas3p3.samsung.com>
 <20170721105706.40703-6-hverkuil@xs4all.nl>
 <a9f06de4-30a9-316c-642d-0f6cd2345fd0@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1bc4b77-5637-2a5a-1afb-1ab0e09ce0c1@xs4all.nl>
Date: Sat, 22 Jul 2017 13:31:03 +0200
MIME-Version: 1.0
In-Reply-To: <a9f06de4-30a9-316c-642d-0f6cd2345fd0@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/07/17 13:16, Sylwester Nawrocki wrote:
> On 07/21/2017 12:57 PM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Since the driver_version field in struct media_device is no longer
>> used, just remove it.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/media-device.c | 3 ---
>>   include/media/media-device.h | 2 --
>>   2 files changed, 5 deletions(-)
> 
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index 6896266031b9..7d268802cc2e 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -68,7 +68,6 @@ struct media_device_ops {
>>    * @serial:    Device serial number (optional)
>>    * @bus_info:    Unique and stable device location identifier
>>    * @hw_revision: Hardware device revision
>> - * @driver_version: Device driver version
>>    * @topology_version: Monotonic counter for storing the version of the graph
>>    *        topology. Should be incremented each time the topology changes.
>>    * @id:        Unique ID used on the last registered graph object
>> @@ -134,7 +133,6 @@ struct media_device {
>>       char serial[40];
>>       char bus_info[32];
>>       u32 hw_revision;
>> -    u32 driver_version;
> 
> It seems we still have such paragraph in include/media/media-device.h:
> 
>  *  - &media_entity.driver_version is formatted with the KERNEL_VERSION()
>  *    macro. The version minor must be incremented when new features are added
>  *    to the userspace API without breaking binary compatibility. The version
>  *    major must be incremented when binary compatibility is broken.
> 
> Shouldn't this also be removed?

Good catch! Yes, that should be removed as well.

Regards,

	Hans
