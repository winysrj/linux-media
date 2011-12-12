Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:42150 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751203Ab1LLQ35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 11:29:57 -0500
Message-ID: <d357dc54e18209f46fc773213630eb86.squirrel@mail.seiner.com>
In-Reply-To: <CAGoCfiwNT2qZW_yj_kJfdFDydUcTQr3L_1_arcvxwSDt2a1bQQ@mail.gmail.com>
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
    <236aa572a18085c33e56f64cd3155b86.squirrel@mail.seiner.com>
    <CAGoCfiwNT2qZW_yj_kJfdFDydUcTQr3L_1_arcvxwSDt2a1bQQ@mail.gmail.com>
Date: Mon, 12 Dec 2011 08:29:56 -0800 (PST)
Subject: Re: cx231xx kernel oops
From: "Yan Seiner" <yan@seiner.com>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, December 12, 2011 8:22 am, Devin Heitmueller wrote:
> On Mon, Dec 12, 2011 at 10:58 AM, Yan Seiner <yan@seiner.com> wrote:
>>> Also, just to be clear, the USB Live 2 doesn't have any onboard
>>> hardware compression.  It has comparable requirements related to USB
>>> bus utilization as any other USB framegrabber.  The only possible
>>> advantage you might get is that it does have an onboard scaler, so if
>>> you're willing to compromise on quality you can change the capture
>>> resolution to a lower value such as 320x240.  Also, bear in mind that
>>> the cx231xx driver may not be properly tuned to reduce the alternate
>>> it uses dependent on resolution.  To my knowledge that functionality
>>> has not been thoroughly tested (as it's an unpopular use case).
>>
>> OK, thanks.  I was hoping this was a hardware framegrabber; the info on
>> the website is so ambiguous as to be nearly useless.
>
> I think you're just confused about the terminology.  The term
> "framegrabber" inherently means that it's delivering raw video (as
> opposed to having onboard compression and providing MPEG or some other
> compressed format).  All framegrabbers are hardware framegrabbers.

Aha.  Thanks for the explanation.

>
> You may wish to look at the HVR-1950, which is well supported under
> Linux and does deliver MPEG video.  It's obviously more expensive that
> the USB Live 2 and it has a tuner which you probably don't need, but
> it does avoid the issue if you have USB bus constraints.

I had looked at the HVR-1950 but the power consumption was prohibitive for
my application.  :-(

--Yan

-- 
Pain is temporary. It may last a minute, or an hour, or a day, or a year,
but eventually it will subside and something else will take its place. If
I quit, however, it lasts forever.

