Return-path: <linux-media-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:59949 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2IRUKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 16:10:15 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-media@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Tue, 18 Sep 2012 14:10:14 -0600
Message-ID: <5058D4DE.6060007@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 13:09:02 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Shubhrajyoti D <shubhrajyoti@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com> <1347961843-9376-7-git-send-email-shubhrajyoti@ti.com> <D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com> <CAM=Q2cv8R8QUbV2UqNO+AbwgprAYxBtBjK=4rkHnqegGJWTdog@mail.gmail.com> <D958900912E20642BCBC71664EFECE3E6DDEFB9480@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB9480@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 18 Sep 2012 03:02:42 AM PDT, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>> Sent: Tuesday, September 18, 2012 3:30 PM
>> To: Venu Byravarasu
>> Cc: Shubhrajyoti D; linux-media@vger.kernel.org; linux-
>> kernel@vger.kernel.org; julia.lawall@lip6.fr
>> Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99
>> format
>
>>>>        struct i2c_msg test[2] = {
>>>> -             { client->addr, 0,        3, write },
>>>> -             { client->addr, I2C_M_RD, 2, read  },
>>>> +             {
>>>> +                     .addr = client->addr,
>>>> +                     .flags = 0,
>>>
>>> Does flags not contain 0 by default?
>>>
>>
>> It does however I felt that 0 means write so letting it be explicit.
>>
>> In case a removal is preferred that's doable too however felt it is
>> more readable this way.
>
> Though it adds readability, it carries an overhead of one write operation too.
> So, better to remove it.

Partially initialized structs will have their unmentioned members 
initialized to zero.

So there is no "overhead of one write operation" by mentioning it 
explicitly.

