Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37446 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbZLGM3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 07:29:25 -0500
Received: by ewy19 with SMTP id 19so358200ewy.1
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 04:29:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.u4kdxxdh6dn9rq@crni.lan>
References: <200912070400.03469.liplianin@me.by> <op.u4kdxxdh6dn9rq@crni.lan>
Date: Mon, 7 Dec 2009 14:29:30 +0200
Message-ID: <4583ac0f0912070429y3ebbec04p352fdbb21e73574b@mail.gmail.com>
Subject: Re: Success for Compro E650F analog television and alsa sound.
From: "Igor M. liplianin" <liplianin@me.by>
To: Samuel Rakitnican <samuel.rakitnican@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/7 Samuel Rakitnican <samuel.rakitnican@gmail.com>:
> On Mon, 07 Dec 2009 03:00:03 +0100, Igor M. Liplianin <liplianin@me.by>
> wrote:
>
>> I'm able to watch now analog television with Compro E650F.
>
> That's great news for somebody :)
>
> Is remote working for this card? My card (T750F) and this card share the
> same remote, so I thought maybe keymap may be shared too. I started
> working on it several months ago but I didn't finished the keys
> associations due to that my card is not supported at all.
>        http://www.spinics.net/lists/linux-media/msg07705.html
>
Currently Andy makes IR support for PCI-e cx23885 chip (like in
E650F), but I can test remote on some PCI cx23883 card or even saa7134
(I have one).
Why not to take your table as basic for them all?


> Regards,
> Samuel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
