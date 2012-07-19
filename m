Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53912 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GSNcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 09:32:22 -0400
Received: by yhmm54 with SMTP id m54so2737405yhm.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 06:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207191317.56907.hverkuil@xs4all.nl>
References: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com>
	<201207191317.56907.hverkuil@xs4all.nl>
Date: Thu, 19 Jul 2012 10:32:21 -0300
Message-ID: <CALF0-+Vsp=OkgyMEZ0Uyca03GZzH5hU4UtZ_-kfDkrKGQx=8CA@mail.gmail.com>
Subject: Re: [PATCH] cx25821: Remove bad strcpy to read-only char*
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2012 at 8:17 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Ezequiel,
>
> Can you post this patch again, but this time to Linus Torvalds as well?
>
> See e.g. http://www.spinics.net/lists/linux-media/msg50407.html how I did that.
>
> It would be good to have this fixed in 3.5. I'm afraid that by the time
> Mauro is back 3.5 will be released and this is a nasty bug.
>

Okey, I'll do that. Shouldn't this go to stable also?

Thanks for your help,
Ezequiel.
