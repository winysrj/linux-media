Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:33142 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbZHWBGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 21:06:25 -0400
Received: by fxm17 with SMTP id 17so975234fxm.37
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 18:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380908221737h46f028ffu9b7a3b1e260f8c22@mail.gmail.com>
References: <4fab9a6f0908221729n5410920fmd38bace3070105a3@mail.gmail.com>
	 <4fab9a6f0908221732g8e061f3t8fc871c3a0b36337@mail.gmail.com>
	 <829197380908221737h46f028ffu9b7a3b1e260f8c22@mail.gmail.com>
Date: Sun, 23 Aug 2009 03:06:25 +0200
Message-ID: <4fab9a6f0908221806k408047e6s83aa5c3902255eaa@mail.gmail.com>
Subject: Re: Kernel oops with em28xx device
From: Fau <dalamenona@gmail.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/23 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Sat, Aug 22, 2009 at 8:32 PM, Fau<dalamenona@gmail.com> wrote:
>> Greetings,
>> I have an USB TV adapter identified as Hauppauge WinTV HVR 900 (R2) (card=18)
>> and I'm using Fedora 11 with linux kernel vanilla 2.6.30.5 (the last
>> stable as writing).
>>
>> Following the manual at http://www.linuxtv.org/wiki/index.php/Em28xx_devices
>> i've extracted and copied xc3028-v27.fw in /lib/firware then i
>> compiled (make/make install) a freshly cloned v4l-dvb
>>
>> Now when the device is plugged there is a kernel oops, I'm missing
>> something or is it a bug?
>> In attachment the relevant part of dmesg,
>> thank you in advance for any help,
>
> I should probably also point out that the DVB support is known to not
> work with that board (I've been working on the problem).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Hi Devin,
in primis thank you for your help, it's a strange thing that the DVB
is not working,
in the past i used the em28xx-new and it worked very well, even for the DVB-T
but now the mercurial repository is empty and the mailing list is
dead, don't know what happened,
anyway if you need some testing just ask,
thank you again,

--
FaB
