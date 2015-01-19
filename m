Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:37793 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbASSi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 13:38:28 -0500
Message-ID: <54BD4F1A.6030100@southpole.se>
Date: Mon, 19 Jan 2015 19:38:18 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mn88472: make sure the private data struct is nulled
 after free
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <1417825533-13081-2-git-send-email-benjamin@southpole.se> <54832EE7.10705@iki.fi> <54834628.50702@southpole.se> <54834CD7.1060709@iki.fi> <54836680.9010404@southpole.se> <54BD036D.8020701@xs4all.nl>
In-Reply-To: <54BD036D.8020701@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2015 02:15 PM, Hans Verkuil wrote:
> On 12/06/2014 09:26 PM, Benjamin Larsson wrote:
>>
>> Well I guess I am biased as I have spent lots of time finding a bug that
>> probably wouldn't exist if the policy was that drivers always should set
>> their memory to zero before it is free'd.
>
> Just because you zero memory before it is freed doesn't mean it stays zeroed.
> As soon as it is freed some other process might take that memory and fill it
> up again. So zeroing is pointless and in fact will only *hide* bugs.
>

Well in this specific case NOT zeroing the memory it actually hid a use 
after free bug. So stating that it is pointless and that it will only 
hide bugs is not correct at least for this case.

MvH
Benjamin Larsson
