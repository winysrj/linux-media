Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63081 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0KQM24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 07:28:56 -0500
Received: by eye27 with SMTP id 27so1062176eye.19
        for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 04:28:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE33B74.6020304@redhat.com>
References: <AANLkTi=ptdBfOm1qaj5EvYfc4ipzdS4PTVsBpW03vdNp@mail.gmail.com>
	<4CE33B74.6020304@redhat.com>
Date: Wed, 17 Nov 2010 17:58:52 +0530
Message-ID: <AANLkTi=5uix6sokCDztt5aY9mhNXFXJ9X1E4XJYumtgf@mail.gmail.com>
Subject: Re: hg pull http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 17, 2010 at 7:48 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 14-11-2010 18:48, Manu Abraham escreveu:
>> Mauro,
>>
>> Please pull from http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/
>>
>> for the following changes.
>>
>>
>> changeset 15168:baa4e8008db5 Mantis, hopper: use MODULE_DEVICE_TABLE
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/baa4e8008db5
>>
>> changeset 15169:f04605948fdc Mantis: append tasklet maintenance for
>> DVB stream delivery
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/f04605948fdc
>>
>> changeset 15170:ee7a63d70f94 Mantis: use dvb_attach to avoid double
>> dereferencing on module removal
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/ee7a63d70f94
>>
>> changeset 15171:3a2ece3bf184 Mantis: Rename gpio_set_bits to
>> mantis_gpio_set_bits
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/3a2ece3bf184
>>
>> changeset 15172:56c20de4f697 stb6100: Improve tuner performance
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/56c20de4f697
>>
>> changeset 15173:5cc010e3a803 stb0899: fix diseqc messages getting lost
>> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/5cc010e3a803
>
> Applied, thanks.
>
> A new warning appeared:
>
> drivers/media/dvb/frontends/stb6100.c:120: warning: ‘stb6100_normalise_regs’ defined but not used


Can you please enclose the function in a #if 0.since it is not being used.

Regards,
Manu
