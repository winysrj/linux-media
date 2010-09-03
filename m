Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42407 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0ICByu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 21:54:50 -0400
Received: by ewy23 with SMTP id 23so790563ewy.19
        for <linux-media@vger.kernel.org>; Thu, 02 Sep 2010 18:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>
References: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>
From: Joel Wiramu Pauling <joel@aenertia.net>
Date: Fri, 3 Sep 2010 13:54:29 +1200
Message-ID: <AANLkTikg79zui71Xz8r-Lg3zut0jkSk-BGEpBpXfWz5Y@mail.gmail.com>
Subject: Re: Gigabyte 8300
To: Dagur Ammendrup <dagurp@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

What sort of afatech chip?

af9035 are not supported at all. Only af9015's which are in the older devices.

On 3 September 2010 12:55, Dagur Ammendrup <dagurp@gmail.com> wrote:
> Hi,
>
> I bought a Gigabyte U8300 today which is a hybrid USB tuner. These are
> the specifications according to the manufacturer:
>
> Analog: TVPAL / SECAM / NTSC
> Decoder chip: Conexant CX23102
> Digital TV: DVB-T
> Interface: USB 2.0
> Others Support: Microsoft® Windows 2000, XP, MCE and Windows Vista MCE
> / Win 7 32/ 64bits
> Remote sensor Interface: IR
> Tuner: NXP TDA18271
>
> Now I know that the decoder chip is supported in other USB sticks but
> mine is not recognised. Here is my lsusb output:
>
> Bus 001 Device 004: ID 1b80:d416 Afatech
>
> And here is the dmesg info I get when I plug it in:
>
> [ 2981.693805] usb 1-2: USB disconnect, address 2
> [ 2991.760091] usb 1-2: new high speed USB device using ehci_hcd and address 4
> [ 2991.916044] usb 1-2: configuration #1 chosen from 1 choice
>
>
> Is there anyone out there who might be interested in adding support
> for this (or guide me through it)?
>
>
> thanks,
> Dagur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
