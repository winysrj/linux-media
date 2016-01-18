Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:33619 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbcARN5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 08:57:16 -0500
Received: by mail-vk0-f54.google.com with SMTP id i129so193505947vkb.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 05:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569CE927.9040000@xs4all.nl>
References: <569CE927.9040000@xs4all.nl>
Date: Mon, 18 Jan 2016 14:57:15 +0100
Message-ID: <CALtnZsD+qDBJbAz8mq+W8prcbwC0nRbxGMZs07kXC5_7Azk1Lw@mail.gmail.com>
Subject: Re: [RFC] Removal of the Timberdale v4l2 drivers timblogiw & radio-timb
From: =?UTF-8?Q?Richard_R=C3=B6jfors?= <richard@puffinpack.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-01-18 14:31 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
>
> I am inclined to remove the Timberdale support from drivers/media. First
> by moving it to staging for one or two kernel releases, and then removing
> it altogether.
>
> Anyone still using it today would almost certainly be stuck on an old kernel.
>
> Comments?

I agree this hardware has been superseded since long.  If anyone i still using
it, they would be stuck on old kernels as you say.
I see no issues with having it removed for future kernels.

--Richard
