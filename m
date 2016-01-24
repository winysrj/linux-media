Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37720 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbcAXKH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 05:07:56 -0500
Received: by mail-wm0-f43.google.com with SMTP id n5so39591878wmn.0
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2016 02:07:55 -0800 (PST)
Subject: Re: SV: PCTV 292e support
To: Russel Winder <russel@winder.org.uk>,
	=?UTF-8?Q?Peter_F=c3=a4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1453613292.2497.26.camel@winder.org.uk>
 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
 <1453615078.2497.29.camel@winder.org.uk>
 <1453618564.2497.51.camel@winder.org.uk>
 <1453625202.2497.54.camel@winder.org.uk>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <56A4A262.1090708@gmail.com>
Date: Sun, 24 Jan 2016 10:07:30 +0000
MIME-Version: 1.0
In-Reply-To: <1453625202.2497.54.camel@winder.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russel Winder wrote:
> On Sun, 2016-01-24 at 06:56 +0000, Russel Winder wrote:
>> […] that some other firmware needs to be extracted from the discs.
>
> If in doubt check out http://palosaari.fi/linux/v4l-dvb/firmware/
>
> Firmware loaded and running. Device tuning and working.
>
> Except that the T2 channels cannot be found properly. I guess this is
> a "solved issue" as well, so back to the research.
>
> Apologies for the earlier noise.

Maybe your uk-CrystalPalace is old.

There's something called w_scan which really does scan.

Try distro install or searching for it.

I don't use and haven't updated the dvb5 tools for ages. Looking back at
experiments it seems I have T rather than T2 in my tuning files. Maybe
that's something to keep in mind, also IIRC for T2 channels you do need
each frequency (unlike the Ts whose details are found by tuning to any
channel).

I don't know your setup or requirements, but using players to
tune/record will avoid the "-p" issue. I run headless and use tvheadend.
If I had an HTPC setup I would probably use kodi (xbmc).


