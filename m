Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f202.google.com ([209.85.212.202]:61197 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZGDOgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jul 2009 10:36:14 -0400
Received: by vwj40 with SMTP id 40so2051246vwj.33
        for <linux-media@vger.kernel.org>; Sat, 04 Jul 2009 07:36:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4F620E.6050705@home.se>
References: <4A4F620E.6050705@home.se>
Date: Sat, 4 Jul 2009 10:36:16 -0400
Message-ID: <829197380907040736q6cee804ej6c7e0920fa63df42@mail.gmail.com>
Subject: Re: Pinnacle Hybrid Stick not detected
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Lunderhage <lunderhage@home.se>
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 4, 2009 at 10:07 AM, Andreas Lunderhage<lunderhage@home.se> wrote:
> Hi,
>
> I have problems using my Pinnacle Hybrid Stick using the in-kernel drivers:
>
> It looks like it can't identify it correctly. I'll attach my dmesg output.
>
> Before, I was using the em28xx-new module written by Marcus Rechberger, but
> it looks like he got fed up in maintaining this one and it doesn't build on
> kernel 2.6.28+.
>
> I'm running Ubuntu 32/64-bit 9.04 with all updates applied.
>
> Any ideas?
<snip>

Hello Andreas,

We can probably make this device work in the mainline.  What I would
suggest is you please open the device and take digital photos of both
sides of the circuit board, so we can see what components it contains.
 Then send me the photos.

Also, questions of this nature are probably better posted to the
linux-media mailing list.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
