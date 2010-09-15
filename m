Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52732 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0IOQIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 12:08:13 -0400
Received: by ewy23 with SMTP id 23so200583ewy.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 09:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74bab26c7582158ca76426c5e211f4d7.squirrel@webmail.xs4all.nl>
References: <AANLkTinAjJ2_qxFVJuJ=TRr7+OJPtHnESKW7yHpoXev7@mail.gmail.com>
	<74bab26c7582158ca76426c5e211f4d7.squirrel@webmail.xs4all.nl>
Date: Wed, 15 Sep 2010 12:08:09 -0400
Message-ID: <AANLkTinnZF84ODVCsQ=N1n6GCnL1aT0yz_fNt1WhFBoU@mail.gmail.com>
Subject: Re: pwc driver breakage in recent(ish) kernels (for old hardware)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christopher Friedt <chrisfriedt@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Sep 15, 2010 at 11:59 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> You're in luck. I fixed this last weekend. It turns out that the
> /dev/videoX device is created too soon and the HAL daemon starts to use it
> immediately causing some initialization to go wrong or something like
> that. Moving the creation of /dev/videoX to the end fixed this issue.
>
> This bug has been there probably for a long time, but it is only triggered
> if some other process opens the device node immediately.

The "HAL daemon opening devices immediately" problem a pretty common
bug with bridges (especially for hybrid devices) and I've fixed it for
the ones I've seen.  I'm surprised we don't get reports of this more
often.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
