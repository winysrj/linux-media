Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZIGMx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 08:53:58 -0400
Date: Mon, 7 Sep 2009 09:53:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Isely <isely@isely.net>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
 firmware name
Message-ID: <20090907095326.3cb7a3d0@caramujo.chehab.org>
In-Reply-To: <8103ad500909070044r3a04d36bu80e65357ceaf533@mail.gmail.com>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	<37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	<20090907021002.2f4d3a57@caramujo.chehab.org>
	<37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	<20090907030652.04e2d2a3@caramujo.chehab.org>
	<8103ad500909070044r3a04d36bu80e65357ceaf533@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Sep 2009 10:44:11 +0300
Konstantin Dimitrov <kosio.dimitrov@gmail.com> escreveu:

> On Mon, Sep 7, 2009 at 9:06 AM, Mauro Carvalho
> Chehab<mchehab@infradead.org> wrote:
> > Em Mon, 7 Sep 2009 01:20:33 -0400
> > Michael Krufky <mkrufky@kernellabs.com> escreveu:
> >
> >> On Mon, Sep 7, 2009 at 1:10 AM, Mauro Carvalho
> >> Chehab<mchehab@infradead.org> wrote:
> >> > Em Fri, 4 Sep 2009 14:05:31 -0400
> >> > Michael Krufky <mkrufky@kernellabs.com> escreveu:
> >> >
> >> >> Mauro,
> >> >>
> >> >> This fix should really go to Linus before 2.6.31 is released, if
> >> >> possible.  It also should be backported to stable, but I need it in
> >> >> Linus' tree before it will be accepted into -stable.
> >> >>
> >> >> Do you think you can slip this in before the weekend?  As I
> >> >> understand, Linus plans to release 2.6.31 on Saturday, September 5th.
> >> >>
> >> >> If you dont have time for it, please let me know and I will send it in myself.
> >> >>
> >> >
> >> > This patch doesn't apply upstream:
> >> >
> >> > $ patch -p1 -i 12613.patch
> >> > patching file drivers/media/video/cx25840/cx25840-firmware.c
> >> > Hunk #5 FAILED at 107.
> >> > 1 out of 5 hunks FAILED -- saving rejects to file drivers/media/video/cx25840/cx25840-firmware.c.re
> >>
> >>
> >> OK, this is going to need a manual backport.  This does fix an issue
> >> in 2.6.31, and actually affects all kernels since the appearance of
> >> the cx23885 driver, but I can wait until you push it to Linus in the
> >> 2.6.32 merge window, then I'll backport & test it for -stable.
> >
> > Ok. I think I asked you once, but let me re-ask again: from what I was told, the
> > latest cx25840 firmware (the one that Conexant give us the distribution rights)
> > seems to be common to several cx25840-based chips. It would be really good if
> 
> i also noticed that 3 firmwares with different file names and used by
> different drivers:
> 
> - "v4l-cx23418-dig.fw" used by "cx18" driver, available here:
> http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz 

Conexant sent me in March a set of firmwares, that are available at both
firmware -git tree and at:
	http://linuxtv.org/downloads/firmware/

They sent it together with the distribution rights as stated at the README file.

However, the firmware versions have a different md5sum:

a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx231xx-avcore-01.fw
a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-avcore-01.fw
a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-enc.fw

(the three above are the same firmware and are 3 different names supported at
cx23885 driver)

dadb79e9904fc8af96e8111d9cb59320  v4l-cx25840.fw

This one is different.

Maybe a better strategy would be to name the firmware by versions, since maybe
the differences are just the firmware version for each.

> and includes notice about distribution permission from Conexant too
> 
> - "v4l-cx23885-avcore-01.fw" used by "cx23885" driver
> 
> - "v4l-cx25840.fw" used by "cx25840" driver
> 
> have exactly the same md5sum: b3704908fd058485f3ef136941b2e513 and
> actually are the same firmware.

Yes. That's the point. So, a patch like this is incomplete  or useless due to
one of the reasons bellow:

1) the firmware doesn't work with some devices that could require a different version;

2) some earlier steppings of some chips require a different firmware;

3) Some of the firmwares supplied by the vendor are incorrect;

4) The new firmware works fine with all devices.

So, we need to test the firmware with md5sum: b3704908fd058485f3ef136941b2e513
with all device types to be sure and to provide the proper fix that could
require renaming some of those firmwares or just use one firmware name for all.

I remember I asked both Mikes (Michael Krufky and Mike Isely) on March for some
tests with the new firmware. I'm not sure if they had some time for testing it.

It would be interesting the feedback also from the users to report if the
March, 2009 firmwares work with their devices and, if not, what firmwares work.

Cheers,
Mauro
