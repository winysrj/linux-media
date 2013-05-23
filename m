Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56761 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3EWTMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 15:12:47 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar20so9642330iec.39
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 12:12:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <519E6046.8050509@gmail.com>
References: <519D6CFA.2000506@gmail.com>
	<CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
	<519E41AC.3040707@gmail.com>
	<CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com>
	<519E6046.8050509@gmail.com>
Date: Thu, 23 May 2013 16:12:46 -0300
Message-ID: <CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_A=2E_Vald=E9s?= <av2406@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alejandro,

You dropped the linux-media list from Cc. I'm adding it back.

On Thu, May 23, 2013 at 3:30 PM, "Alejandro A. Valdés" <av2406@gmail.com> wrote:
> # lsmod
> Module                  Size  Used by
> snd_usb_audio         106622  0
> snd_usbmidi_lib        24590  1 snd_usb_audio
> easycap              1213861  1

Okey. This is all I need. You're using the "easycap" driver which is
an old, deprecated and staging (i.e. experimental) driver for easycap
devices.

The new driver, which is fully supported, is called "stk1160". It's
been completely written from scratch, so it's not related to the old
one.

Upgrade your kernel and/or your distribution to get a kernel >= v3.6
which includes the new driver, try again and let me know what happens.

--
    Ezequiel
