Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38120 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1FGMZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 08:25:28 -0400
Received: by gyd10 with SMTP id 10so1894232gyd.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 05:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307400003-94758-1-git-send-email-corbet@lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
Date: Tue, 7 Jun 2011 13:30:11 +0800
Message-ID: <BANLkTim3ZCCti79FKn9-3toc56jZ9=w3-A@mail.gmail.com>
Subject: Re: [RFC] Refactor the cafe_ccic driver and add Armada 610 support
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi, Jon:
       thanks for your work! it is good to know that your brought up
MMP2(610) SoC with OV7670
       I have some questions:
      1)  this driver is still based on cafe_ccic.c, as you said, we
can abstract the low level register function, and use soc_camera and
videofbu2 to manage the buff and state machine,  how do you think ?
      2) i2c_adapter, how about move this code to driver/i2c, then
ccic driver will become clean?
      3) in mmp_driver.c, it has the sensor name, OV7670,  we wish
that ccic driver do not need to aware of the sensor, also we need to
support front and back camera sensor cases.

Guennadi, what is your suggestions ?

    great thanks!


On Tue, Jun 7, 2011 at 6:39 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> Hello, all,
>
> As I promised last week, here's the state of my work refactoring the Cafe
> driver and adding Armada 610 support.  I intend to have them ready for 3.1,
> but they are not ready for merging yet.  There's a couple of things I'd
> like to clean up, and I'd like to let the OLPC people test things a bit
> more.  But I figured it would be good to get it out there for comments.
>
> Essentially, Marvell has taken the camera controller from the old Cafe chip
> and dropped it into some ARM SoC setups, one of which is the Armada 610.  I
> pondered just making a new driver, but, given that the controller has
> changed very little, it made a lot more sense to reuse the existing code.
>
> The patches here split cafe_ccic.c into "platform" and "core" pieces while
> leaving functionality unchanged.  The new "mmp-camera" driver is then added
> as a second platform.
>
> This work is not done; at a minimum, I plan to convert it over to videobuf2
> and make use of the Armada's s/g DMA capabilities.  Doubtless there is
> plenty more to be done; I would also sure like to see Kassey Lee's Marvell
> driver integrated with this one if at all possible.
>
> Comments?
>
> Thanks,
>
> jon
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
