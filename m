Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2FWNbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 09:31:05 -0400
Received: by obbuo13 with SMTP id uo13so3493861obb.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 06:31:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
Date: Sat, 23 Jun 2012 10:31:03 -0300
Message-ID: <CALF0-+WdG7E41r-cOMD=6nABYUGOvxv-WJ1QpF_FzCS3ptsonQ@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

On Fri, Jun 22, 2012 at 9:00 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
>
> I've patched my kernel 3.0.8 and it compiles without problems.
> I've compiled it NOT as a module but directly built in in the kernel.
>

I just patched a vanilla 3.0.8 (taken from stable repository) with
stk1160 driver
patch and I believe this kernel is too old.

Are you using stock kernel 3.0.8? Are you sure it compiled without any
warnings and/or errors?
I got some missing symbol warnings here when compiling the driver.
This symbols are needed so the driver won't work.

Is it possible for you to try with a 3.3 (or above) kernel?

Thanks,
Ezequiel.
