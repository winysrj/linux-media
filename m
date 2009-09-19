Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33294 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZISTIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 15:08:34 -0400
Received: by bwz6 with SMTP id 6so1277181bwz.37
        for <linux-media@vger.kernel.org>; Sat, 19 Sep 2009 12:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB4E526.2080109@yahoo.it>
References: <4AB4E526.2080109@yahoo.it>
Date: Sat, 19 Sep 2009 15:08:37 -0400
Message-ID: <829197380909191208n42ff4ee1l450b0cae015e7e21@mail.gmail.com>
Subject: Re: driver for Cinergy Hybrid T USB XS FM
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Adriano Gigante <adrigiga@yahoo.it>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 19, 2009 at 10:05 AM, Adriano Gigante <adrigiga@yahoo.it> wrote:
> Hy all,
>
> after Markus Rechberger has discontinued the development of em28xx-new
> kernel driver, device "Terratec Cinergy Hybrid T USB XS FM" is no more
> supported under linux.
> I also built and installed from http://linuxtv.org/hg/v4l-dvb sources with
> no success (it creates /dev/video0 /dev/radio0 /dev/radio1 -no dvb - and
> nothing works).
>
> The device id is 0ccd:0072, and from Terratec site I saw it's based on Empia
> em2882 and Xceive 5000 chips.
>
> Someone could help with infos about this stick
>
> Thanks all people.
>
> Adri

Hello Adri,

You are correct in that the device in question is not supported in the
current v4l-dvb tree.  Unfortunately, we have never had an
em28xx/xc5000 combination in the tree, and I was hesitant to add such
a board profile when I didn't have the hardware at my disposal for
testing.

I don't see support coming for this device in the near future unless a
developer manages to get his hands on a board.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
