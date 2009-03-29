Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:36750 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZC2OZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:25:57 -0400
Received: by qyk16 with SMTP id 16so2967289qyk.33
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 07:25:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238297237.3235.42.camel@palomino.walls.org>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
	 <1238297237.3235.42.camel@palomino.walls.org>
Date: Sun, 29 Mar 2009 10:25:54 -0400
Message-ID: <de8cad4d0903290725t2e7764a8pe2c0d1b7d67ea8c4@mail.gmail.com>
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
Cc: Corey Taylor <johnfivealive@yahoo.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtv-driver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 28, 2009 at 11:27 PM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2009-03-23 at 06:52 -0700, Corey Taylor wrote:
>> > Andy,
>>
>> > I am noticing an improvement in pixelation by setting the bufsize to
>> > 64k. I will monitor over the next week and report back. I am running 3
>> > HVR-1600s and the IRQs are coming up shared with the USB which also
>> > supports my HD PVR capture device. Monday nights are usually one of
>> > the busier nights for recording so I will know how well this holds up.
>>
>> > Thanks for the tip!
>>
>> > Brandon
>>
>> Hi Andy and Brandon, I too tried various different bufsizes as suggested and I still see very noticeable pixelation/tearing regardless of the setting.
>>
>> I even upgraded my motherboard this past weekend to an Asus AM2+ board with
>> Phenon II X3 CPU. Still the same problems with the card in a brand new
>> setup.
>>
>> I also tried modifying the cx18 source code as Andy suggested and that
>> made more debug warning show up in my syslog, but still did not
>> resolve the issue. Haven't tried this yet with the new motherboard
>> though.
>>
>> Is it possible that this card is more sensitive to hiccups in the
>> signal coming from the cable line? Or interference from other close-by
>> cables and electronic equipment?
>>
>> When recording/watching Live TV through MythTV, I see that ffmpeg is
>> constantly outputting various errors related to the video stream. I
>> can post those here if you think it's relevant.
>>
>> Shoud I just return this card and get one with a different chipset? Or
>> do you think driver updates can solve the issue?
>>
>> I'm happy to hold on to this card if it means I can contribute in some
>> way to fixing the problem, if it's fixable : )
>
> Corey and Brandon,
>
> I found a race condition between the cx driver and the CX23418 firmware.
> I have a patch that mitigates the problem here:
>
> http://linuxtv.org/hg/~awalls/cx18/rev/9f5f44e0ce6c
>
> I think the final form of the patch could be better.  However, this
> patch essentially eliminated any artifacts I was getting playing back
> digital TV.  I also had positive results running mplayer without the
> "-cache" command line for both digital and analog captures.
>
> I haven't tested on a single processor machine, nor in a multicard
> setup, but things looked good enough that I thought it ready for test by
> others.
>
> Let me know if it helps or not.
>
> Regards,
> Andy
>
>
Hi Andy,

I have cloned this tree and loaded on the server. I'll let you know
over the next couple of days if there is any improvement.

Thanks!

Brandon
