Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45643 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbbHVMrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 08:47:37 -0400
Message-ID: <55D86F3C.6090004@xs4all.nl>
Date: Sat, 22 Aug 2015 14:46:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] saa7164: convert to the control framework
References: <55D730F4.80100@xs4all.nl>	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>	<55D85325.80607@xs4all.nl> <CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
In-Reply-To: <CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2015 02:06 PM, Steven Toth wrote:
> On Sat, Aug 22, 2015 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 08/22/2015 09:24 AM, Ricardo Ribalda Delgado wrote:
>>> Hello Hans
>>>
>>> With this patch I guess two of my previous patches are not needed.
>>> Shall i resend the patchset or you just cherry pick the appropriate
>>> ones?
>>
>> Let's see how long it takes before I get an Ack (or not) from Steve. If that's
>> quick, then you can incorporate my patch in your patch series, if it takes
>> longer (I know he's busy), then we can proceed with your patch series and I'll
>> rebase on top of that later.
> 
> Hans, thanks for the work here.
> 
> I've skimmed the patch buts its too much to eyeball to give a direct ack.
> 
> Has anyone tested the patch and validated each of the controls continue to work?

As I said: my saa7146 card is no longer recognized (not sure why), so I was hoping
you could test it.

Regards,

	Hans

