Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:34196 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752930Ab0EOQDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:03:52 -0400
Message-ID: <4BEEC5E5.9020805@rogers.com>
Date: Sat, 15 May 2010 12:03:49 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Alexjan Carraturo <axjslack@gmail.com>
CC: video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: Pinnacle PCTV DVB-T 70e
References: <AANLkTilbPB2DeJhah0XzSMYEOpXUTzt-v4-h9JsV1BP2@mail.gmail.com>
In-Reply-To: <AANLkTilbPB2DeJhah0XzSMYEOpXUTzt-v4-h9JsV1BP2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

this list is all but dead. Use the linux-media mailing list instead (I
have cc'ed my reply to it).....in the olden days, the video4linux list
was the correct one for analog devices, and linux-dvb for (surprise,
surprise) dvb related discussion. Nowadays, they have both been
superseded by the linux-media list.

> Long time I try to run a particular type of device DVB-T, and sometimes I did.
>
> The device in question is a Usbstick Pinnacle PCTV DVB-T (70th); is
> USB, running lsusb we have this
>
> eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick
>
> As I said before, once I managed to get it working with both Fedora
> and Slackware (the Linux distributions that I use routinely).
>
> Did not work with the drivers on the kernel (em28xx, em28xx-dvb); the
> "traditional driver" try to recognize the device, but doesn't work.
>
> The device works only (and very well) with a version made by some
> individuals, called em28xx-new. There is a version of these drivers,
> compile manually, but it works only until kernel 2.6.31 (
> http://launchpadlibrarian.net/35049921/em28xx-new.tar.gz )
>   

He stopped supporting his driver and now only works on closed source
software.

> Searching the internet I saw that many users are trying to work this
> board (very common).
>
> Is there a way to incorporate the changes mentioned in the official driver?
>   

No.

> Or, you can suggest how they might be modified drivers indicated to
> work with recent kernels (2.6.32, and soon 2.6.33 or later)?
>   

The person in question, unfortunately and needlessly, came to an impasse
with the v4l-dvb project. He later stopped developing his work. And no
one here is much interested in touching his with a hundred and ten foot
pole.

You can, however, look to see if you can add support for your device to
the existing v4l-dvb kernel driver. There are several developers that
are knowledgeable of the em28xx driver, and whom may be able to help you
in that regard, but you will have to gain there attention first.

