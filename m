Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46418 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZIGQZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 12:25:15 -0400
Received: by ewy2 with SMTP id 2so2165282ewy.17
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 09:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252340384.3146.52.camel@palomino.walls.org>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	 <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	 <20090907021002.2f4d3a57@caramujo.chehab.org>
	 <37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	 <20090907030652.04e2d2a3@caramujo.chehab.org>
	 <1252340384.3146.52.camel@palomino.walls.org>
Date: Mon, 7 Sep 2009 12:25:15 -0400
Message-ID: <37219a840909070925k25ed146bn9c3725596c9490b9@mail.gmail.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
	firmware name
From: Michael Krufky <mkrufky@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 12:19 PM, Andy Walls<awalls@radix.net> wrote:
> On Mon, 2009-09-07 at 03:06 -0300, Mauro Carvalho Chehab wrote:
>> Em Mon, 7 Sep 2009 01:20:33 -0400
>> Michael Krufky <mkrufky@kernellabs.com> escreveu:
>>
>> > On Mon, Sep 7, 2009 at 1:10 AM, Mauro Carvalho
>> > Chehab<mchehab@infradead.org> wrote:
>> > > Em Fri, 4 Sep 2009 14:05:31 -0400
>> > > Michael Krufky <mkrufky@kernellabs.com> escreveu:
>> > >
>> > >> Mauro,
>> > >>
>> > >> This fix should really go to Linus before 2.6.31 is released, if
>> > >> possible.  It also should be backported to stable, but I need it in
>> > >> Linus' tree before it will be accepted into -stable.
>> > >>
>> > >> Do you think you can slip this in before the weekend?  As I
>> > >> understand, Linus plans to release 2.6.31 on Saturday, September 5th.
>> > >>
>> > >> If you dont have time for it, please let me know and I will send it in myself.
>> > >>
>> > >
>> > > This patch doesn't apply upstream:
>> > >
>> > > $ patch -p1 -i 12613.patch
>> > > patching file drivers/media/video/cx25840/cx25840-firmware.c
>> > > Hunk #5 FAILED at 107.
>> > > 1 out of 5 hunks FAILED -- saving rejects to file drivers/media/video/cx25840/cx25840-firmware.c.re
>> >
>> >
>> > OK, this is going to need a manual backport.  This does fix an issue
>> > in 2.6.31, and actually affects all kernels since the appearance of
>> > the cx23885 driver, but I can wait until you push it to Linus in the
>> > 2.6.32 merge window, then I'll backport & test it for -stable.
>>
>> Ok. I think I asked you once, but let me re-ask again: from what I was told, the
>> latest cx25840 firmware (the one that Conexant give us the distribution rights)
>> seems to be common to several cx25840-based chips.
>
> Well, I know they are all very similar.  I also know that the firmware
> for the CX23418's integrated A/V Core *is different* from the
> CX2584[0123]'s firmware.  The differences are subtle, but it is
> different.  For example, compare
> cx25840/cx25840-core.c:log_audio_status() with
> cx18/cx18-av-core.c:log_audio_status().
>
> I know the CX23418 A/V Core firmware isn't at issue with this change,
> but the situation between the CX2584[0123], CX2388[578], and CX2310[12]
> firmwares is likely similar.
>
> Even if the firmwares are identical now, there is nothting inhbiting
> Conexant from releasing firmware fixes for the CX2310[12] that are not
> applicable to, and just wrong for, the CX25843 for example.
>
>
>>  It would be really good if
>> we can test it with all devices, especially since distros will add it on their
>> firmware packages, as they are at the firmware -git
>
> Working through the set of test vectors, that includes all the Worldwide
> audio standards, while looking for subtle differences or malfunctions,
> is likely more work than any perceived savings of using a single
> firmware image.  How can anyone even tell if anything is misdetected
> without professional TV standards signal generation equipment?  What if
> using the wrong firmware introduces only an intermittent audio standard
> misdetection on that core?
>
> I'll assert we'll never be able to declare a reasonable testing success
> for using an audio standard autodetection firmware not specifically
> designated by Conexant to be for a particular Conexant A/V digitizer
> core.  The core always ends up with subtle differences when integrated
> into another chip.
>
> I suppose one exception is if a "cmp" of two officially designated
> firmware images show the images as being identical, then obviously that
> images can be shared between those cores.
>
>
> I assume licensing is really the issue here.  It is unfortunate.
> However, in my opinion, it is better for the user to know that his
> device is "broken" until he fetches the right firmware, than to spend
> hours debugging mystery audio problems because the user thinks he is
> using the "right" firmware when he is not.
>
> Oh well, I'll stop rambling now...
>
> Regards,
> Andy

Thanks, Andy -- That's exactly what I wanted to say, but you found the
words before I did.

I haven't played much with the cx231xx stuff yet to be able to
comment, but I already know for a fact that there is some stuff in the
cx23885 version of the firmware that does not apply to the other
variants.

While you might be able to make a device work by using the wrong
firmware, it wont necessarily work for all permutations of that
device, and wont necessarily support all features.

Best off to leave it as-is.  Do not attempt to merge the firmware's
into one.  Let the device driver maintainer make that decision.  If
the cx231xx driver were compatible with the default cx25840 firmware,
then they wouldn't have created a new filename for it.  cx23885
certainly needs a newer version of the firmware, which happens to be
backwards compatible with the older cx25840 parts, but just as Andy
mentioned, who is to say that a newer firmware might not come out that
causes problem with legacy components?

Regards,

Mike
