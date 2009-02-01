Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56209 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZBATtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 14:49:53 -0500
Date: Sun, 1 Feb 2009 14:49:49 -0500 (EST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
cc: linux-media@vger.kernel.org
Subject: Re: cx88-dvb broken since 2.6.29-rc1
In-Reply-To: <20090201144725.637ba51a@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0902011449160.28216@bombadil.infradead.org>
References: <20090129221012.685c239e@hyperion.delvare> <20090129192431.46adf0c9@caramujo.chehab.org> <20090201142927.57f0d5b4@hyperion.delvare> <20090201114257.19d5df1f@pedra.chehab.org> <20090201144725.637ba51a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 1 Feb 2009, Jean Delvare wrote:

> On Sun, 1 Feb 2009 11:42:57 -0200, Mauro Carvalho Chehab wrote:
>> On Sun, 1 Feb 2009 14:29:27 +0100
>> Jean Delvare <khali@linux-fr.org> wrote:
>>
>>> On Thu, 29 Jan 2009 19:24:31 -0200, Mauro Carvalho Chehab wrote:
>>>> I have already a pull request almost ready that will fix this issue. I'll
>>>> likely send it today or tomorrow.
>>>
>>> Did it happen? I've just tested kernel 2.6.29-rc3-git3 and the problem
>>> is still present.
>>
>> I just sent today a pull request with this fix included:
>
> Great, thanks.
>
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>> To: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-media@vger.linuxtv.org
>
> The last address looks like a typo.

Yes. It were a typo on my patchbomb script. Fixed, thanks!
>
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
