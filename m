Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34469 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2GZOlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:41:53 -0400
Received: by gglu4 with SMTP id u4so2013301ggl.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 07:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207261639.20482.hverkuil@xs4all.nl>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
	<d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
	<CALF0-+VbHH2APAMmsLw33xfrg1HVz-xVeAPJ8STtruBKpY5=tA@mail.gmail.com>
	<201207261639.20482.hverkuil@xs4all.nl>
Date: Thu, 26 Jul 2012 11:41:52 -0300
Message-ID: <CALF0-+XkmxssQOMSrSDMFjYjuCzpt3TQO83r691Ofyg7OKp30w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library
 Signed-off-by: Konke Radlow <kradlow@cisco.com>
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org,
	hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2012 at 11:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu 26 July 2012 16:28:20 Ezequiel Garcia wrote:
>> Hi Konke,
>>
>> > +
>> > +libv4l2rds_la_SOURCES = libv4l2rds.c
>> > +libv4l2rds_la_CPPFLAGS = -fvisibility=hidden $(ENFORCE_LIBV4L_STATIC) -std=c99
>> > +libv4l2rds_la_LDFLAGS = -version-info 0 -lpthread $(DLOPEN_LIBS) $(ENFORCE_LIBV4L_STATIC)
>> > diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
>> > new file mode 100644
>> > index 0000000..0bacaa2
>> > --- /dev/null
>> > +++ b/lib/libv4l2rds/libv4l2rds.c
>> > @@ -0,0 +1,871 @@
>> > +/*
>> > + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>> [snip]
>> > + * This program is free software; you can redistribute it and/or modify
>>
>> Just a -probably silly- question...
>>
>> How can it be "free software" yet claim "All rights reserved" ? Is this correct?
>
> Yeah, it's correct. I had the same question when I was told that this was the
> correct phrase to use. Check other copyright lines in the kernel and you'll see
> the same line.
>
> Since it is covered by the LGPLv2 license there aren't many rights to reserve :-)
>
> The only right there is in practice is the right to decide whether or not to
> allow other licenses as well.
>

For some reason, I must read this several times before really catching it.

Thanks for the explanation,
Ezequiel.
