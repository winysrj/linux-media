Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56242 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2FYOgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 10:36:21 -0400
Received: by obbuo13 with SMTP id uo13so6533463obb.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 07:36:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0iPht7n4oxyR68zzz=Emau7kFNs0b3ooBwMn83_GVZnDw@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
	<CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
	<CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
	<CALF0-+XR_ZE8_52zQKZ9n9x8sGrmJWNpeXnKD_j6Lg1YHta=vQ@mail.gmail.com>
	<CACK0K0i53VJVCVsJy2YGX_pWab0QVSkew5tJL5MQ7CcLyGvjMg@mail.gmail.com>
	<CALF0-+Ws+EWs5CjJedJMFL4mLkKx--kg5VZpa=f_+x2iiUiK5Q@mail.gmail.com>
	<CACK0K0gTUWgpgErfMfXtQLN2gCW81RPp5yfGghtpigA0ALrm7w@mail.gmail.com>
	<CALF0-+WE=WakSL5Thx4QKFDKg7GyK4mDk+r_cOm2=Bn=Fan4rg@mail.gmail.com>
	<CACK0K0iPht7n4oxyR68zzz=Emau7kFNs0b3ooBwMn83_GVZnDw@mail.gmail.com>
Date: Mon, 25 Jun 2012 11:36:20 -0300
Message-ID: <CALF0-+X2g7FBv4_LTo6HnX=RO3v_RCgHaGMh+zf3GW_toYWs4Q@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 11:26 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
> Thank you.
> I'm going to test it as soon as I can.
>
> PS : Are you testing on ARM architecture? I'm starting to think my problems
> could be related to it...as most of the video capture drivers are working
> well on x86...is it possible for you to do a little test on ARM?
>

No :-(
However, if you have a small ARM device you'd like to donate I'll give
it good use :-)

Anyway, this thread suggests there are some issues with analog capture on ARM
devices (using em28xx driver, but it's similar to stk1160):

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/48009

I've added Devin in Cc:
Devin: You said you ran into some issues on em28xx on ARM, what kind
of issues?

Thanks,
Ezequiel.
