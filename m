Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47579 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZBJLtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 06:49:52 -0500
Received: by mail-bw0-f161.google.com with SMTP id 5so2548097bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 03:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090210093753.69b21572@pedra.chehab.org>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
	 <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
	 <20090210093753.69b21572@pedra.chehab.org>
Date: Tue, 10 Feb 2009 12:49:50 +0100
Message-ID: <617be8890902100349r39c49edfr4c3373669d698b72@mail.gmail.com>
Subject: Re: cx8802.ko module not being built with current HG tree
From: Eduard Huguet <eduardhc@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    I don't have yet the buggy config, but the steps I was following
when I encounter the problem were the following:
        · hg clone http://linuxtv.org/hg/v4l-dvb
        · cd v4l-dvb
        · make menuconfig
          (I mostly uncheck here most of the modules, as I really was
needing only to compile the support for Nova-T 500 and an HVR-3000. I
just leave "as is" (checked as M by default) all the SAA7134 and
derived options).
        · make && make install

Best regards,
  Eduard

PS: I suspect that "make allmodconfig" (which I didn't even  know it
existed...) makes a difference here, because it will mark CX88_MPEG as
'M', if I understand it well. I wasn't using it, so maybe this
explains why the option was hiddenly marked as 'Y' instead of 'M'.





2009/2/10 Mauro Carvalho Chehab <mchehab@infradead.org>:
> On Thu, 5 Feb 2009 16:59:16 +0100
> Eduard Huguet <eduardhc@gmail.com> wrote:
>
>> Hi,
>>   Maybe I'm wrong, but I think there is something wrong in current
>> Kconfig file for cx88 drivers. I've been struggling for some hours
>> trying to find why, after compiling a fresh copy of the LinuxTV HG
>> drivers, I wasn't unable to modprobe cx88-dvb module, which I need for
>> HVR-3000.
>>
>> The module was not being load because kernel was failing to find
>> cx8802_get_driver, etc... entry points, which are exported by
>> cx88-mpeg.c.
>>
>> The strange part is that, according to the cx88/Kconfig file this file
>> should be automatically added as dependency if either CX88_DVB or
>> CX88_BLACKBIRD were selected,
>> but for some strange reason it wasn't.
>>
>> After a 'make menuconfig' in HG tree the kernel configuration
>> contained these lines (this was using the default config, without
>> adding / removing anything):
>> CONFIG_VIDEO_CX88=m
>> CONFIG_VIDEO_CX88_ALSA=m
>> CONFIG_VIDEO_CX88_BLACKBIRD=m
>> CONFIG_VIDEO_CX88_DVB=m
>> CONFIG_VIDEO_CX88_MPEG=y
>> CONFIG_VIDEO_CX88_VP3054=m
>>
>> Notice that they are all marked as 'm' excepting
>> CONFIG_VIDEO_CX88_MPEG, which is marked as 'y'. I don't know if it's
>> relevant or not, but the fact is that the module was not being
>> compiled at all. The option was not visible inside menuconfig, by the
>> way.
>>
>> I've done some changes inside Kconfig to make it visible in
>> menuconfig, and by doing this I've been able to set it to 'm' and
>> rebuild, which has just worked apparently.
>>
>> This Kconfig file was edited in revisions 10190 & 10191, precisely for
>> reasons related to cx8802 dependencies, so I'm not sure the solution
>> taken there was the right one.
>>
>> Best regards,
>>  Eduard Huguet
>
> Eduard,
>
> I suspect that this is some bug on the out-of-tree build. In order to test it,
> I've tried to reproduce what I think you did.
>
> So, I ran the following procedures over the devel branch on my -git tree:
>
> make allmodconfig (to select everything as 'm')
> I manually unselect all drivers at the tree, keeping only CX88 and submodules.
> All CX88 submodules as "M".
>
> I've repeated the procedure, this time starting with make allyesconfig.
>
> On both cases, I got those configs:
>
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_ALSA=m
> CONFIG_VIDEO_CX88_BLACKBIRD=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_MPEG=m
> CONFIG_VIDEO_CX88_VP3054=m
>
> My -git tree were updated up to this changeset:
>
> commit 67e70baf043cfdcdaf5972bc94be82632071536b
> Author: Devin Heitmueller <dheitmueller@linuxtv.org>
> Date:   Mon Jan 26 03:07:59 2009 -0300
>
>    V4L/DVB (10411): s5h1409: Perform s5h1409 soft reset after tuning
>
>
> I tried also reproduce the bug you've mentioned at the v4l-dvb tree, but
> unfortunately, I couldn't (the .config file is attached). I got exactly the
> same result as compiling in-kernel.
>
> Could you please send us your buggy .config?
>
> Cheers,
> Mauro
>
