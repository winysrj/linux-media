Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f42.google.com ([209.85.213.42]:59794 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2F2Sf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 14:35:26 -0400
Received: by yhfq11 with SMTP id q11so4376115yhf.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 11:35:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206291757.000492@ms2.cniteam.com>
References: <201206291649.000461@ms2.cniteam.com>
	<CAGoCfiwqJ93O5iHW96tJHFZ7uNdvKAwk==3R2YGUnwy=i-rQPg@mail.gmail.com>
	<201206291719.000478@ms2.cniteam.com>
	<CAGoCfixAUwMjGm3nUZvkhj+cY0GraxR2sqq+TUu9m+DO4SoVjQ@mail.gmail.com>
	<201206291757.000492@ms2.cniteam.com>
Date: Fri, 29 Jun 2012 14:35:25 -0400
Message-ID: <CAGoCfiwby3tn5Zh1cyEbnW-Jag6SXbCKg89SMkxMyPKD29JEfg@mail.gmail.com>
Subject: Re: AverTVHD Volar Max (h286DU)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: aschuler@bright.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 29, 2012 at 1:57 PM,  <aschuler@bright.net> wrote:
> I don't need to save the video, except that I'm using CC
> extractor, which expects an Mpeg-2 file. I'd like to capture as
> many streams from one tuner as possible (one reason for working
> in the Linux environment), the vendor-provided applications do
> not allow me to run parallel instances. I'm hoping I can get
> around that - does that seem naive?
>
> I do need ATSC/Clear QAM support. Analog is not necessary. USB
> is preferable because I'm testing with a laptop.

If you don't need analog then that makes things considerably simpler.
The tuner will already deliver MPEG-2 (since that's what the
broadcaster is sending), and tuners can be configured to deliver a
full stream for cases where there are multiple channels on the same
frequency.  That said though, you are limited by the number of
physical tuners in that a single tuner can only be on one frequency at
a time.

What you need to understand is that different products have different
numbers of tuners.  For example, the Hauppauge HVR-950q has a single
tuner which can be shared for analog and digital while the HVR-2250
has two tuners (each of which can tune to a single analog or digital
channel).

There is no inherent limitation under Linux which prevents you from
having multiple tuners in use in parallel.  In fact it's actually
quite common (many MythTV users for example record several programs at
the same time since they have multiple tuners installed).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
