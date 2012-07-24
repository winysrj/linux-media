Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45285 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2GXQu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 12:50:57 -0400
Received: by gglu4 with SMTP id u4so6877740ggl.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 09:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207191541.56237.hverkuil@xs4all.nl>
References: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com>
	<201207191317.56907.hverkuil@xs4all.nl>
	<CALF0-+Vsp=OkgyMEZ0Uyca03GZzH5hU4UtZ_-kfDkrKGQx=8CA@mail.gmail.com>
	<201207191541.56237.hverkuil@xs4all.nl>
Date: Tue, 24 Jul 2012 13:50:56 -0300
Message-ID: <CALF0-+UNFVTXRZy+GrCRC_GJgXre7Uo9LZU0xzXvWn-RQ=k1WQ@mail.gmail.com>
Subject: Re: [PATCH] cx25821: Remove bad strcpy to read-only char*
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Hans,

On Thu, Jul 19, 2012 at 10:41 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu 19 July 2012 15:32:21 Ezequiel Garcia wrote:
>> On Thu, Jul 19, 2012 at 8:17 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > Ezequiel,
>> >
>> > Can you post this patch again, but this time to Linus Torvalds as well?
>> >
>> > See e.g. http://www.spinics.net/lists/linux-media/msg50407.html how I did that.
>> >
>> > It would be good to have this fixed in 3.5. I'm afraid that by the time
>> > Mauro is back 3.5 will be released and this is a nasty bug.
>> >
>>
>> Okey, I'll do that. Shouldn't this go to stable also?
>
> Definitely, but it have to be upstreamed first before it can go to stable.
>

I was just reading through Documentation/stable_kernel_rules.txt
and I found this:

"Procedure for submitting patches to the -stable tree:

 [snip]
 - To have the patch automatically included in the stable tree, add the tag
     Cc: stable@vger.kernel.org
   in the sign-off area. Once the patch is merged it will be applied to
   the stable tree without anything else needing to be done by the author
   or subsystem maintainer."

So, it was sufficient to Cc this patch to stable and Greg would queued
it automatically when Linus' merges it.

This is also here:
http://www.kroah.com/log/linux/stable-status-01-2012.html

Just wanted you to know this (if you don't already).
Ezequiel.
