Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59758 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKPhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 11:37:55 -0400
Received: by bkbzt4 with SMTP id zt4so9943360bkb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 08:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9352E5.5080209@gmail.com>
References: <CALVOWFPrcYuQ-A=Td7AQMj02e96VNg_z2nUOmTvwKyZC_yUmLg@mail.gmail.com>
	<4E9352E5.5080209@gmail.com>
Date: Tue, 11 Oct 2011 12:37:54 -0300
Message-ID: <CALVOWFP1fw7EMDNxHZP-q_CiybwBKuccT3VrRsrpZMYyfBNUfg@mail.gmail.com>
Subject: Re: Cannot configure second Kodicom 4400R
From: Allan Macdonald <allan.w.macdonald@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 5:17 PM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> Hi there Allan,
>
> I'm not familiar with the card (so you'll want to defer to someone else
> if their answer differs from mine).  It looks like video0 and video1 are
> assigned to the first card, and video2 and video3 are assigned to the
> second card.  So, you might want to try
>
> xawtv -d /dev/video2'
>
> or
>
> xawtv -d /dev/video3
>
> and see if one of those uses the second card (you could try video4 or
> video5 also, since they're assigned to cards).
>
> Have a great day:)
> Patrick.
>
> On 10/10/2011 01:45 PM, Allan Macdonald wrote:
>> Hi to all,
>>
>> I am new to this list.
>>
>> I have been successfully using a Kodicom 4400R with zoneminder but I
>> wanted to expand so I bought a second card and installed it.  The
>> problem with this card is that I cannot seem to be able to get the
>> second card to work.  I tried using xawtv with the following command:
>>
>> xawtv -d /dev/video1
>>
>> The result is that I get images from /dev/video0
>>
>> I also tried:
>>
>> xawtv -d /dev/video4
>>
>> with the same result.
>>
>> I obviously don't understand what's going on.
>>
>> I tried following the instructions here, to no avail:
>>
>> http://www.zoneminder.com/wiki/index.php/Kodicom_4400r
>>
>> I also looked here:
>>
>> http://linuxtv.org/wiki/index.php/Kodicom_4400R
>>
>> but, unfortunately, the following page does not explain what happens
>> with more than one card installed.
>>
>> Here's my bttv.conf:
>>
>> [code]
>> options bttv gbuffers=32 card=133,132,133,133,133,132,133,133 tuner=4
>> chroma_agc=1
>> [/code]
>>
>> I have attached a dmesg output and an lsmod output.
>>
>> I would greatly appreciate some help.  Many thanks in advance.
>>
>> Regards,
>>
>> Allan Macdonald
>

Thanks for your reply, Patrick.  I tried every device from /dev/video0
to /dev/video5 and several channel numbers.

The wierd thing is that, if I pick video0, I can see inputs 0 - 3.

When I select devices video1 - 4, I still see the inputs for video0.

To the list:

What I'd really like to know is:

1. I had previously assumed that video0 was the first card installed,
video1 was the second, etc.  Is this incorrect?  Please clarify.

2. The card is a 4-input card.  I presume these inputs were
composite(0) to composite(3).  Am I mistaken here too?  Please
clarify.

As an educational exercise, (or just plain insanity - you judge!) I
have been playing around with the example C code found here:

http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html

and inserted the following couple of lines around line 457 (just after
the "Select video input" comment)

        int index;

        index = 0;

        if (-1 == ioctl (fd, VIDIOC_S_INPUT, &index)) {
        	      perror ("VIDIOC_S_INPUT");
	              exit (EXIT_FAILURE);
        }

Questions about this software:

1. I had assumed that, if I wanted the second input on the second
card, I would make the index variable equal to 1, compile and  run the
program with option -d /dev/video1.  Am I out to lunch?  (I actually
made the input number a command-line option but that source is at home
and I'm at work now).

2. Also, is the index passed to the VIDIOC_S_INPUT ioctl the same
index passed to VIDIOC_QBUF and VIDIOC_DQBUF"?

3. What does the documentation mean by "enqueue" and "dequeue"  I
believe to "dequeue" is to cause the driver to transfer a frame from
its internal fifo buffer to the destination buffer and move the oldest
data pointer to the next oldest item.  Is this correct?  Why does the
example program then go and "enqueue" the same data to the same
device?

I should point out that I don't really know what this program is
actually doing... The only thing I can figure is that the program gets
frames from the video device and stores them in a ram buffer (assuming
default options).  I guess the data is just a big binary blob and
another process is required to handle the data in some way (i.e.
display it, or whatever).  As you can see, I am totally new at this
and some help there would be appreciated as well.  Please help a baby
learn to crawl!

Cheers,
Allan
