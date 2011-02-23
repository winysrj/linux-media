Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab1BWUAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 15:00:49 -0500
Received: by wwb39 with SMTP id 39so2028306wwb.1
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 12:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102240116.18770.Vivek.Periaraj@gmail.com>
References: <201102240116.18770.Vivek.Periaraj@gmail.com>
Date: Wed, 23 Feb 2011 15:00:42 -0500
Message-ID: <AANLkTi=ipU6gqoQZ4T25ErCGapvoT-Q8vx+mriQj=tji@mail.gmail.com>
Subject: Re: Hauppauge WinTV USB 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vivek Periaraj <vivek.periaraj@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 23, 2011 at 2:46 PM, Vivek Periaraj
<vivek.periaraj@gmail.com> wrote:
> Hi Folks,
>
> I bought a new Hauppauge WinTV USB 2 tuner card and was hoping to use it in
> linux. I specifically looked up to find whether this card is supported or not,
> and I found that it's indeed supported by em28xx drivers.

The product with USB ID 2040:6610 is not an em28xx based device.  It
is based on the tm6010 chip.  Unfortunately, the term "WinTV USB 2" is
too generic.  You need to use the actual model number or USB ID to
determine the status of support.

There has been ongoing work in the tm6010 driver.  You may wish to try
the latest media_build and see if your device is working yet.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
