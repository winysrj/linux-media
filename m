Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49034 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFShO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 13:37:14 -0500
Message-ID: <54834CD7.1060709@iki.fi>
Date: Sat, 06 Dec 2014 20:37:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mn88472: make sure the private data struct is nulled
 after free
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <1417825533-13081-2-git-send-email-benjamin@southpole.se> <54832EE7.10705@iki.fi> <54834628.50702@southpole.se>
In-Reply-To: <54834628.50702@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 08:08 PM, Benjamin Larsson wrote:
> On 12/06/2014 05:29 PM, Antti Palosaari wrote:
>> But that is not needed anymore ?
>>
>> regards
>> Antti
>
> Chances are that more devices with the mn8847x chips appear. Someone
> somewhere might try to use this demod with the old dvb attach model
> during development. Adding this memset will make the unload issue appear
> all the time instead of randomly. But this patch doesn't really matter
> so feel free to NACK it. I just wanted to post it for completeness.
>
> I do think it is good practice to set pointers to null generally as that
> would have saved me several days of work of whentracking down this bug.
> The current dvb framework contain several other cases where pointers are
> feed'd but not nulled.

There is kzfree() for that, but still I am very unsure should we start 
zeroing memory upon release driver has allocated, or just relase it 
using kfree.

regards
Antti

-- 
http://palosaari.fi/
