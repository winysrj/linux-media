Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47359 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDQUun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:43 -0400
Message-id: <53503E9F.9050800@samsung.com>
Date: Thu, 17 Apr 2014 14:50:39 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
	rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	shuahkhan@gmail.com
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
 <20140416215821.GG26632@htj.dyndns.org> <5350331C.7010602@samsung.com>
 <20140417201034.GT15326@htj.dyndns.org>
In-reply-to: <20140417201034.GT15326@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 02:10 PM, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 02:01:32PM -0600, Shuah Khan wrote:
>> Operating on the lock should be atomic, which is what devres_update()
>> is doing. It can be simplified as follows by holding devres_lock
>> in devm_token_lock().
>>
>> spin_lock_irqsave(&dev->devres_lock, flags);
>> if (tkn_ptr->status == TOKEN_DEVRES_FREE)
>> 	tkn_ptr->status = TOKEN_DEVRES_BUSY;
>> spin_unlock_irqrestore(&dev->devres_lock, flags);
>>
>> Is this in-line with what you have in mind?
>
> How is that different from tkn_ptr->status = TOKEN_DEVRES_BUSY?
>

I see what you are saying. The code path doesn't ensure two threads
not getting the lock. I have a bug in here that my rc settings aren't
protected. You probably noticed that the RFC tag on the patch and this
isn't fully cooked yet.

I started working on driver changes that use this token and I might have
to add owner for the token as well. I hope to work these details out and
send a real patch.

thanks,
-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
