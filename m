Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57885 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LQTJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 14:09:56 -0500
Received: by yenm11 with SMTP id m11so2820551yen.19
        for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 11:09:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EECB2C2.8050701@gmail.com>
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com>
	<4EE9AA21.1060101@gmail.com>
	<CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com>
	<4EEAFF47.5040003@gmail.com>
	<CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com>
	<4EECB2C2.8050701@gmail.com>
Date: Sat, 17 Dec 2011 21:09:56 +0200
Message-ID: <CALJK-QjZs2P6AofSshH+e=QtsnDWFqKPAixnXQEdTjsOQZ2FXA@mail.gmail.com>
Subject: Re: Hauppauge HVR-930C problems
From: Mihai Dobrescu <msdobrescu@gmail.com>
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 17, 2011 at 5:18 PM, Fredrik Lingvall
<fredrik.lingvall@gmail.com> wrote:
> On 12/16/11 19:35, Mihai Dobrescu wrote:
>
> Please excuse the dumbness of the question, but, could you direct me
> to the repository having these patches applied?
>
>
> No it's not a dumpness question - I have struggeled with this too.
>
> First I got confused which kernel source to use. There are two git repos
> mentioned on the linuxtv.org site:
>
> 1) on http://linuxtv.org/repo/
>
> ~ # git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
>
> and 2) on http://git.linuxtv.org/media_tree.git
>
> ~ # git clone git://github.com/torvalds/linux.git v4l-dvb
>
>
> I'm also a bit confused on how to get the linux-media tree. My guess was to
> do a
>
>  # cd v4l-dvb
>  # git remote add linuxtv git://linuxtv.org/media_tree.git
>  # git remote update
>
>
> They also now and then create tar-files, and right know I'm testing the one
> from 2011-12-13, That is,
>
> ~ # cd /usr/src
> src # git clone git://github.com/torvalds/linux.git v4l-dvb
> src # wget
> http://linuxtv.org/downloads/drivers/linux-media-2011-12-13.tar.bz2
> src # cd v4l-dvb
> v4l-dvb # tar xvjf ../linux-media-2011-12-13.tar.bz2
>
> Then configure and build the kernel:make menuconfig (enable the drivers
> etc), make -j2 && make modules_install & make install
> and add the new kernel to lilo/grub etc and reboot.
>
> The media tree don't build cleanly on the stock Gentoo kernel (3.0.6) so
> that's why I'm using Linux' dev kernel (which is the one recommended on
> Linuxtv). However, not everything works with this kernel (I can't emerge
> virtualbox for example).
>
> /Fredrik
>

Thank you.
So, there would be no success on Sabayon 7 64 bit having kernel version 3.1?
I would not rebuild all the kernel, just the media.
Does this suffice?

Mike
