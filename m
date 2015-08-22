Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37182 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbHVMGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 08:06:55 -0400
Received: by igui7 with SMTP id i7so30076588igu.0
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2015 05:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D85325.80607@xs4all.nl>
References: <55D730F4.80100@xs4all.nl>
	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>
	<55D85325.80607@xs4all.nl>
Date: Sat, 22 Aug 2015 08:06:54 -0400
Message-ID: <CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
Subject: Re: [PATCH] saa7164: convert to the control framework
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 22, 2015 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/22/2015 09:24 AM, Ricardo Ribalda Delgado wrote:
>> Hello Hans
>>
>> With this patch I guess two of my previous patches are not needed.
>> Shall i resend the patchset or you just cherry pick the appropriate
>> ones?
>
> Let's see how long it takes before I get an Ack (or not) from Steve. If that's
> quick, then you can incorporate my patch in your patch series, if it takes
> longer (I know he's busy), then we can proceed with your patch series and I'll
> rebase on top of that later.

Hans, thanks for the work here.

I've skimmed the patch buts its too much to eyeball to give a direct ack.

Has anyone tested the patch and validated each of the controls continue to work?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
