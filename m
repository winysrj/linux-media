Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33141 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab2B1ALa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 19:11:30 -0500
Received: by obcva7 with SMTP id va7so6139434obc.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 16:11:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABi1daHoWASPq6XmrfW3JYSmzQEZmZMMyfHNmabM4cgZV0j4EA@mail.gmail.com>
References: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
	<CABi1daHoWASPq6XmrfW3JYSmzQEZmZMMyfHNmabM4cgZV0j4EA@mail.gmail.com>
Date: Mon, 27 Feb 2012 21:11:29 -0300
Message-ID: <CALF0-+XREdz+EgzUvj6fpk46r7U4YOV7uxaO9Xtr43-NdBLqgg@mail.gmail.com>
Subject: Re: [question] v4l read() operation
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Dave Hylands <dhylands@gmail.com>
Cc: devel@driverdev.osuosl.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

2012/2/25 Dave Hylands <dhylands@gmail.com>:
>
> I'm not all that familiar with v4l, but based on what you've posted,
> you need to populate the read routine in your v4l2_fops structure to
> support read.
>

My bad! You are totally right: I forgot about my webcam.
When I did:

$ cat /dev/video0

I was actually getting data from my webcam (which supports read),
and not from the easycap device, which is /dev/video1.

So, everything makes sense now:

$ cat /dev/video1

...
open("/dev/video1", O_RDONLY|O_LARGEFILE) = 3
...
read(3, 0x8835000, 32768)               = -1 EINVAL (Invalid argument)

This is clearly shown by the piece of code mentioned before.

Thanks and sorry for the noise,
Ezequiel.
