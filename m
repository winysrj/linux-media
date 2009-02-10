Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61769 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbZBJMjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 07:39:32 -0500
Received: by bwz5 with SMTP id 5so2604961bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 04:39:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090210100955.715770d0@pedra.chehab.org>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
	 <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
	 <20090210093753.69b21572@pedra.chehab.org>
	 <617be8890902100357s7a56776av3475db0cfd486b9@mail.gmail.com>
	 <20090210100955.715770d0@pedra.chehab.org>
Date: Tue, 10 Feb 2009 13:39:29 +0100
Message-ID: <617be8890902100439q24659871qfb0191730cd2f9e3@mail.gmail.com>
Subject: Re: cx8802.ko module not being built with current HG tree
From: Eduard Huguet <eduardhc@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll give it a try, thanks.
Regards,
  Eduard


2009/2/10 Mauro Carvalho Chehab <mchehab@infradead.org>:
> On Tue, 10 Feb 2009 12:57:47 +0100
> Eduard Huguet <eduardhc@gmail.com> wrote:
>
>> Hi,
>>     Just tried it right now, with these simple steps:
>>
>>       · hg clone http://linuxtv.org/hg/v4l-dvb
>>       · cd v4l-dvb
>>       · make menuconfig & exit from it without touching anything
>>
>> I attach the resulting v4l/.config file generated. As you can see,
>> CX88_MPEG is being marked as 'Y' instead that 'M':
>>
>> $ grep CX88 v4l/.config
>> CONFIG_VIDEO_CX88=m
>> CONFIG_VIDEO_CX88_ALSA=m
>> CONFIG_VIDEO_CX88_BLACKBIRD=m
>> CONFIG_VIDEO_CX88_DVB=m
>> CONFIG_VIDEO_CX88_MPEG=y
>> CONFIG_VIDEO_CX88_VP3054=m
>
> Weird. I 've applied your changeset and copied it at v4l/.config. Then, a make
> menuconfig and exit, just to be sure that kernel build would touch on it.
> Everything worked fine.
>
>> I'm compiling against Ubuntu kernel 2.6.22, which I know it's pretty
>> old. Can this make any difference?
>
> I'm using here kernel 2.6.28.2. Maybe this is some bug on the Ubuntu's kernel
> kbuild, since make *config options at the out-of-tree kernel is a wrapper to
> the kernel kbuild.
>
> Could you please try the same procedure with a newer kernel? There's no need to
> install the kernel on your machine. All you need to do is something like:
>
> wget <newer kernel like 2.6.28.4>
> tar -xvfoj <kernel>
> cd linux
> make init
>
> cd ~/v4l-dvb
> make release DIR=<newer kernel patch>
> make menuconfig
>
> The "make release" will allow you to use the Kbuild of the newer kernel.
>
>>
>> Best regards,
>>   Eduard
>>
>> PS: by the way, this works fine when using revision 10189,  just
>> before CX88 dependencies got altered.
>
> The problem is that the old Kconfig were causing breakages upstream.
>
> Cheers,
> Mauro
>
