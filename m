Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49535 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZIGHoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 03:44:10 -0400
Received: by fxm17 with SMTP id 17so1811483fxm.37
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 00:44:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090907030652.04e2d2a3@caramujo.chehab.org>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	 <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	 <20090907021002.2f4d3a57@caramujo.chehab.org>
	 <37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	 <20090907030652.04e2d2a3@caramujo.chehab.org>
Date: Mon, 7 Sep 2009 10:44:11 +0300
Message-ID: <8103ad500909070044r3a04d36bu80e65357ceaf533@mail.gmail.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
	firmware name
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 9:06 AM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Mon, 7 Sep 2009 01:20:33 -0400
> Michael Krufky <mkrufky@kernellabs.com> escreveu:
>
>> On Mon, Sep 7, 2009 at 1:10 AM, Mauro Carvalho
>> Chehab<mchehab@infradead.org> wrote:
>> > Em Fri, 4 Sep 2009 14:05:31 -0400
>> > Michael Krufky <mkrufky@kernellabs.com> escreveu:
>> >
>> >> Mauro,
>> >>
>> >> This fix should really go to Linus before 2.6.31 is released, if
>> >> possible.  It also should be backported to stable, but I need it in
>> >> Linus' tree before it will be accepted into -stable.
>> >>
>> >> Do you think you can slip this in before the weekend?  As I
>> >> understand, Linus plans to release 2.6.31 on Saturday, September 5th.
>> >>
>> >> If you dont have time for it, please let me know and I will send it in myself.
>> >>
>> >
>> > This patch doesn't apply upstream:
>> >
>> > $ patch -p1 -i 12613.patch
>> > patching file drivers/media/video/cx25840/cx25840-firmware.c
>> > Hunk #5 FAILED at 107.
>> > 1 out of 5 hunks FAILED -- saving rejects to file drivers/media/video/cx25840/cx25840-firmware.c.re
>>
>>
>> OK, this is going to need a manual backport.  This does fix an issue
>> in 2.6.31, and actually affects all kernels since the appearance of
>> the cx23885 driver, but I can wait until you push it to Linus in the
>> 2.6.32 merge window, then I'll backport & test it for -stable.
>
> Ok. I think I asked you once, but let me re-ask again: from what I was told, the
> latest cx25840 firmware (the one that Conexant give us the distribution rights)
> seems to be common to several cx25840-based chips. It would be really good if

i also noticed that 3 firmwares with different file names and used by
different drivers:

- "v4l-cx23418-dig.fw" used by "cx18" driver, available here:
http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz and
includes notice about distribution permission from Conexant too

- "v4l-cx23885-avcore-01.fw" used by "cx23885" driver

- "v4l-cx25840.fw" used by "cx25840" driver

have exactly the same md5sum: b3704908fd058485f3ef136941b2e513 and
actually are the same firmware.

> we can test it with all devices, especially since distros will add it on their
> firmware packages, as they are at the firmware -git
>
>
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
