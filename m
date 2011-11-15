Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50122 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab1KOWfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 17:35:16 -0500
Received: by yenq3 with SMTP id q3so1192025yen.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 14:35:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321393738.2473.16.camel@localhost>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	<CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
	<4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
	<CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
	<CAL9G6WXHfA-n0u_yB7QvUAN_8TxSSA2M_O0m6kbsOrcgE+nMsA@mail.gmail.com>
	<CAB33W8cJYoXe+1yCPhEGgSpHM7AYd_b-sm5dSy8g+jT=98X=eg@mail.gmail.com>
	<CAB33W8eTZg3Q9xZg9Ebz5C+Cb_H2SHH_R1u30V4i+_Oe8N1ysA@mail.gmail.com>
	<4ec187a6.c6d0e30a.2cea.ffff9e85@mx.google.com>
	<CAB33W8fY8sda3XuePyPYHNb5ZqydDftChW0DewtLH7-UYDw2YA@mail.gmail.com>
	<1321393738.2473.16.camel@localhost>
Date: Tue, 15 Nov 2011 22:35:15 +0000
Message-ID: <CAB33W8dZCEpuJPF2bzU2-v5rbGcfv_1C8rPHLLLtu+9b3aVZRw@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 November 2011 21:48, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> On Tue, 2011-11-15 at 18:53 +0000, Tim Draper wrote:
>> > Are you sure that your system hasn't rolled to 2.6.38-13-generic
>> > yesterday or today even?
>> >
>> still on 2.6.38-12-generic. i've ensured auto-updates are disabled so
>> it should be in the same state as it when it was working.
>> worth re-applying the update/patch? i presume i just need to make &&
>> make install again...?
>
> Sounds like some of the file in the kernel modules were not updated.
>
> Did you remain as the home user during all the all stages of the build,
> patch and make?
>
> ...and only became root in the install
> sudo make install
>
> If this is the case then it is better to do
> make distclean
> make
> sudo make install
>
> If not, and they are mixed root and user.
> sudo make distclean
> make
> sudo make install
>

done, no change.
i've also one the distclean, wiped the v4l git clone, and re-obtained
it, following the instructions you gave to me the other day.
i can confirm that i've done make, and then sudo make install, rather
than sudo the entire process.

also, i've done this without the tuner stick inserted (no tuner cards
present) and i'm still getting the issue.

> In
> /lib/modules/2.6.38-12-generic/kernel/drivers/media/dvb/dvb-usb
>
> All the modules in this directory should have the same date as the ones
> in the media_build/v4l directory.
>
i presume you mean ls -l, as ln is for symbolic links :)
if so, the dvb-usb-af9015.ko file size is different - 55k in v4l, and
590k in modules directory. timestamps are the same though. many other
files show similar results - filesize is different, but timestamps
seem to be ok.


> However, the fact it was working and then not is a little puzzling.

i agree, it is a little weird.
also, sorry for emailing you directly Malcolm, my gmail doesn't seem
to like this ML and is doing some weird things when replying.

thanks again.
