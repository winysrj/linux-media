Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:37362 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754710AbeDWLlj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:41:39 -0400
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-3-hverkuil@xs4all.nl>
 <20180410063856.32e44ce9@vento.lan>
 <20180410110016.p7dabvuzxazggytn@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c667b621-8cca-c15f-cbd6-34fb92243d55@xs4all.nl>
Date: Mon, 23 Apr 2018 13:41:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180410110016.p7dabvuzxazggytn@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2018 01:00 PM, Sakari Ailus wrote:
> On Tue, Apr 10, 2018 at 06:38:56AM -0300, Mauro Carvalho Chehab wrote:
>> Em Mon,  9 Apr 2018 16:19:59 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Define the public request API.
>>>
>>> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
>>> and two ioctls that operate on a request in order to queue the
>>> contents of the request to the driver and to re-initialize the
>>> request.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>>  include/uapi/linux/media.h | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>> index c7e9a5cba24e..f8769e74f847 100644
>>> --- a/include/uapi/linux/media.h
>>> +++ b/include/uapi/linux/media.h
>>> @@ -342,11 +342,19 @@ struct media_v2_topology {
>>>  
>>>  /* ioctls */
>>>  
>>> +struct __attribute__ ((packed)) media_request_alloc {
>>> +	__s32 fd;
>>> +};
>>> +
>>>  #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
>>>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
>>>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>>>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
>>>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
>>> +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
>>> +
>>
>> Why use a struct here? Just declare it as:
>>
>> 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)
> 
> I'd say it's easier to extend it if it's a struct. All other IOCTLs also
> have a struct as an argument. As a struct member, the parameter (fd) also
> has a name; this is a plus.

While I do not have a very strong opinion on this, I do agree with Sakari here.

Regards,

	Hans

> 
>>
>>> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
>>> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
>>>  
>>>  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
>>>  
>>
>> Thanks,
>> Mauro
> 
