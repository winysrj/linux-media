Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54825 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab3EWQWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 12:22:39 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar20so9045205iec.25
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 09:22:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <519E41AC.3040707@gmail.com>
References: <519D6CFA.2000506@gmail.com>
	<CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
	<519E41AC.3040707@gmail.com>
Date: Thu, 23 May 2013 13:22:38 -0300
Message-ID: <CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_A=2E_Vald=E9s?= <av2406@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 23, 2013 at 1:19 PM, "Alejandro A. Valdés" <av2406@gmail.com> wrote:
> Good morning,
>
> Please find the output the cat /proc/asound/ command below:
>
> # cat /proc/asound/cards
>  0 [Intel          ]: HDA-Intel - HDA Intel
>                       HDA Intel at 0xf7cf8000 irq 45
>  1 [EasyALSA1      ]: easycapdc60 - easycap_alsa
>                       easycap_alsa
>
> Besides, this is what the lsusb shows for the device. Hope it helps...

Yes, it certainly helps.

To complete, please output your kernel config and the output of lsmod.

Also, please attach the output of dmesg from the moment you plug your device.
-- 
    Ezequiel
