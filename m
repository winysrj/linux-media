Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42830 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3KXSkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:40:24 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so5608814ief.10
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 10:40:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixzV+N7WMhwA=e72pvQJREV5KaR0By=O6+emgsS5eQwGA@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
	<CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
	<CAGoCfixzV+N7WMhwA=e72pvQJREV5KaR0By=O6+emgsS5eQwGA@mail.gmail.com>
Date: Sun, 24 Nov 2013 11:40:24 -0700
Message-ID: <CAA9z4LapwReWVi64eu7fQOpb-xfGC9gWf=5Yz4x22jnYOmMAiw@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I made an exception in my app if the system is ATSC/QAM it uses the
snr = snr * 10.0 and havent found a card yet that it doesnt work with.
Ive also converted quite a few of my dvb-s tuners to report db in the
same way. Havent found a card yet that doesnt have the ability to
report snr in db. Im sure there is one, but I wonder how old it is and
if anyone still uses them.

I have found a few tuner/demods that dont have a method of reporting
signal strength and just use a calc based off the snr in db to make a
fake strength.

How I look at is if snr in % is completely arbitrary and means nothing
when compared from one tuner to another, whats the harm in that
particularly weird tuner/demod of reporting a fake SNR that is
arbitrary and have every other device in Linux report something
useful. Seems dumb to have every device in Linux report an arbitrary
useless value just because one or two devices cant report anything
useful.

I just hate seeing every device reporting useless values just because
one or two tuner/demods are reporting useless values. Why destroy that
useful data for the sake of making all data uniformly useless.

Chris Lee

On Sun, Nov 24, 2013 at 11:20 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Nov 24, 2013 at 1:02 PM, Chris Lee <updatelee@gmail.com> wrote:
>> This is a frustration of mine. Some report it in SNR others report it
>> in terms of % (current snr / (max_snr-min_snr)) others its completely
>> random.
>>
>> Seems many dvb-s report arbitrary % which is stupid and many atsc
>> report snr by 123 would be 12.3db. But there isnt any standardization
>> around.
>>
>> imo everything should be reported in terms of db, why % was ever
>> chosen is beyond logic.
>>
>> Is this something we can get ratified ?
>
> I wouldn't hold your breath.  We've been arguing about this for years.
>  You can check the archives for the dozens of messages exchanged on
> the topic.
>
> Given almost all the Linux drivers for ATSC/ClearQAM devices sold
> today report in 0.1 dB increments, I'm tempted to put a hack in the
> various applications to assume all ATSC devices are in that format.
> I've essentially given up on any hope that there will be any agreement
> on a kernel API which applications can rely on for a uniform format.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
