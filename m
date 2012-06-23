Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49456 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2FWQCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 12:02:00 -0400
Received: by obbuo13 with SMTP id uo13so3653088obb.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 09:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
	<CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
	<CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
Date: Sat, 23 Jun 2012 13:01:59 -0300
Message-ID: <CALF0-+XR_ZE8_52zQKZ9n9x8sGrmJWNpeXnKD_j6Lg1YHta=vQ@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

On Sat, Jun 23, 2012 at 10:51 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
> You are using :
>
> module_usb_driver(stk1160_usb_driver);
>
> That has been introduced in kernel 3.3 and so in my kernel 3.0.8 it does not
> give compiler error (I don't know why) but the probe method is never called.
> I've added the init and exit methods by myself and the probe now works.
>

I think you might want to take a look to media_build:

http://git.linuxtv.org/media_build.git
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

This allows latest drivers to be built against old kernels.

A "backward-compatible" solution for stk1160 wouldn't be accepted mainline,
but feel free to use (in a personal fashion)
your patched driver and/or ask me to review your patch.

Unfortunately, you'll have to patch yourself each time I release a new
driver version,
so you may wan to try media_build as I previously suggested.

Hope this helps,
Ezequiel.
