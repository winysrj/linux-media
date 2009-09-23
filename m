Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51792 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZIWV1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 17:27:53 -0400
Received: by fxm18 with SMTP id 18so970847fxm.17
        for <linux-media@vger.kernel.org>; Wed, 23 Sep 2009 14:27:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090923192810.GA4653@moon>
References: <20090921223751.GA1303@moon>
	 <20090921215238.2e189d60@pedra.chehab.org>
	 <20090923192810.GA4653@moon>
Date: Wed, 23 Sep 2009 17:27:56 -0400
Message-ID: <829197380909231427n1fa9374djf01d06f7c1a682c1@mail.gmail.com>
Subject: Re: xc2028 sound carrier detection
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 23, 2009 at 3:28 PM, Aleksandr V. Piskunov
<aleksandr.v.piskunov@gmail.com> wrote:
> Mmm, tested that tuner under windows, it autodetects all 3 sound carrier sub-
> standards instantly: PAL-BG, PAL-DK, PAL-I.
>
> In order to test, I connected ancient Panasonic VCR that has a built-in tuner
> and can output video to RF-OUT on fixed frequency using PAL standard. Sound
> carrier frequency can be choosen using hardware switch BG, DK or I.
>
> So under windows: tuner produces clear audio in BG, DK and I, hardware switch
> can be toggled on fly, audio never stops, only a few miliseconds of static on
> switch.
>
> Under linux: audio only works if driver is set to use specific audio carrier
> sub-standard AND same is selected on PVR. (not to mention extremely unreliable
> PAL-DK detection by cx25843, only works 50% of times, but thats another issue)
>
> Either a more generic firmware exists can be uploaded on xc2028.. or several
> can be uploaded at once. Any xc2028 gurus out there?

It's possible that perhaps the Windows driver is relying on the
cx25843 standard detection and then using that to load the appropriate
firmware on the 3028.

I can confirm though Mauro's assertion that the 3028 does use
different firmware depending on the selected audio standard.  You
might want to try to get a capture of the device under Windows and see
what firmware gets loaded.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
