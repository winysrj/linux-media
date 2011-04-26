Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1DZPjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 11:39:43 -0400
Received: by fxm17 with SMTP id 17so516835fxm.19
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2011 08:39:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104211129.40889.laurent.pinchart@ideasonboard.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
	<201104181623.56866.laurent.pinchart@ideasonboard.com>
	<4DAD3A39.1030500@maxwell.research.nokia.com>
	<201104211129.40889.laurent.pinchart@ideasonboard.com>
Date: Tue, 26 Apr 2011 17:39:41 +0200
Message-ID: <BANLkTim=xa+e90Y8UF=SwjFDQ=K1sAKk-Q@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	David Cohen <dacohen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/4/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Sakari,
>
> On Tuesday 19 April 2011 09:31:05 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>> ...
>>
>> > That's the ideal situation: sensors should not produce any data (or
>> > rather any transition on the VS/HS signals) when they're supposed to be
>> > stopped. Unfortunately that's not always easy, as some dumb sensors (or
>> > sensor-like hardware) can't be stopped. The ISP driver should be able to
>> > cope with that in a way that doesn't kill the system completely.
>> >
>> > I've noticed the same issue with a Caspa camera module and an
>> > OMAP3503-based Gumstix. I'll try to come up with a good fix.
>>
>> Hi Laurent, others,
>>
>> Do you think the cause for this is that the system is jammed in handling
>> HS_VS interrupts triggered for every HS?
>
> That was my initial guess, yes.
>
>> A quick fix for this could be just choosing either VS configuration when
>> configuring the CCDC. Alternatively, HS_VS interrupts could be just
>> disabled until omap3isp_configure_interface().
>>
>> But as the sensor is sending images all the time, proper VS configuration
>> would be needed, or the counting of lines in the CCDC (VD* interrupts) is
>> affected as well. The VD0 interrupt, which is used to trigger an interrupt
>> near the end of the frame, may be triggered one line too early on the first
>> frame, or too late. But this is up to a configuration. I don't think it's a
>> real issue to trigger it one line too early.
>>
>> Anything else?

Hello Laurent,

> I've tried delaying the HS_VS interrupt enable to the CCDC configuration
> function, after configuring the bridge (and thus the HS/VS interrupt source
> selection). To my surprise it didn't fix the problem, I still get tons of
> HS_VS interrupts (100000 in about 2.6 seconds) that kill the system.
>
> I'll need to hook a scope to the HS and VS signals.

have you worked on this problem? Today in my setup I took a longer
cable and ran again into the hs/vs interrupt storm (it still works
with a short cable).
I can tackle this issue too, but to avoid double work I wanted to ask
if you worked out something in the meantime.

Best regards,

 Bastian Hecht

>
> --
> Regards,
>
> Laurent Pinchart
>
