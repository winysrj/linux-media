Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33897 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2FWOIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 10:08:45 -0400
Received: by obbuo13 with SMTP id uo13so3533296obb.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 07:08:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
	<CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
	<CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
Date: Sat, 23 Jun 2012 11:08:45 -0300
Message-ID: <CALF0-+VvDTebF_GA1NWLhrcmvzD3jQZS8brOyjqfcb5e_3okxw@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 23, 2012 at 10:51 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
>
> I've found the problem. Your module is lacking the init and exit module
> functions.
> You are using :
>
> module_usb_driver(stk1160_usb_driver);

Indeed.

>
> That has been introduced in kernel 3.3 and so in my kernel 3.0.8 it does not
> give compiler error (I don't know why) but the probe method is never called.

That's weird, I got a bunch of warnings. Compilers are sometimes crazy :-)

> I've added the init and exit methods by myself and the probe now works.
>

Great! Keep in mind I wrote this driver on newer kernels so I don't know
what other kinds of trouble you may bump into.

> My problem now is that I got out of memory errors when testing it with
> yavta.
> BTW, I'm using this driver on an Android 4 ARM device.

What kind of "out of memory errors"? dmesg?
How many memory do you have on your device?

Currently stk1160 dallocate memory for usb transfer buffers on every stop
and has to reallocate on every start.

This approach is not very smart, as fragments memory without reason.
You can take a look at a similar problem on em28xx driver and a patch proposed:

http://patchwork.linuxtv.org/patch/9875/

I'm not telling you this is your problem, but could be.
Anyway, feel free to:
* provide more info
* ask me questions
* ask for patches

> Now I don't have the patch I've made in my hand...but on monday I will send
> it to you.
>

Okey. I guess I could start a github repo to host a 3.0.8 tree with
the stk1160 driver
if that helps you.

Regards,
Ezequiel.
