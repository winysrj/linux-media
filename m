Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39984 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab3EWUHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 16:07:22 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa10so3406590pad.33
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 13:07:22 -0700 (PDT)
Message-ID: <519E76F3.4070006@gmail.com>
Date: Thu, 23 May 2013 17:07:15 -0300
From: =?ISO-8859-1?Q?=22Alejandro_A=2E_Vald=E9s=22?= <av2406@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Audio: no sound
References: <519D6CFA.2000506@gmail.com> <CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com> <519E41AC.3040707@gmail.com> <CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com> <519E6046.8050509@gmail.com> <CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
In-Reply-To: <CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/23/2013 04:12 PM, Ezequiel Garcia wrote:
> Alejandro,
>
> You dropped the linux-media list from Cc. I'm adding it back.
>
> On Thu, May 23, 2013 at 3:30 PM, "Alejandro A. Valdés" <av2406@gmail.com> wrote:
>> # lsmod
>> Module                  Size  Used by
>> snd_usb_audio         106622  0
>> snd_usbmidi_lib        24590  1 snd_usb_audio
>> easycap              1213861  1
> Okey. This is all I need. You're using the "easycap" driver which is
> an old, deprecated and staging (i.e. experimental) driver for easycap
> devices.
>
> The new driver, which is fully supported, is called "stk1160". It's
> been completely written from scratch, so it's not related to the old
> one.
>
> Upgrade your kernel and/or your distribution to get a kernel >= v3.6
> which includes the new driver, try again and let me know what happens.
>
> --
>      Ezequiel
  Thanks for the tip. Will do so as son as I get another box to play 
with for a while. Not in shape to risk this environment. Will let you 
know the results. Regards,
Alejandro
