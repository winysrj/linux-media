Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36125 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZIJP0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 11:26:11 -0400
Received: by fxm17 with SMTP id 17so177271fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 08:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA911B6.2040301@iki.fi>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
	 <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com>
	 <20090910091400.GA15105@moon>
	 <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com>
	 <20090910124549.GA18426@moon> <20090910124807.GB18426@moon>
	 <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon>
	 <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi>
Date: Thu, 10 Sep 2009 11:26:13 -0400
Message-ID: <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 10:48 AM, Antti Palosaari<crope@iki.fi> wrote:
> Here it is, USB2.0 URB is now about 16k both af9015 and ce6230 devices.
> Now powertop shows only about 220 wakeups on my computer for the both
> sticks.
> Please test and tell what powertop says:
> http://linuxtv.org/hg/~anttip/urb_size/
>
> I wonder if we can decide what URB size DVB USB drivers should follow and
> even add new module param for overriding driver default.
>
> Antti
> --
> http://palosaari.fi/
>

Hello Antti,

The URB size is something that varies on a device-by-device basis,
depending on the bridge chipset.   There really is no
"one-size-fits-all" value you can assume.

I usually take a look at a USB trace of the device under Windows, and
then use the same value.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
