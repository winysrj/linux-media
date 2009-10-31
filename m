Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:52118 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbZJaQsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 12:48:00 -0400
Received: by qw-out-2122.google.com with SMTP id 9so891126qwb.37
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 09:48:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1257002647.3333.7.camel@pc07.localdom.local>
References: <4ADED23C.2080002@uq.edu.au>
	 <303a8ee30910211233r111d3378vedc1672f68728717@mail.gmail.com>
	 <1257002647.3333.7.camel@pc07.localdom.local>
Date: Sat, 31 Oct 2009 12:48:05 -0400
Message-ID: <303a8ee30910310948o107387c5g2d89665ea2bcde7e@mail.gmail.com>
Subject: Re: Leadtek DTV-1000S
From: Michael Krufky <mkrufky@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ryan Day <ryan.day@uq.edu.au>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 11:24 AM, hermann pitton
<hermann-pitton@arcor.de> wrote:
> Hi Mike, Mauro,
>
> Am Mittwoch, den 21.10.2009, 15:33 -0400 schrieb Michael Krufky:
>> On Wed, Oct 21, 2009 at 5:19 AM, Ryan Day <ryan.day@uq.edu.au> wrote:
>> > Michael-
>> > I wanted to see if you might be able to assist in getting a DTV-1000S to
>> > work.  I followed the instructions on the Whirlpool forum (DL the firmware,
>> > cp it to /lib/firmware, dl the dtv-1000s files from kernellabs.com, untar,
>> > make, make install, reboot), and everything looks good when I install, but
>> > when I reboot, the boot up hangs and eventually freezes.
>> >
>> > I thought reinstalling might give me a better chance for success with a
>> > clean slate to work with, but the problem continues.  Unfortunately, I don't
>> > have any of the error logs or anything, as I reinstalled.
>> >
>> > I can't remember the message at the first hang, but the freeze is caused by
>> > a failure to load the LIRC module.
>> >
>> > Also of note is that I'm installing this card as a second tuner.  I have a
>> > DTV-2000H already installed.  I don't know if that changes anything.
>> >
>> > Sorry I can't provide better info, but any advice you can give would be
>> > great.
>>
>
> there is another report for problems with the DTV-1000S now.
>
> Checking the above and the master tree, it turns out that the card's
> analog entry made it into the #if 0 flyvideo tweaks in saa7134-cards.c
> and is not valid there.
>
> Have to leave the house now, Mike please fix it or I'll send a fix when
> back later in the evening.
>
> Cheers,
> Hermann
>

Thanks for spotting this, Hermann ...  I just fixed the problem and
pushed it to my DTV1000S tree.  I'll issue a pull request to Mauro
right now.

Cheers,

Mike
