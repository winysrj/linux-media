Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36752 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZDNBIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 21:08:43 -0400
Received: by fxm2 with SMTP id 2so2211965fxm.37
        for <linux-media@vger.kernel.org>; Mon, 13 Apr 2009 18:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904131317.01731.hverkuil@xs4all.nl>
References: <200903262049.10425.vasily@scopicsoftware.com>
	 <200904131317.01731.hverkuil@xs4all.nl>
Date: Tue, 14 Apr 2009 04:08:41 +0300
Message-ID: <36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
Subject: Re: [REVIEW] v4l2 loopback
From: vasaka@gmail.com
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 13, 2009 at 2:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday 26 March 2009 19:49:10 Vasily wrote:
>> Hello, please review the new version of v4l2 loopback driver.
>> I fixed up comments to the previous submission, waiting for the new ones
>> :-), reposting for patchwork tool
>>
>> ---
>> This patch introduces v4l2 loopback module
>>
>> From: Vasily Levin <vasaka@gmail.com>
>>
>> This is v4l2 loopback driver which can be used to make available any
>> userspace video as v4l2 device. Initialy it was written to make
>> videoeffects available to Skype, but in fact it have many more uses.
>
> Hi Vasily,
>
> It's still on my todo list, but I have had very little time. If you still
> haven't seen a review in two weeks time, then please send me a reminder.
>
> Sorry about this, normally I review things like this much sooner but it has
> been very hectic lately.
>
> Regards,
>
>        Hans

Hi Hans,

Thanks for updating, driver is still waiting for review, I am glad to
here that it is on a todo list :-)

Vasily
