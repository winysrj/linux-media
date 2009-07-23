Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:62932 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZGWMDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 08:03:07 -0400
Received: by yxe14 with SMTP id 14so318877yxe.33
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 05:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0907230446k291db7bfm1ebcb314d0c97c2@mail.gmail.com>
References: <d9def9db0907230240w6d3a41fcv2fcef6cbb6e2cb8c@mail.gmail.com>
	 <829197380907230441q18e21e4fn63b186370b3711de@mail.gmail.com>
	 <d9def9db0907230443x49dd1b56m143b293e9bdbaaec@mail.gmail.com>
	 <d9def9db0907230446k291db7bfm1ebcb314d0c97c2@mail.gmail.com>
Date: Thu, 23 Jul 2009 08:03:07 -0400
Message-ID: <829197380907230503y3a2ca24y4434ed759c1f4009@mail.gmail.com>
Subject: Re: em28xx driver crashes device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 23, 2009 at 7:46 AM, Markus Rechberger<mrechberger@gmail.com> wrote:
> one thing, you might remove that autodetecting part and taking a
> footprint of unknown devices
> this causes more problems than everything else with those devices.
> Maybe make this optional if someone wants to force autodetection over
> it it might be acceptable
> but doing that by default can also heat up devices.
> Also if it thinks it has detected something, after toggling some gpios
> the footprint might look different
> again after reloading it.. it's just a failed technique doing it that way...

I agree that I'm not particularly happy with how the autodetection
logic works today.  The current logic though is based on the
power-on-reset states of the GPIOs and GPOs though, so we are only
changing the GPIOs if the board matches a known profile.

That said, unless the hardware design was laid out such that the
device would burn out if no driver were loaded at all, I think the
risk is pretty minimal for a device that does not match a known
profile.

If Empia wants to describe a better heuristic for identifying their
various hardware designs with the same USB ID but different board
layouts and GPIO configs, that would be useful information and
eliminate the need for autodetection code.

Anyway, I'll take a look at the code and see if I can determine
specifically where the errors are occurring in your case.

The fun of dealing with hardware vendors that let their customers use
default USB IDs for different hardware designs....  :-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
