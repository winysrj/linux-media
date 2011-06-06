Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1FFQzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 12:55:46 -0400
Received: by eyx24 with SMTP id 24so1426213eyx.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 09:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DED0412.4030708@anevia.com>
References: <4DE65C6D.2060806@anevia.com>
	<BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
	<4DED0412.4030708@anevia.com>
Date: Mon, 6 Jun 2011 12:55:44 -0400
Message-ID: <BANLkTint7wHxBxc7ZQB4UohJD-7UE09mAQ@mail.gmail.com>
Subject: Re: HVR-1300 analog inputs
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent Audebert <florent.audebert@anevia.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 12:45 PM, Florent Audebert
<florent.audebert@anevia.com> wrote:
> Nonetheless, I have vertical lines when using s-video at MPEG device output
> (more visible in white areas)[1].
>
> Reading from capture device is alright whether s-video (input=2) or
> composite (input=1) is selected. I've tested it like this:

So, if I understand you correctly, you're getting the lines when using
the MPEG encoder but not the raw output?  This looks like the
decoder's clamp control registers are not properly configured, which I
would have assumed would occur regardless of whether the encoder was
being used.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
