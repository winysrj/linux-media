Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63810 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2F2UMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 16:12:07 -0400
Received: by lbbgm6 with SMTP id gm6so5105527lbb.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 13:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfix63V1p=yvNVEwDF7DHZZ_Yt=h91mcasDVnSGM=f3w0Mw@mail.gmail.com>
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
	<CAGoCfix63V1p=yvNVEwDF7DHZZ_Yt=h91mcasDVnSGM=f3w0Mw@mail.gmail.com>
Date: Fri, 29 Jun 2012 17:12:04 -0300
Message-ID: <CALF0-+XvrOqoQNcJvwChkrcV2hK3sCg4ibYrCLsLzmLxgSkbzA@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Gianluca,

On Mon, Jun 25, 2012 at 11:47 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Jun 25, 2012 at 10:36 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Others issue related to memory allocation on platforms like ARM with
> limited coherent memory (if the device is unplugged/replugged often,
> the device won't be able to allocate the URB buffers), as well as

As Devin says there maybe some issues with memory allocation I've added a
module parameter for stk1160 named "keep_buffers" that could be used to reduce
memory fragmentation.

You may want to test the latest patch:
http://patchwork.linuxtv.org/patch/13148/

If you have any problems/questions feel free to ask.

Thanks,
Ezequiel.
