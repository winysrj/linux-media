Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:34321 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1NQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 09:16:07 -0400
Received: by mail-qg0-f46.google.com with SMTP id 63so812242qgz.33
        for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 06:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53354925.6070603@xs4all.nl>
References: <1395661349.2916.3.camel@localhost.localdomain>
	<533534D7.6010301@xs4all.nl>
	<1396000280.3518.24.camel@localhost.localdomain>
	<53354925.6070603@xs4all.nl>
Date: Fri, 28 Mar 2014 09:16:06 -0400
Message-ID: <CAGoCfiwN6Z9Whof-ZfWPxPfu+HztHTQewkXLicJkT7si_Jg9uw@mail.gmail.com>
Subject: Re: [PATCH] saa7134: automatic norm detection
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?KOI8-R?B?4czFy9PFyiDpx8/Oyc4=?= <aleksey.igonin@comexp.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Let me explain why I created a new thread.
>> My company is engaged in the monitoring of TV air. All TV channels are
>> recorded 24/7 for further analysis. But some local TV channels change
>> the standard over time (SECAM->PAL, PAL->SECAM). So the recording
>> software must be notified about these changes to set a new standard and
>> record the picture but not the noise.
>
> OK, fair enough.

This is a perfectly reasonable use case, but since we don't do this
with any other devices we probably need to decide whether this really
should be the responsibility of the kernel at all, or whether it
really should be done in userland.  Doing it in userland would be
trivial (even just a script which periodically runs QUERYSTD in a loop
would accomplish the same thing), and the extra complexity of having a
thread combined with the inconsistent behavior with all the other
drivers might make it more worthwhile to do it in userland.

If it were hooked to an interrupt line on the video decoder, I could
certainly see doing it in kernel, but for something like this the loop
that checks the standard could just as easily be done in userland.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
