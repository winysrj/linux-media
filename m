Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36341 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZJIN36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 09:29:58 -0400
Received: by fxm27 with SMTP id 27so6386178fxm.17
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 06:29:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACF03BA.4070505@xfce.org>
References: <4ACDF829.3010500@xfce.org>
	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
	 <4ACDFED9.30606@xfce.org>
	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>
	 <4ACE2D5B.4080603@xfce.org>
	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
	 <4ACF03BA.4070505@xfce.org>
Date: Fri, 9 Oct 2009 09:29:20 -0400
Message-ID: <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
Subject: Re: Hauppage WinTV-HVR-900H
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ali Abdallah <aliov@xfce.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 9, 2009 at 5:34 AM, Ali Abdallah <aliov@xfce.org> wrote:
> Okay, i installed the latest drivers+the firmware of the device using
> extract_xc3028.pl, the device seems to be detected now, i can detect all the
> analog TV of my cable using tvtime, but manually, i mean i had to disable
> signal detection when scanning, otherwise i got no results, since the
> picture quality is terrible.
>
> Of course i'm sure that all the connections (cable to antenna, cable to the
> usb stick, ...) are correct, since it works with my old PC equipped with a
> PCI TV card.
>
> Any advice, what could be the problem? firmware? since you said (you added
> support for this device) should i open a bug report? is this device reported
> as working by other users?
>
> Please help if possible, almost two weeks with no real success.

Could you please provide a screen shot of the tvtime output?

Also, are you trying to capture over-the-air or are you capturing
cable television?

What analog standard are you using?  PAL-BG?

Did you make sure to tell tvtime which analog standard you are using?

Could you try the S-Video or composite input and see if the picture
quality is still bad (as this well help isolate whether it's a problem
with the tuner chip or the decoder.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
