Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:10532 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEZQrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 12:47:13 -0400
Received: by yx-out-2324.google.com with SMTP id 3so2280731yxj.1
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 09:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1BE8BC.3010901@gmail.com>
References: <4A1BE8BC.3010901@gmail.com>
Date: Tue, 26 May 2009 20:47:14 +0400
Message-ID: <208cbae30905260947o6462dedsf010bc6b6acfa0bc@mail.gmail.com>
Subject: Re: v4l-dvb and old kernels
From: Alexey Klimov <klimov.linux@gmail.com>
To: Antonio Beamud Montero <antonio.beamud@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Antonio

On Tue, May 26, 2009 at 5:03 PM, Antonio Beamud Montero
<antonio.beamud@gmail.com> wrote:
> It would compile today's snapshot of v4l-dvb with an old kernel version (for
> example 2.6.16)? (or is better to upgrade the kernel?)

Not long time ago v4l-dvb community had discussions about dropping
support for kernels older than 2.6.22. And community decided to
support kernels 2.6.22 - 2.6.30+. One of the reason that it's big work
to support code to make it compiles and works in old kernels. Well,
developers want to spend more time working on new code.

So, the best way to you is to upgrade your kernel.

Second way to correct mistakes. Probably developers can help you here.

One more way, probably you can take old snapshot of v4l-dvb repository
that compiles and work on 2.6.16 if you need. Someone can point to
link to it (i don' know).

> Trying to compile today's mercurial snapshot in a SuSE 10.1 (2.6.16-21),
> give the next errors:
>
> /root/v4l-dvb/v4l/bttv-i2c.c: In function 'init_bttv_i2c':
> /root/v4l-dvb/v4l/bttv-i2c.c:411: error: storage size of 'info' isn't known
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' to
> incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:427: error: implicit declaration of function
> 'i2c_new_probed_device'
> /root/v4l-dvb/v4l/bttv-i2c.c:411: warning: unused variable 'info'
> make[5]: *** [/root/v4l-dvb/v4l/bttv-i2c.o] Error 1

Well, this mistakes appear in v4l-dvb daily build too.

-- 
Best regards, Klimov Alexey
