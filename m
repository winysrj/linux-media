Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61060 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2CUTGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 15:06:23 -0400
Received: by obbeh20 with SMTP id eh20so884232obb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 12:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120321090159.09c0e0c0@tele>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<20120321090159.09c0e0c0@tele>
Date: Wed, 21 Mar 2012 16:06:23 -0300
Message-ID: <CALF0-+WCCjVATOT-nfL7Nw1UzLJf4OposufuhQwWzftfbevfCg@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2012/3/21 Jean-Francois Moine <moinejf@free.fr>:
> In the gspca test tarball (see my site), I merged the spca506 code into
> the spca505 for a webcam which may also do analog video capture. The
> webcam works, but the analog video capture has never been tested.
> Also, the gspca_main <-> subdriver interface for vidioc_s_input and
> vidioc_s_std is not very clean.

I'm not sure about this. The device is based on a new chip stk1160, and
according to Mauro a new driver is needed.

Since the chip supports tuner and other stuff besides video capture,
perhaps adding a new driver might ease future development.

Anyway, with saa7115 driver and the new videobuf2/v4l interface
the driver we'll be very minimal (I hope).

Thanks.
