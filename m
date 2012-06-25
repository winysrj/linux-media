Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33092 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2FYOrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 10:47:22 -0400
Received: by obbuo13 with SMTP id uo13so6545326obb.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 07:47:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+X2g7FBv4_LTo6HnX=RO3v_RCgHaGMh+zf3GW_toYWs4Q@mail.gmail.com>
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
	<CALF0-+X2g7FBv4_LTo6HnX=RO3v_RCgHaGMh+zf3GW_toYWs4Q@mail.gmail.com>
Date: Mon, 25 Jun 2012 10:47:21 -0400
Message-ID: <CAGoCfix63V1p=yvNVEwDF7DHZZ_Yt=h91mcasDVnSGM=f3w0Mw@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Gianluca Bergamo <gianluca.bergamo@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 10:36 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> I've added Devin in Cc:
> Devin: You said you ran into some issues on em28xx on ARM, what kind
> of issues?

There are a handful of issues, but the big one which everybody runs
into is a typo in a left shift operation that causes capture to be
completely broken on ARM.  I just never got around to sending a patch
upstream for it.

I don't know if this is the original report, but the issue is
summarized well here:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg28407.html

Others issue related to memory allocation on platforms like ARM with
limited coherent memory (if the device is unplugged/replugged often,
the device won't be able to allocate the URB buffers), as well as
performance problems related to the type of memory used (dependent on
which ARM chip is used).

Most of this stuff is relatively straightforward to fix but I've just
been too busy with other projects.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
