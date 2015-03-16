Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35876 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbbCPSBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 14:01:48 -0400
Received: by qgg60 with SMTP id 60so47250805qgg.3
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 11:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5507177A.8060200@parrot.com>
References: <5507177A.8060200@parrot.com>
Date: Mon, 16 Mar 2015 14:01:47 -0400
Message-ID: <CAGoCfiyZt990gWqSPgaNE7L1fw=XN1DJiiQeDKvepO1Yz9cvaA@mail.gmail.com>
Subject: Re: Dynamic video input/output list
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?UTF-8?Q?Aur=C3=A9lien_Zanelli?= <aurelien.zanelli@parrot.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm looking to enhance video input/output enumeration support in
> GStreamer using VIDIOC_ENUMINPUT/VIDIOC_ENUMOUTPUT ioctls and after some
> discussions we wonder if the input/output list can change dynamically at
> runtime or not.
>
> So, is v4l2 allow this input/output list to be dynamic ?

I sure how the spec allows it, because I've done it in the past.  I
have cards which have an onboard header for external A/V inputs, and I
am able to tell if the breakout cable is attached due to a dedicated
pin tied to a GPIO.  Thus, I am able to dictate whether the card has
the A/V breakout cable attached and thus whether to expose only the
first input or all three inputs.

That said, in this case the inputs in the list never moved around
because the optional entries were at the end of the list - the list
just got longer if those inputs were available.  I'm not sure what
would happen if you had a configuration where you needed to remove
entries other than those at the end of the list.  For example, if you
had a card with four possible inputs and you removed input 2, does the
list stay the same length and input 2 is now marked as invalid, or
does the length of the list become 3 and inputs 3 and 4 turn into
inputs 2 and 3?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
