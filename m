Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:25987 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZFMNmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2009 09:42:11 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1889413ywb.1
        for <linux-media@vger.kernel.org>; Sat, 13 Jun 2009 06:42:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c68f135e0906130530g68b42491sf453ca7c846b8ab8@mail.gmail.com>
References: <c68f135e0906130502l42476a1ctd4cd7710d461199e@mail.gmail.com>
	 <c68f135e0906130530g68b42491sf453ca7c846b8ab8@mail.gmail.com>
Date: Sat, 13 Jun 2009 09:42:13 -0400
Message-ID: <829197380906130642q19923107s886fa49c918d624e@mail.gmail.com>
Subject: Re: Em28xx Log as requested
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: andrea.merello@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 13, 2009 at 8:30 AM, Andrea Merello<andrea.merello@gmail.com> wrote:
> I got it work only one time, and I cannot reproduce it anymore. I
> loaded forcing card=7
>
> When worked it could find the philips video decoder IC. Other times,
> when it does not work, it does not claim to find that IC (see previous
> mail with log)
>
> Maybe you are interested in the log..
> It worked by setting input 1 (the second starting by 0) as video composite.
> I suppose input 0 is the svideo
>
> Andrea

Hello Andrea,

This board shouldn't be too hard to make work.  Could you please do
the following:

In the case where the device failed with card=7, send the dmesg output
(it should be slightly different).

Are you using rmmod/modprobe to test, or are you physically
unplugging/replugging the device?

Also, can you provide a link to a digital photo of the device, so we
can confirm what inputs/outputs the device has?

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
