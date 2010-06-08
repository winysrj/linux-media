Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40277 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0FHLSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 07:18:04 -0400
Received: by gye5 with SMTP id 5so2935813gye.19
        for <linux-media@vger.kernel.org>; Tue, 08 Jun 2010 04:18:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikJzaAnTNGNFZY4B7aYctuq-aejsRiDmkBWMSzZ@mail.gmail.com>
References: <AANLkTikJzaAnTNGNFZY4B7aYctuq-aejsRiDmkBWMSzZ@mail.gmail.com>
Date: Tue, 8 Jun 2010 07:18:02 -0400
Message-ID: <AANLkTinC2DfP414b4USOuW1OnSRgClmVKMUjcEfsa6zS@mail.gmail.com>
Subject: Re: VBI support for em2870 (Kworld UB435-Q)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vasilis Liaskovitis <vliaskov@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 8, 2010 at 12:45 AM, Vasilis Liaskovitis <vliaskov@gmail.com> wrote:
> HI,
>
> I can successfully use my Kworld UB435-Q for OTA capture thanks to the
> development work in this thread:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg10472.html
>
> however I 'd like to get closed captioning support if possible. I
> don't get a /dev/vbi device with the current em28xx driver.
>
> Does the em2870 chip support VBI in the first place?

The UB435-Q is an ATSC/ClearQAM only device.  It has no analog support
at all (and hence no VBI support).

The fact that a /dev/video device gets created at all is a bug that is
on my TODO list to fix.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
