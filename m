Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37056 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbcB0Vmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 16:42:39 -0500
Received: by mail-wm0-f43.google.com with SMTP id p65so1380648wmp.0
        for <linux-media@vger.kernel.org>; Sat, 27 Feb 2016 13:42:39 -0800 (PST)
Subject: Re: Problem since commit c73bbaa4ec3e [rc-core: don't lock device at
 rc_register_device()]
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <56D19314.3050409@gmail.com> <56D1CA81.10802@gmail.com>
 <20160227150524.7d8d6fbb@recife.lan> <56D1ED54.9080503@gmail.com>
 <20160227165014.11b66f37@recife.lan>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56D21840.6080000@gmail.com>
Date: Sat, 27 Feb 2016 22:42:24 +0100
MIME-Version: 1.0
In-Reply-To: <20160227165014.11b66f37@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.02.2016 um 20:50 schrieb Mauro Carvalho Chehab:
> Em Sat, 27 Feb 2016 19:39:16 +0100
> Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> 
>> Am 27.02.2016 um 19:05 schrieb Mauro Carvalho Chehab:
>>> Em Sat, 27 Feb 2016 17:10:41 +0100
>>> Heiner Kallweit <hkallweit1@gmail.com> escreveu:
>>>   
>>>> Am 27.02.2016 um 13:14 schrieb Heiner Kallweit:  
>>>>> Since this commit I see the following error when the Nuvoton RC driver is loaded:
>>>>>
>>>>> input: failed to attach handler kbd to device input3, error: -22
>>>>>
>>>>> Error 22 (EINVAL) comes from the new check in rc_open().
>>>>>     
>>>>
>>>> Complete call chain seems to be:
>>>>   rc_register_device
>>>>   input_register_device
>>>>   input_attach_handler
>>>>   kbd_connect
>>>>   input_open_device
>>>>   ir_open
>>>>   rc_open
>>>>
>>>> rc_register_device calls input_register_device before dev->initialized = true,
>>>> therefore the new check in rc_open fails. At a first glance I'd say that we have
>>>> to remove this check from rc_open.  
>>>
>>> Hmm... maybe we could, instead, do:
>>>
>>> 	if (!rdev->initialized) {
>>> 		rval = -ERESTARTSYS;
>>> 		goto unlock;
>>> 	}
>>>   
>> Looking at the source code of the functions in the call chain I see no special
>> handling of ERESTARTSYS. It's treated like any other error, therefore I don't
>> think this helps.
> 
> The expected behavior is that the Kernel syscall code to handle ERESTARTSYS
> internally, and either return EAGAIN to userspace, or try again until
> it succeeds, depending on the open mode.
> 
I tested it and returning ERESTARTSYS instead of EINVAL doesn't help.
The behavior is the same.
As far as I can see no syscall code is involved in this call chain.

> So, it seems a worth trial.
> 
> Thanks,
> Mauro
> 

