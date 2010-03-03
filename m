Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63960 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0CCC2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 21:28:00 -0500
Received: by wwa36 with SMTP id 36so518316wwa.19
        for <linux-media@vger.kernel.org>; Tue, 02 Mar 2010 18:27:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele> <20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele> <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
	<20100302163937.70a15c19.ospite@studenti.unina.it> <7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
From: "M.Ebrahimi" <m.ebrahimi@ieee.org>
Date: Wed, 3 Mar 2010 02:27:38 +0000
Message-ID: <1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
To: Max Thrun <bear24rw@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 March 2010 16:06, Max Thrun <bear24rw@gmail.com> wrote:
>
>
> On Tue, Mar 2, 2010 at 10:39 AM, Antonio Ospite <ospite@studenti.unina.it>
> wrote:
>>
>> On Tue, 2 Mar 2010 11:26:15 +0000
>> "M.Ebrahimi" <m.ebrahimi@ieee.org> wrote:
>>
>> > On 28 February 2010 19:55, Jean-Francois Moine <moinejf@free.fr> wrote:
>> > > On Sun, 28 Feb 2010 20:18:50 +0100
>> > > Antonio Ospite <ospite@studenti.unina.it> wrote:
>> > >
>> > >> Maybe we could just use
>> > >>       V4L2_CID_POWER_LINE_FREQUENCY_DISABLED  = 0,
>> > >>       V4L2_CID_POWER_LINE_FREQUENCY_50HZ      = 1,
>> > >>
>> > >> It looks like the code matches the DISABLED state (writing 0 to the
>> > >> register). Mosalam?
>> > >
>> > > I don't know the ov772x sensor. I think it should look like the ov7670
>> > > where there are 3 registers to control the light frequency: one
>> > > register tells if light frequency filter must be used, and which
>> > > frequency 50Hz or 60Hz; the two other ones give the filter values for
>> > > each frequency.
>> > >
>> >
>> > I think it's safe to go with disabled/50hz. Perhaps later if needed
>> > can patch it to control the filter values. Since it seems there is no
>> > flickering in the 60hz regions at available frame rates, and this
>> > register almost perfectly removes light flickers in the 50hz regions
>> > (by modifying exposure/frame rate).
>> >
>> > Mosalam
>> >
>>
>> Mosalam did you spot the register from a PS3 usb dump or by looking at
>> the sensor datasheet?

None, I got that register from sniffing a Windows driver for another
camera that turned out to be using ov7620 or something similar, though
I thought it has the same sensor. I double checked, this register is
for frame rate adjustment (decreasing frame rate / increasing
exposure) . And this has been used in some other drivers (e.g.
gspca_sonixb) to remove light flicker as well.

>>
>> --
>> Antonio Ospite
>> http://ao2.it
>>
>> PGP public key ID: 0x4553B001
>>
>> A: Because it messes up the order in which people normally read text.
>>   See http://en.wikipedia.org/wiki/Posting_style
>> Q: Why is top-posting such a bad thing?
>> A: Top-posting.
>> Q: What is the most annoying thing in e-mail?
>
> I'd also like to know where you got the 2b register from, cause someone else
> also said 2b was filtering but the datasheet says it LSB of dummy pixel...
>
>- Max Thrun

Definitely it is adjusting the frame rate (see the ov7620 DS for the
description how the register value is used, for instance). I have no
idea why the ov7720 datasheet says otherwise.

Since this patch does not use the banding filter registers mentioned
in the datasheet maybe should be discarded. I am working on 75 FPS at
VGA, when I get that working well I can get back to this again.

Thanks for the comments.
Mosalam
