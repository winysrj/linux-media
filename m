Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36354 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdAWMWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 07:22:31 -0500
Received: by mail-qt0-f175.google.com with SMTP id k15so121091722qtg.3
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2017 04:22:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN39uTpT1W9m+_OQvP_4pbPiOPKjdTGA6tyJ9VJeGq+AZQXfuw@mail.gmail.com>
References: <CAN39uTpT1W9m+_OQvP_4pbPiOPKjdTGA6tyJ9VJeGq+AZQXfuw@mail.gmail.com>
From: Dreamcat4 <dreamcat4@gmail.com>
Date: Mon, 23 Jan 2017 12:21:35 +0000
Message-ID: <CAN39uTpwe0CjqmC=ajamfN8UrsarwaDZb5YRCMfTNQ2Edyph4g@mail.gmail.com>
Subject: Re: Mysterious regression in dvb driver
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

Installed Antergos (arch) linux today, and its still same issues. That
is with an even newer 4.8 kernel. No HD channels, I2C error in dmesg,
CRC error during w_scan tuning. (when its tuning the HD channels).

So I'm hesitant to report it as a bug under ubuntu bug reporter. Since
its not just limited to debian-based distros.

My main question is whats actually all the files on the disk /
filesystem that are involved? If not in the kernel. Then I could go
back and grab them all from ubuntu 14.04 (works), to try in 14.10
(time of first breakage). Replacing one file at a time.

Wheras... if it is in the kernel then what else was added later on
that broke this? And why is the newer 4.2 updated kernel in the old
14.04 (+.3) still working then? Just doesn't add up / make sense to
me.

I would be very grateful if anyone here could please shed some more
light on the matter.

Kind Regards

On Fri, Jan 20, 2017 at 9:45 PM, Dreamcat4 <dreamcat4@gmail.com> wrote:
> Hi there,
>
> Apologies if no-one wants to hear about this. But there was a patch
> submitted in 3.17 for geniatech t220 / august dvb-t210 v1. And it
> seems to have stopped working for some reason. (yet the patch code is
> still there. I reached out to the birthplace / author of the patch,
> but unfortunately its been a while, moved on to new hardware, and they
> couldn't help.
>
> So whats the problem?
>
> Patch added support for scanning HD Channels (dvb-t2) for this
> hardware. e.g. with w_scan program. This aspect:
>
> Works in ubuntu 14.04.3 (fully updated kernel etc).
>
> Not works anymore in any versions after that (e.g. 14.10, up to and
> including latest 16.04).
>
> I also tried a recent version of debian too, didn't work on debian either.
>
> ... mostly confused because all of them have similar modern kernel
> now, including 14.04.3 too (which still works properly). Don't know
> where to head next. Any ideas?
>
>
> Link to more details:
>
> https://tvheadend.org/boards/5/topics/10864?r=23758#message-23758
