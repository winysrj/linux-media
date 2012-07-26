Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:31144 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2GZOjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:39:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library Signed-off-by: Konke Radlow <kradlow@cisco.com>
Date: Thu, 26 Jul 2012 16:39:20 +0200
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org,
	hdegoede@redhat.com
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com> <CALF0-+VbHH2APAMmsLw33xfrg1HVz-xVeAPJ8STtruBKpY5=tA@mail.gmail.com>
In-Reply-To: <CALF0-+VbHH2APAMmsLw33xfrg1HVz-xVeAPJ8STtruBKpY5=tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261639.20482.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 26 July 2012 16:28:20 Ezequiel Garcia wrote:
> Hi Konke,
> 
> > +
> > +libv4l2rds_la_SOURCES = libv4l2rds.c
> > +libv4l2rds_la_CPPFLAGS = -fvisibility=hidden $(ENFORCE_LIBV4L_STATIC) -std=c99
> > +libv4l2rds_la_LDFLAGS = -version-info 0 -lpthread $(DLOPEN_LIBS) $(ENFORCE_LIBV4L_STATIC)
> > diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
> > new file mode 100644
> > index 0000000..0bacaa2
> > --- /dev/null
> > +++ b/lib/libv4l2rds/libv4l2rds.c
> > @@ -0,0 +1,871 @@
> > +/*
> > + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> [snip]
> > + * This program is free software; you can redistribute it and/or modify
> 
> Just a -probably silly- question...
> 
> How can it be "free software" yet claim "All rights reserved" ? Is this correct?

Yeah, it's correct. I had the same question when I was told that this was the
correct phrase to use. Check other copyright lines in the kernel and you'll see
the same line.

Since it is covered by the LGPLv2 license there aren't many rights to reserve :-)

The only right there is in practice is the right to decide whether or not to
allow other licenses as well.

Regards,

	Hans
