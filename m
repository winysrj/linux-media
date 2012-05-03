Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2ECMVE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 08:21:04 -0400
Message-ID: <4FA2781C.7000301@redhat.com>
Date: Thu, 03 May 2012 09:20:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com,
	Mike Isely <isely@pobox.com>
Subject: Re: [RFC v3 2/2] v4l: Implement compat functions for enum to __u32
 change
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-2-git-send-email-sakari.ailus@iki.fi> <4FA1B5F7.8050608@redhat.com> <5025043.7iaR9beiqz@avalon>
In-Reply-To: <5025043.7iaR9beiqz@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-05-2012 20:38, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Wednesday 02 May 2012 19:32:23 Mauro Carvalho Chehab wrote:
>> Em 02-05-2012 16:13, Sakari Ailus escreveu:
>>> Implement compat functions to provide conversion between structs
>>> containing enums and those not. The functions are intended to be removed
>>> when the support for such old binaries is no longer necessary.
>>
>> This is not a full review of this patch, as checking the full logic
>> will consume some time.
>>
>> This is just a few points to consider.
> 
> [snip]
> 
>>> -video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>>> +video_usercopy(struct file *file, unsigned int compat_cmd, unsigned long
>>> arg,> 
>>>  	       v4l2_kioctl func)
>>>  
>>>  {
>>>  
>>>  	char	sbuf[128];
>>>
>>> @@ -2401,6 +3048,7 @@ video_usercopy(struct file *file, unsigned int cmd,
>>> unsigned long arg,> 
>>>  	size_t  array_size = 0;
>>>  	void __user *user_ptr = NULL;
>>>  	void	**kernel_ptr = NULL;
>>>
>>> +	unsigned int cmd = get_non_compat_cmd(compat_cmd);
>>
>> This will put a penalty on archs where sizeof(u32) == sizeof(enum), with
>> covers most of the cases.
>>
>> My suggestion is to, instead, call it at the end of  __video_do_ioctl, at
>> the "default" clause, with a recursive call to __video_do_ioctl().
> 
> Would that work for "has_array_args" ioctls ? video_usercopy() won't copy the 
> array. The compat code could possibly handle that though.
> 
> What about making get_non_compat_cmd() return its argument directly when 
> sizeof(__u32) == sizeof(enum) ? The performance impact should be negligible.

Good idea. GCC optimizer will probably just discard the entire code, by merging
'compat_cmd' var with 'cmd' var.

Regards,
Mauro
