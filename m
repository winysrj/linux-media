Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32982 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165183AbdEAOV7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 May 2017 10:21:59 -0400
Received: by mail-qk0-f182.google.com with SMTP id u68so10140320qkd.0
        for <linux-media@vger.kernel.org>; Mon, 01 May 2017 07:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2431f8bf-1bbd-ffa6-1e72-488c31c9c2a7@googlemail.com>
References: <05c4899146e7f2cfa1d0bc7a5118e3f2294ede40.1493638682.git.mchehab@s-opensource.com>
 <2431f8bf-1bbd-ffa6-1e72-488c31c9c2a7@googlemail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 1 May 2017 10:21:57 -0400
Message-ID: <CAGoCfizpoomajhcouvWobn3LUthUX5_tRBda489jDc7sM0J6CQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] em28xx: allow setting the eeprom bus at cards struct
To: =?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 1, 2017 at 10:11 AM, Frank Sch=C3=A4fer
<fschaefer.oss@googlemail.com> wrote:
>
> Am 01.05.2017 um 13:38 schrieb Mauro Carvalho Chehab:
>> Right now, all devices use bus 0 for eeprom. However, newer
>> versions of Terratec H6 use a different buffer for eeprom.
>>
>> So, add support to use a different I2C address for eeprom.
>
> Has this been tested ?
> Did you read my reply to the previous patch version ?:
> See http://www.spinics.net/lists/linux-media/msg114860.html
>
> I doubt it will work. At least not for the device from the thread in the
> Kodi-forum.

Based on what I know about the Empia 2874/2884 design, I would be
absolutely shocked if the eeprom was really on the second I2C bus.
The boot code in ROM requires the eeprom to be on bus 0 in order to
find the 8051 microcode to be executed.  This is a documented hardware
design requirement.

I have seen designs where the first bus is accessible through an I2C
gate on a demodulator on the second bus.  This creates a multi-master
situation and I have no idea why anyone would ever do this.  However
it does explain a situation where the EEPROM could be optionally
accessed via the second bus (if the I2C gate on the demod was open at
the time).

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
