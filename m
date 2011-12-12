Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62079 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1LLOXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 09:23:31 -0500
Received: by ggdk6 with SMTP id k6so1155150ggd.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 06:23:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE5F7BB.4070306@seiner.com>
References: <4EDC25F1.4000909@seiner.com>
	<1323058527.12343.3.camel@palomino.walls.org>
	<4EDC4C84.2030904@seiner.com>
	<4EDC4E9B.40301@seiner.com>
	<4EDCB6D1.1060508@seiner.com>
	<1098bb19-5241-4be4-a916-657c0b599efd@email.android.com>
	<c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com>
	<4EE55304.9090707@seiner.com>
	<0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com>
	<4EE5F7BB.4070306@seiner.com>
Date: Mon, 12 Dec 2011 09:23:30 -0500
Message-ID: <CAGoCfizHNPobXjMWAz_xp5wyLfspE6N8AtWxeM6AWeE8U-+UEA@mail.gmail.com>
Subject: Re: cx231xx kernel oops
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Yan Seiner <yan@seiner.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2011 at 7:46 AM, Yan Seiner <yan@seiner.com> wrote:
> Andy Walls wrote:
>>
>> 800 MB for 320x420 frames? It sounds like your app has gooned its
>> requested buffer size.
>>
>
>
> That's an understatement.  :-)
>
>
>> <wild speculation>
>> This might be due to endianess differences between MIPS abd x86 and your
>> app only being written and tested on x86.
>> </wild speculation>
>>
>
>
> My speculation too.  I don't know where that number comes from; the same app
> works fine with the saa7115 driver if I switch frame grabbers.  I'll have to
> do some fiddling with the code to figure out where the problem lies.  It's
> some interaction between the app and the cx231xx driver.
>
>
>
>
>> You still appear to USB stack problems, but not as severe (can't change
>> device config to some bogus config).
>>
>
>
> The requested buffer size is the result of multiplying max_pkt_size *
> max_packets and the rejected config shows a max_packet_size of 0, maybe
> ithere;'s a problem with either endianness or int size... ???  Something to
> follow up on.

For what it's worth, I did do quite a bit of work on cx231xx,
including work for mips and arm platforms.  That said, all the work
done was on the control interfaces rather than the buffer management
(my particular use case didn't have the video coming back over the USB
bus).

How does your app setup the buffers?  Is it doing MMAP?  Userptr?
It's possible userptr support is broken, as that's something that is
much less common.

And as Andy suggested, if you can test your app under x86, knowing
whether the app works with cx231xx under x86 is useful in knowing if
you have a mips issue or something that your app in particular is
doing.

Also, just to be clear, the USB Live 2 doesn't have any onboard
hardware compression.  It has comparable requirements related to USB
bus utilization as any other USB framegrabber.  The only possible
advantage you might get is that it does have an onboard scaler, so if
you're willing to compromise on quality you can change the capture
resolution to a lower value such as 320x240.  Also, bear in mind that
the cx231xx driver may not be properly tuned to reduce the alternate
it uses dependent on resolution.  To my knowledge that functionality
has not been thoroughly tested (as it's an unpopular use case).

And finally, there were fixes for the USB Live 2 specifically which
you may not have in 3.0.3.  You should check the changelogs.  It's
possible that the failure to set the USB alternate is leaving the
driver is an unknown state, which causes it to crash once actually
trying to allocate the buffers.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
