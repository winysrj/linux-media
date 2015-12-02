Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34902 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbbLBRWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 12:22:11 -0500
Received: by ioc74 with SMTP id 74so52776034ioc.2
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2015 09:22:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
References: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
Date: Wed, 2 Dec 2015 14:22:10 -0300
Message-ID: <CALF0-+UtHzo6-vYvUWtvS0hU7jyuPU+Ku4JC85T4gn4AHLgS0w@mail.gmail.com>
Subject: Re: Sabrent (stk1160) / Easycap driver problem
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Philippe Desrochers <desrochers.philippe@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

Ccing the linux-media ML. Please don't reply dropping the Cc!

2015-12-02 11:58 GMT-03:00 Philippe Desrochers <desrochers.philippe@gmail.com>:
> Hello Ezequiel,
>
> I'm using your stk1160 driver with some EasyCap (china) clone and it is
> working fine.
>
> However, a few days ago, I bought two Sabrent USB-AVCPT and both of them are
> not working with my Ubuntu 14.04 computer.
> http://www.sabrent.com/category/video-converters/USB-AVCPT/
>
> All of these devices have the Syntek 1160 chipset.
>
> Normally, I am using VLC to use these devices but with the Sabrent grabber I
> can't see the video/display window. (it just does not show)
>
> I also tried mplayer and it is giving me a "select timeout".
>
> See attached file for the "lsusb -vv" output.
>
> Can you give me some hint where to look for to fix this issue ?
> If needed, I can compile code or driver and do some tests.
>
> For now, I am a bit lost because I don't know where to start looking...
>

Can you paste the kernel log (dmesg output) in each case?


-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
