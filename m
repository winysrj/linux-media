Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44567 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbbHZNNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 09:13:34 -0400
Message-ID: <55DDBB73.5010902@xs4all.nl>
Date: Wed, 26 Aug 2015 15:13:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] saa7164: convert to the control framework
References: <55D730F4.80100@xs4all.nl>	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>	<55D85325.80607@xs4all.nl>	<CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>	<55D86F3C.6090004@xs4all.nl> <CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>
In-Reply-To: <CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/15 15:08, Steven Toth wrote:
> On Sat, Aug 22, 2015 at 8:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 08/22/2015 02:06 PM, Steven Toth wrote:
>>> On Sat, Aug 22, 2015 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 08/22/2015 09:24 AM, Ricardo Ribalda Delgado wrote:
>>>>> Hello Hans
>>>>>
>>>>> With this patch I guess two of my previous patches are not needed.
>>>>> Shall i resend the patchset or you just cherry pick the appropriate
>>>>> ones?
>>>>
>>>> Let's see how long it takes before I get an Ack (or not) from Steve. If that's
>>>> quick, then you can incorporate my patch in your patch series, if it takes
>>>> longer (I know he's busy), then we can proceed with your patch series and I'll
>>>> rebase on top of that later.
>>>
>>> Hans, thanks for the work here.
>>>
>>> I've skimmed the patch buts its too much to eyeball to give a direct ack.
>>>
>>> Has anyone tested the patch and validated each of the controls continue to work?
>>
>> As I said: my saa7146 card is no longer recognized (not sure why), so I was hoping
>> you could test it.
> 
> OK, will do. I probably won't get to this until the weekend, but I'll
> put this on my todo list.

That's OK, there is no hurry. I tried to put my saa7164 in a different PC as well,
but it seems to be really broken as nothing appears in lspci :-(

Regards,

	Hans
