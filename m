Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39158 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZIJUpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 16:45:07 -0400
Received: by fxm17 with SMTP id 17so398911fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 13:45:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA961BF.2040308@iki.fi>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
	 <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi>
	 <4AA911B6.2040301@iki.fi>
	 <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
	 <4AA92160.5080200@iki.fi>
	 <829197380909100912xdb34da0s55587f6fe9c0f1d5@mail.gmail.com>
	 <4AA92DF6.80107@iki.fi>
	 <829197380909101017w17645c56te9fe829b59812800@mail.gmail.com>
	 <4AA961BF.2040308@iki.fi>
Date: Thu, 10 Sep 2009 16:45:08 -0400
Message-ID: <829197380909101345p3cacde38u4cd50c42cabb5f48@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Heinrich Langos <henrik-vdr@prak.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 4:29 PM, Antti Palosaari<crope@iki.fi> wrote:
> Eh, not all needed, but we need some kind of rule of thumb which URB size is
> suitable for bandwidth used. 512, 8k, 16k etc. It is not wise at all set it
> to only 512 bytes when streaming whole TS example 22Mbit/sec. I have tested
> Anysee (Cypress FX2), AF9015, CE6230, RTL2831U and all those allowed to set
> URB rather freely.

If you want to pick bridges that are important to you and take the
time to optimize them better, by all means be my guest.  This is the
sort of thing that would have to be discussed with the individual
maintainers of those bridges, so you can understand what logic was
used in making the original decision (ensuring the original logic was
not done to work around some bug, etc).

> I haven't seen yet device which forces to use just one
> size - though it is possible there is.

Well, it depends on the chip.  Selecting too small a value can result
in packets getting dropped (this was a problem on em28xx until I fixed
it a few months ago).

> And no datasheet even needed, you can
> see from debug log or error code if URB is not suitable.

Well, this assumes the bridge fails gracefully, returning a failure.
Take Patrick's example, where the device returns success but then
proceed to not send back any URBs.

> Why not set it some good value when possible? And also adding module
> parameter which overrides driver default is not hard to add, just look value
> user gives as param and round it to nearest suitable one.

Frankly, I'm not really confident this provides much value.  End-users
should not really be playing around with these sorts of settings.  If
the values are wrong, a patch should be submitted and the maintainer
should fix the driver.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
