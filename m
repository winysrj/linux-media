Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:43558 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLFU0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Dec 2014 15:26:42 -0500
Message-ID: <54836680.9010404@southpole.se>
Date: Sat, 06 Dec 2014 21:26:40 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mn88472: make sure the private data struct is nulled
 after free
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <1417825533-13081-2-git-send-email-benjamin@southpole.se> <54832EE7.10705@iki.fi> <54834628.50702@southpole.se> <54834CD7.1060709@iki.fi>
In-Reply-To: <54834CD7.1060709@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 07:37 PM, Antti Palosaari wrote:
>>
>> I do think it is good practice to set pointers to null generally as that
>> would have saved me several days of work of whentracking down this bug.
>> The current dvb framework contain several other cases where pointers are
>> feed'd but not nulled.
>
> There is kzfree() for that, but still I am very unsure should we start 
> zeroing memory upon release driver has allocated, or just relase it 
> using kfree.
>
> regards
> Antti 

Well I guess I am biased as I have spent lots of time finding a bug that 
probably wouldn't exist if the policy was that drivers always should set 
their memory to zero before it is free'd. Maybe we should have a compile 
time override so that all free calls zeroes the memory before the actual 
free? Maybe there already is this kind of feature?

MvH
Benjamin Larsson
