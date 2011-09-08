Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52188 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1IHNWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 09:22:39 -0400
Received: by yie30 with SMTP id 30so642402yie.19
        for <linux-media@vger.kernel.org>; Thu, 08 Sep 2011 06:22:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E679407.1090300@mlbassoc.com>
References: <4E679407.1090300@mlbassoc.com>
Date: Thu, 8 Sep 2011 15:22:39 +0200
Message-ID: <CA+2YH7tTbPNjK8+Ao-H30huYmdtWRJFvNbkoD=HQXeppMaZ9aw@mail.gmail.com>
Subject: Re: OMAP3 ISP and UYVY422
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 7, 2011 at 5:55 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> My UYVY422 data looks like this (raw-3.0):
>  0000000: 0080 0080 007f 0080 007f 0080 007f 0080  ................
>  0000010: 0080 0080 0080 0080 0080 0080 0080 0080  ................
>  0000020: 0080 0080 0080 0080 007f 0080 0080 0080  ................
>  0000030: 0080 007f 0080 007f 0080 007f 0080 007f  ................
>
> It should look more like this (raw-2.6.32):
>  0000000: 8034 8033 8034 8034 8034 8034 8034 8034  .4.3.4.4.4.4.4.4
>  0000010: 8034 8033 8034 8034 8034 8034 8034 8033  .4.3.4.4.4.4.4.3
>  0000020: 8034 8034 8034 8034 8034 8034 8033 8032  .4.4.4.4.4.4.3.2
>  0000030: 8034 8035 8033 8034 8033 8034 8033 8034  .4.5.3.4.3.4.3.4
>
> n.b. these are grabbed from the same image on the camera, on the same
> board - either running the new media controller code (3.0+) or old TI
> PSP code (2.6.32)
>
> I've compared the CCDC registers between the two systems and they look
> pretty good to me (none of the differences explain the behaviour above)
>
> It looks to me like the 8 bit data coming into the CCDC is not being
> packed properly, as well as the second byte of each pair is being
> dropped.
>
> Any hints on where to look, what might be mis-configured, etc?

Apart from that (i have the same issue) do you get the full 720
horizontal pixels?

Because this is what i get:

http://imageshack.us/f/215/newkernel0.png/

It's not simply "stretched", the right part is missing. Did you change
some ccdc parameters in the files i sent you?

Enrico
