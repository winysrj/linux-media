Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab0HIVVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 17:21:24 -0400
Received: by fxm13 with SMTP id 13so301961fxm.19
        for <linux-media@vger.kernel.org>; Mon, 09 Aug 2010 14:21:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikFaZxZDnuseLZH97UuPENd91RKj=ArJiE3Gzht@mail.gmail.com>
References: <AANLkTin1sY6U3WPmG9XKPKK5wKmpPJkpWOL4bbQG0=b_@mail.gmail.com>
	<AANLkTikFaZxZDnuseLZH97UuPENd91RKj=ArJiE3Gzht@mail.gmail.com>
From: Ben Klein <shacklein@gmail.com>
Date: Tue, 10 Aug 2010 07:21:03 +1000
Message-ID: <AANLkTintW9TLnMwUSiGkKB1Y39VUuDiseEBfWh0+bgSf@mail.gmail.com>
Subject: Re: Unknown EM2750/28xx video grabber - dmesg output
To: Lars Sarauw Hansen <sarauw76@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On 10 August 2010 06:51, Lars Sarauw Hansen <sarauw76@gmail.com> wrote:
> As requested, I'm sending my dmesg output when connecting an external
> TV-grabber box.
> I got the box from my dad and he really can't remember how he got it.
> It seems to be quite decent quality - yet it is only labeled "USB 2.0
> TV BOX". IMHO a truly no-name grabber :-)
>
> Hopefully it can be identified as one of the existing cards from the
> list in dmesg.
>
> Here goes:
-- snip --
> [249160.859431] em28xx #0: Your board has no unique USB ID and thus
> need a hint to be detected.
> [249160.859433] em28xx #0: You may try to use card=<n> insmod option
> to workaround that.
> [249160.859435] em28xx #0: Please send an email with this log to:
> [249160.859436] em28xx #0:      V4L Mailing List <linux-media@vger.kernel.org>
> [249160.859437] em28xx #0: Board eeprom hash is 0x00000000
> [249160.859439] em28xx #0: Board i2c devicelist hash is 0x156500e3
> [249160.859440] em28xx #0: Here is a list of valid choices for the
> card=<n> insmod option:
-- snip --

Maybe you can try experimenting with the card option. I have one card
that I need to force to be card=10, and another which is detected as
card=1 I need to force to be card=2.
