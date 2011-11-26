Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47289 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1KZQUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 11:20:01 -0500
Received: by bke11 with SMTP id 11so5851124bke.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 08:20:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
Date: Sat, 26 Nov 2011 17:20:00 +0100
Message-ID: <CAO=zWDJREu+AomDtuWTf5CaTwJh4BbQ79b4BtYJODhGvTqW9fg@mail.gmail.com>
Subject: Re: Status of RTL283xU support?
From: Maik Zumstrull <maik@zumstrull.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 26, 2011 at 13:47, Maik Zumstrull <maik@zumstrull.net> wrote:

> it seems I've found myself with an rtl2832u-based DVB-T USB stick. The
> latest news on that seems to be that you were working on cleaning up
> the code of the Realtek-provided GPL driver, with the goal of
> eventually getting it into mainline.
>
> Would you mind giving a short status update?

FYI, someone has contacted me off-list to point out that the newest(?)
Realtek tree for these devices is available online:

Alessandro Ambrosini wrote:

> Dear maik,
>
> I've read your post here
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg39559.html
> I have not a subscription to linux-media mailing list. I see your post
> looking for in archive.
>
> Some days ago I've asked to Realtek if there are newer driver (latest on the
> net was 2.2.0)
> They kindly send me latest driver 2.2.2 kernel 2.6.x
>
> I've patched it yesterday for kernel 3.0.0 (Ubuntu 11.10) and they looks to
> work fine.
> I'm not an expert C coder, only an hobbyist. So I suppose there are
> problems.
>
> Anyway here you can find:
>
> 1) original Realtek 2.2.2 driver "simplified version" (DVB-T only and 4
> tuners only)
> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-4_tuner
>
> 2) original Realtek 2.2.2 driver "full version" (DVB-T/ DTMB and 10 tuners)
> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10_tuner
>
> 3) driver "full" modded by me for kernel 3.0.0
> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> README file explain about all
>
> They compile fine in Ubuntu 11.10 64 bit and works great.
>
> I've NOT tried to compile in 32bit system
> I've compile successfully in a Set-Top-Box Linux based (kernel 3.1.0 ,
> ENIGMA2, cpu Broadcom) and looks to work fine BUT they doesn't work with
> ENIGMA2. I'm investigating about this issue.
>
> If you can re-post this messages in linux-media I will appreciated (omit my
> email address please)
