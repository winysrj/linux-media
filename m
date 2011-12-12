Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46589 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1LLQW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 11:22:27 -0500
Received: by yenm11 with SMTP id m11so3883383yen.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 08:22:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <236aa572a18085c33e56f64cd3155b86.squirrel@mail.seiner.com>
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
	<CAGoCfizHNPobXjMWAz_xp5wyLfspE6N8AtWxeM6AWeE8U-+UEA@mail.gmail.com>
	<236aa572a18085c33e56f64cd3155b86.squirrel@mail.seiner.com>
Date: Mon, 12 Dec 2011 11:22:26 -0500
Message-ID: <CAGoCfiwNT2qZW_yj_kJfdFDydUcTQr3L_1_arcvxwSDt2a1bQQ@mail.gmail.com>
Subject: Re: cx231xx kernel oops
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Yan Seiner <yan@seiner.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2011 at 10:58 AM, Yan Seiner <yan@seiner.com> wrote:
>> Also, just to be clear, the USB Live 2 doesn't have any onboard
>> hardware compression.  It has comparable requirements related to USB
>> bus utilization as any other USB framegrabber.  The only possible
>> advantage you might get is that it does have an onboard scaler, so if
>> you're willing to compromise on quality you can change the capture
>> resolution to a lower value such as 320x240.  Also, bear in mind that
>> the cx231xx driver may not be properly tuned to reduce the alternate
>> it uses dependent on resolution.  To my knowledge that functionality
>> has not been thoroughly tested (as it's an unpopular use case).
>
> OK, thanks.  I was hoping this was a hardware framegrabber; the info on
> the website is so ambiguous as to be nearly useless.

I think you're just confused about the terminology.  The term
"framegrabber" inherently means that it's delivering raw video (as
opposed to having onboard compression and providing MPEG or some other
compressed format).  All framegrabbers are hardware framegrabbers.

There were some *really* old devices that delivered the frames with
JPEG or proprietary compression so that they fit within USB 1.1, but
those designs are almost entirely gone given the hardware cost and the
lack of need since almost everything nowadays is USB 2.0.

You may wish to look at the HVR-1950, which is well supported under
Linux and does deliver MPEG video.  It's obviously more expensive that
the USB Live 2 and it has a tuner which you probably don't need, but
it does avoid the issue if you have USB bus constraints.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
