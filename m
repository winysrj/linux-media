Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1HNMFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 08:05:14 -0400
Received: by bke11 with SMTP id 11so2492345bke.19
        for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 05:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E476C3D.7040903@rabbitears.info>
References: <4E476C3D.7040903@rabbitears.info>
Date: Sun, 14 Aug 2011 08:05:12 -0400
Message-ID: <CAGoCfixUi1OAMQ+arsB2L-Cwbu68wF2-mmri3xo01SJMUvETvA@mail.gmail.com>
Subject: Re: Hauppauge Aero-M Driver Problem
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Trip Ericson <webmaster@rabbitears.info>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 14, 2011 at 2:33 AM, Trip Ericson <webmaster@rabbitears.info> wrote:
> Hello, all:
>
> Since my previous e-mail, I was able to get a Linux driver for the tuner
> from Hauppauge.  It came in the form of a v4l tree with the driver included.
>  I adjusted the v4l/.config file to only build the necessary driver.  Once
> it built and I invoked depmod -a, I hooked in my tuner, it detected the
> tuner, but then dmesg gave me:
>
> [31537.360109] dvb_usb_mxl111sf: probe of 2-1.4:1.0 failed with error -22
>
> Does anyone have any idea what this could be?  I can't find anything helpful
> about error -22 when I go looking.  I can provide the link to the driver or
> output from any command requested, I just need to know what to provide and
> how best to share it.
>
> There was also a driver for the Mobile DTV half of the tuner included, but I
> could not get that part to build successfully, so I abandoned it for the
> time being in favor of getting the regular ATSC part to work.
>
> Thanks for any thoughts or assistance.  It is greatly appreciated. =)
>
> - Trip

Hello Trip,

If Hauppauge provided you a driver, you need to direct all support
questions to them.  We aren't going to know the first thing about what
is wrong with such a driver since we've never seen it.

If they've made available a driver in source form under the GPL,
that's a great first step.  However it doesn't mean that the open
source community all of a sudden becomes responsible for the burden
associated with supporting such a driver (in particular when no
datasheets have been made available).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
