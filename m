Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59025 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2LFWMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 17:12:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3916053eek.19
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 14:12:49 -0800 (PST)
Message-ID: <50C11869.30102@googlemail.com>
Date: Thu, 06 Dec 2012 23:12:57 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <CAGoCfiwi3HVBjBh7TzWmwSbVH4S-0174=mqKA64Jw2zYz6K6LA@mail.gmail.com> <50C115BB.1020005@googlemail.com> <CAGoCfiwKGxFt33bf7C0h8akhVJy2ED-R1vGgpe+nJpHYoAVKWg@mail.gmail.com>
In-Reply-To: <CAGoCfiwKGxFt33bf7C0h8akhVJy2ED-R1vGgpe+nJpHYoAVKWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.12.2012 23:03, schrieb Devin Heitmueller:
> On Thu, Dec 6, 2012 at 5:01 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> That's possible, because Matthews log doesn't show any access to this
>> register.
>> If it is not used, the question is if writing 0x07 to this register can
>> cause any trouble...
> Historically speaking, on that family of devices registers that are no
> longer used get treated as scratch registers (meaning writing to them
> has no adverse effect).

Wow, seems like chip manufactures CAN make sane hardware design
decisions after all !  :D

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

