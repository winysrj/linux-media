Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47809 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0KRPKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 10:10:50 -0500
Received: by yxf34 with SMTP id 34so1863800yxf.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 07:10:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e29b49a76577b6eb777d1aa0dba7bd95.squirrel@webmail.xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
	<659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
	<AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
	<e29b49a76577b6eb777d1aa0dba7bd95.squirrel@webmail.xs4all.nl>
Date: Thu, 18 Nov 2010 10:10:49 -0500
Message-ID: <AANLkTimuV4ZZEcbrf4a2toHLcKMDAEQF9ZLWkju6zwZ0@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 07/15] dsbr100: convert to unlocked_ioctl.
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 18, 2010 at 9:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> This driver has quite a few locking issues that would only be made
>> worse by your patch. A much better patch for this can be found here:
>>
>> http://desource.dyndns.org/~atog/gitweb?p=linux-media.git;a=commitdiff;h=9c5d8ebb602e9af46902c5f3d4d4cc80227d3f7c
>
> Much too big for 2.6.37. I'll just drop this patch from my patch series.
> Instead it will rely on the new lock in v4l2_device (BKL replacement) that
> serializes all ioctls. For 2.6.38 we can convert it to core assisted
> locking which is much easier.
>

I don't see how this patch is really any bigger than some of the
others in your series. Sure there are a lot of deletions, but the
number of additions is quite small. There are much worse ways all the
locking issues in this driver could have been corrected. This patch
manages to do just that while reducing the overall size of the driver
at the same time.

Regards,

David Ellingsworth
