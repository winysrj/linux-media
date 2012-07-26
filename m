Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51314 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GZO2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:28:21 -0400
Received: by yhmm54 with SMTP id m54so2006331yhm.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 07:28:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
	<d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
Date: Thu, 26 Jul 2012 11:28:20 -0300
Message-ID: <CALF0-+VbHH2APAMmsLw33xfrg1HVz-xVeAPJ8STtruBKpY5=tA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library
 Signed-off-by: Konke Radlow <kradlow@cisco.com>
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Konke Radlow <kradlow@cisco.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konke,

> +
> +libv4l2rds_la_SOURCES = libv4l2rds.c
> +libv4l2rds_la_CPPFLAGS = -fvisibility=hidden $(ENFORCE_LIBV4L_STATIC) -std=c99
> +libv4l2rds_la_LDFLAGS = -version-info 0 -lpthread $(DLOPEN_LIBS) $(ENFORCE_LIBV4L_STATIC)
> diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
> new file mode 100644
> index 0000000..0bacaa2
> --- /dev/null
> +++ b/lib/libv4l2rds/libv4l2rds.c
> @@ -0,0 +1,871 @@
> +/*
> + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
[snip]
> + * This program is free software; you can redistribute it and/or modify

Just a -probably silly- question...

How can it be "free software" yet claim "All rights reserved" ? Is this correct?

Regards,
Ezequiel.
