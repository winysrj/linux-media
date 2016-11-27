Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:36009 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbcK0ApN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 19:45:13 -0500
Received: by mail-wj0-f174.google.com with SMTP id qp4so86799485wjc.3
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2016 16:45:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
References: <20161117134526.GA8485@gofer.mess.org> <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org> <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org> <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org> <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org> <20161124121253.GA17639@shambles.local>
 <20161124133459.GA32385@gofer.mess.org> <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Sun, 27 Nov 2016 11:39:49 +1100
Message-ID: <CAEsFdVOczkeKYkxy=4jV+Ks=yx0tim6O7L0ZPjBkBNBQAxm7VQ@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> However when you try to use the new mapping in some application then
>> it does not work?
>
> That's correct. ir-keytable seems to be doing the right thing, mapping
> the scancode to the input-event-codes.h key code I asked it to.
>
> The application I am trying to use it with is the mythtv frontend.  I
> am doing the keycode munging from an SSH session while myth is still
> running on the main screen. I didn't think this would matter (since it
> worked for KEY_OK->KEY_ENTER) but perhaps it does. Obviously
> ir-keytable -t intercepts the scancodes when it is running, but when I
> kill it myth responds normally to some keys, but not all.

It turned out that that I had to restart X to make it notice the updated keymap.
After that, the modfied keymap I set up is mostly working.

There is still a bit of a mystery. As I understand it, X should notice
key codes less than 255 (0xff). But it seems to be ignoring KEY_STOP
(code 128, 0x80) and any key codes higher than that but less than 255.
ir-keytable -t shows the right codes.

Vince
