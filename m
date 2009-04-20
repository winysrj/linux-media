Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:26832 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbZDTMWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 08:22:12 -0400
Received: by an-out-0708.google.com with SMTP id d40so821090and.1
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 05:22:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090420085628.31512f60@pedra.chehab.org>
References: <1214127575.4974.7.camel@jaswinder.satnam> <a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	<1240167036.3589.310.camel@macbook.infradead.org> <a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
	<1240170449.3589.334.camel@macbook.infradead.org> <a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
	<1240174908.3589.387.camel@macbook.infradead.org> <28a25ce0904191441h3adc43b3y8265a639e8c025cc@mail.gmail.com>
	<20090420085628.31512f60@pedra.chehab.org>
From: =?UTF-8?B?Um9tw6Fu?= <roman.pena.perez@gmail.com>
Date: Mon, 20 Apr 2009 14:21:56 +0200
Message-ID: <28a25ce0904200521k5906c517n53b7ef7566b7ae4d@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	linux-dvb <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/20 Mauro Carvalho Chehab <mchehab@infradead.org>:
> On Sun, 19 Apr 2009 23:41:58 +0200
> Román <roman.pena.perez@gmail.com> wrote:
>
>> 2009/4/19 David Woodhouse <dwmw2@infradead.org>:
>> > On Sun, 2009-04-19 at 13:40 -0700, VDR User wrote:
>> >>
>> >> To be absolutely clear; users compiling dvb drivers outside of the
>> >> kernel should copy v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex to
>> >> /lib/firmware/av7110/bootcode.bin correct?
>> >
>> > Run 'objcopy -Iihex -Obinary bootcode.bin.ihex bootcode.bin' first, then
>> > copy the resulting bootcode.bin file to /lib/firmware/av7110/
>> >
>>
>> That doesn't seem very *obvious* to me, actually.
>
> If you see INSTALL file at v4l-dvb tree, you'll see:
>
> ...
> Firmware rules:
>
> firmware        - Create the firmware files that are enclosed at the
>                  tree.
>                  Notice: Only a very few firmwares are currently here
>
> firmware_install- Install firmware files under /lib/firmware
> ...
>
> So, all you would need to do to install firmwares with -hg is to run:
>        make firmware_install
>
> Anyway, since firmware install is very fast, and in order to avoid such issues,
> I've just committed a patch that will run firmware_install when you do a "make
> install".
>
>
>
> Cheers,
> Mauro
>

I'm sorry, my fault. As I said, I never had the necessity to install
any firmware.
The patch sounds good, I don't need it myself, but thank you anyway.

Regards,
Román
