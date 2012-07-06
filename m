Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53286 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GFPPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 11:15:14 -0400
Received: by gglu4 with SMTP id u4so8688980ggl.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 08:15:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0i53VJVCVsJy2YGX_pWab0QVSkew5tJL5MQ7CcLyGvjMg@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
	<CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
	<CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
	<CALF0-+XR_ZE8_52zQKZ9n9x8sGrmJWNpeXnKD_j6Lg1YHta=vQ@mail.gmail.com>
	<CACK0K0i53VJVCVsJy2YGX_pWab0QVSkew5tJL5MQ7CcLyGvjMg@mail.gmail.com>
Date: Fri, 6 Jul 2012 12:15:13 -0300
Message-ID: <CALF0-+U_QHB=uc40osz_XvjdWWLCK6aWam=o-cEdg0Wju4S6Hw@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca,

On Mon, Jun 25, 2012 at 4:09 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:

> In my environment this command line gives only one format supported (UYVY)
> and then yavta freezes.
> I suspect it freezes on an ioctl to the driver. I must check it.
>

This freezing is actually a dead lock, and I think it's not related to
ARM but to a (now fixed) bug.

The bug was related to differences in locking scheme between v3.2 and
v3.4 kernel,
i.e. to make stk1160 work on v3.2 some fixes are needed, beside your
"module_usb_driver"
patch.

If you (or anyone) wants to use stk1160 on current kernels (3.2 and such) you
can checkout this github tree I've prepared to help user adoption of stk1160.

This is current (beta tested) branch:
https://github.com/ezequielgarcia/stk1160-standalone

And this is with "keep_buffers" parameter:
https://github.com/ezequielgarcia/stk1160-standalone/tree/0.9.4_v3.2

I don't know if you're still interested in using stk1160, but I wanted you to be
aware of this issue. As far as I know, there shouldn't be any issues
with ARM; if you can confirm this we'd appreciate it.

Regards,
Ezequiel.
