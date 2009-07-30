Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:32857 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZG3MhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 08:37:11 -0400
Received: by gxk9 with SMTP id 9so2590262gxk.13
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 05:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7176D4.2090401@nildram.co.uk>
References: <4A7176D4.2090401@nildram.co.uk>
Date: Thu, 30 Jul 2009 08:37:08 -0400
Message-ID: <829197380907300537g75589d5aqc850c82c6cd9f21c@mail.gmail.com>
Subject: Re: SAA7164 - Analogue Support on HVR devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: lotway@nildram.co.uk
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 30, 2009 at 6:32 AM, Lou Otway<lotway@nildram.co.uk> wrote:
>
> First I'd like to say thanks to the maintainers of the various HVR drivers,
> the amount of work that goes in is much appreciated.
>
> I notice from www.kernellabs.com that progress on the digital side for
> SAA7164 devices is going well and a stable driver is nearly ready.
>
> I, like many people, would really like to have analogue support for these
> devices, is there any news on when this functionality might be available?
>
> Thanks in advance.
>
> Lou

There is presently no work in progress on analog support.  The goal at
this point is to stabilize the digital side, isolating the remaining
bugs.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
