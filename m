Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53144 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2FCVEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2012 17:04:50 -0400
Received: by obbtb18 with SMTP id tb18so6188649obb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Jun 2012 14:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206031233.24758.hverkuil@xs4all.nl>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W5DCf1HMs=MYMc2KVgz=SJKS2YLY7LSrxU6-gnc=+LAA@mail.gmail.com>
	<201206031233.24758.hverkuil@xs4all.nl>
Date: Sun, 3 Jun 2012 18:04:49 -0300
Message-ID: <CALF0-+UBtvUBy8iHTHqd2J9Txy9VeCfU1CqdJ=5aVktimjAC_A@mail.gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Jun 3, 2012 at 7:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
[snip]
> Thanks. I've fixed several things reported by v4l2-compliance (see my patch
> below), but you are using an older v4l2-compliance version. You should clone
> and compile the v4l-utils.git repository yourself, rather than using a distro
> provided version (which I think is what you are doing now).
>
> Can you apply my patch on yours and run the latest v4l2-compliance again?

Okey I'll do that, and send you the results.

>
> Below is my (untested) patch that should fix a number of things.
>
> BTW, I hate the use of current_norm, and in fact I plan to get rid of current_norm
> in the near future. So that's why I replaced it with g_std.

Okey. I wasn't aware of that. I just saw it somewhere and I assumed it
was *the right thing*.

Thanks for your help :)

See ya,
Ezequiel.
