Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56288 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZKICBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 21:01:46 -0500
Received: by pwi3 with SMTP id 3so337590pwi.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 18:01:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	<829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
From: Barry Williams <bazzawill@gmail.com>
Date: Mon, 9 Nov 2009 12:31:30 +1030
Message-ID: <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:22 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Nov 8, 2009 at 8:43 PM, Barry Williams <bazzawill@gmail.com> wrote:
>> Hi Devin
>> I tried your tree and I seem to get the same problem on one box I get
>> the flood of 'dvb-usb: bulk message failed: -110 (1/0'.
> <snip>
>
> Can you please confirm the USB ID of the board you are having the
> problem with (by running "lsusb" from a terminal window)?
>
> Thanks,
>
> Devin
> --


On the first box I have
Bus 003 Device 003: ID 0fe9:db98 DVICO
Bus 003 Device 002: ID 0fe9:db98 DVICO

on the second
Bus 001 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
Bus 001 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
