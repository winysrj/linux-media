Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:57182 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbANGQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 01:16:06 -0500
Received: from mailo-proxy1.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t0E6G3pL013093-t0E6G3pM013093
	for <linux-media@vger.kernel.org>; Wed, 14 Jan 2015 08:16:03 +0200
Message-ID: <54B609A2.2040503@apollo.lv>
Date: Wed, 14 Jan 2015 08:16:02 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl> <54B55C23.1070409@apollo.lv>
In-Reply-To: <54B55C23.1070409@apollo.lv>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2015 19:55, Raimonds Cicans wrote:
> On 13.01.2015 16:01, Hans Verkuil wrote:
>> Hi Raimonds, Jurgen,
>>
>> Can you both test this patch? It should (I hope) solve the problems you
>> both had with the cx23885 driver.
>>
>> This patch fixes a race condition in the vb2_thread that occurs when
>> the thread is stopped. The crucial fix is calling kthread_stop much
>> earlier in vb2_thread_stop(). But I also made the vb2_thread more
>> robust.
>
> With this patch I am unable to get any error except first
> (AMD-Vi: Event logged [IO_PAGE_FAULT...).
> But I am not convinced, because before patch I get
> first error much often and earlier than almost any other error,
> so it may be just "bad luck" and other errors do not
> appear because first error appear earlier.
>
I noticed that if I "initialize" card with commands:
/usr/bin/dvb-fe-tool -a 4 -d DVBS
/usr/bin/dvb-fe-tool -a 5 -d DVBS

and then run load which starts on first front-end and
only after some time on second, then I receive first
error much later or do not receive at all (for example
I was able to run VDR whole night without problems)


Raimonds Cicans

