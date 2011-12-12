Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:44082 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751627Ab1LLP6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 10:58:09 -0500
Message-ID: <236aa572a18085c33e56f64cd3155b86.squirrel@mail.seiner.com>
In-Reply-To: <CAGoCfizHNPobXjMWAz_xp5wyLfspE6N8AtWxeM6AWeE8U-+UEA@mail.gmail.com>
References: <4EDC25F1.4000909@seiner.com>
    <1323058527.12343.3.camel@palomino.walls.org>
    <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com>
    <4EDCB6D1.1060508@seiner.com>
    <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com>
    <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com>
    <4EE55304.9090707@seiner.com>
    <0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com>
    <4EE5F7BB.4070306@seiner.com>
    <CAGoCfizHNPobXjMWAz_xp5wyLfspE6N8AtWxeM6AWeE8U-+UEA@mail.gmail.com>
Date: Mon, 12 Dec 2011 07:58:05 -0800 (PST)
Subject: Re: cx231xx kernel oops
From: "Yan Seiner" <yan@seiner.com>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, December 12, 2011 6:23 am, Devin Heitmueller wrote:

>
> For what it's worth, I did do quite a bit of work on cx231xx,
> including work for mips and arm platforms.  That said, all the work
> done was on the control interfaces rather than the buffer management
> (my particular use case didn't have the video coming back over the USB
> bus).
>
> How does your app setup the buffers?  Is it doing MMAP?  Userptr?
> It's possible userptr support is broken, as that's something that is
> much less common.
>
> And as Andy suggested, if you can test your app under x86, knowing
> whether the app works with cx231xx under x86 is useful in knowing if
> you have a mips issue or something that your app in particular is
> doing.

OK, I just tried this with motion (still on the MIPS platform), a totally
different app.  It tries to allocate a reasonable amount of memory:

[1] mmap information:
[1] frames=4
[1] 0 length=153600
[1] 1 length=153600
[1] 2 length=153600
[1] 3 length=153600
[1] buffer index 0 VIDIOC_QBUF: Cannot allocate memory
[1] ioctl (VIDIOCGCAP): Invalid argument

but the driver still tries to grab 800MB.  So it's somewhere between the
app and the driver.

>
> Also, just to be clear, the USB Live 2 doesn't have any onboard
> hardware compression.  It has comparable requirements related to USB
> bus utilization as any other USB framegrabber.  The only possible
> advantage you might get is that it does have an onboard scaler, so if
> you're willing to compromise on quality you can change the capture
> resolution to a lower value such as 320x240.  Also, bear in mind that
> the cx231xx driver may not be properly tuned to reduce the alternate
> it uses dependent on resolution.  To my knowledge that functionality
> has not been thoroughly tested (as it's an unpopular use case).

OK, thanks.  I was hoping this was a hardware framegrabber; the info on
the website is so ambiguous as to be nearly useless.

>
> And finally, there were fixes for the USB Live 2 specifically which
> you may not have in 3.0.3.  You should check the changelogs.  It's
> possible that the failure to set the USB alternate is leaving the
> driver is an unknown state, which causes it to crash once actually
> trying to allocate the buffers.

Will do.





-- 
Pain is temporary. It may last a minute, or an hour, or a day, or a year,
but eventually it will subside and something else will take its place. If
I quit, however, it lasts forever.

