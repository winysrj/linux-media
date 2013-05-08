Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:35554 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3EHD3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 23:29:13 -0400
Received: by mail-qe0-f45.google.com with SMTP id a11so815642qen.4
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 20:29:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51898285.507@web.de>
References: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de>
	<CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
	<CAGoCfiza2FcrFETEeP_PdZvzdW0YuiKm4AP=wMTG465f9zBA9w@mail.gmail.com>
	<51898285.507@web.de>
Date: Tue, 7 May 2013 23:29:12 -0400
Message-ID: <CAGoCfiw3Q1d7qrrCJyZfhLpkNe7wWhsXnuXapb+MHemapHVg5A@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Steffen Neumann <sneumann@ipb-halle.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 7, 2013 at 6:39 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> To pick up this old topic (as I just got the wrong 930C delivered :( ):
>
> What is blocking the development of a si2165 driver? Lacking specs (due
> to NDAs)? Or lacking interest / developer bandwidth?

Probably a bit of both.  I've got the documentation under NDA, and
last I checked it's not otherwise publicly available.  That said, the
chip has been around for several years and no developer has ever cared
to do a reverse engineered driver.  The chip isn't overly complicated
(I could probably write a driver for it in a week even without the
datasheets), alas there has never really been any interest.

> In case of the
> latter, how much effort may it take for a kernel hacker without
> particular experience in the DVB subsystem to get things running?

Not rocket science, for sure.  Probably the bigger issue is
familiarity with reverse engineering techniques and a good
understanding of how demodulators work.  Learning the API itself is
the easy part (given there are plenty of example drivers to use as a
model).

I can count on one hand the number of developers who are actively
contributing tuner/demod drivers.  There just is very little developer
interest in this area nowadays.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
