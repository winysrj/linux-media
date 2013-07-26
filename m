Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1996 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab3GZIeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 04:34:18 -0400
Message-ID: <51F2347A.306@xs4all.nl>
Date: Fri, 26 Jul 2013 10:34:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [GIT PULL FOR v3.11]
References: <201306270855.49444.hverkuil@xs4all.nl> <CA+V-a8sYvBWGJGBF6JWwjKHwW_4Ew8wp6yBQnCrpeebAkJ4EmA@mail.gmail.com> <201307251525.01108.hverkuil@xs4all.nl> <CA+V-a8tvBy2P3Pih4og9Ov1T5e6CeDuj6FhoXubnTkAhr7Y4pw@mail.gmail.com>
In-Reply-To: <CA+V-a8tvBy2P3Pih4og9Ov1T5e6CeDuj6FhoXubnTkAhr7Y4pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 07/26/2013 06:33 AM, Prabhakar Lad wrote:
> Hi Hans,
> 
> On Thu, Jul 25, 2013 at 6:55 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Prabhakar,
>>
>> On Thu 11 July 2013 19:25:15 Prabhakar Lad wrote:
>>> Hi Hans,
>>>
>>> On Thu, Jun 27, 2013 at 12:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> (Same as my previous git pull message, but with more cleanup patches and
>>> [snip]
>>>> Lad, Prabhakar (9):
>>>>       media: i2c: ths8200: support asynchronous probing
>>>>       media: i2c: ths8200: add OF support
>>>>       media: i2c: adv7343: add support for asynchronous probing
>>>>       media: i2c: tvp7002: add support for asynchronous probing
>>>>       media: i2c: tvp7002: remove manual setting of subdev name
>>>>       media: i2c: tvp514x: remove manual setting of subdev name
>>>>       media: i2c: tvp514x: add support for asynchronous probing
>>>>       media: davinci: vpif: capture: add V4L2-async support
>>>>       media: davinci: vpif: display: add V4L2-async support
>>>>
>>> I see last two patches missing in Mauro's pull request for v3.11 and v3.11-rc1.
>>
>> I had to split up my pull request into fixes for 3.11 and new stuff for 3.12
>> since the merge window was about to open at the time.
>>
> Ok no problem.
> 
>> Your 'missing' patches are here:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.12
>>
> Yeah I saw it lately.
> 
>> In the next few days I'll try to process all remaining patches delegated to me.
> Ok
> 
>> If you have patches not yet delegated to me, or that are not in my for-v3.12
>> branch, then let me know.
>>
> There are few patches, whose state is new do you want me to point them ?

Only if they are either not in patchwork, or are in patchwork but not delegated to me.

Regards,

	Hans
