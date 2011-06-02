Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52630 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab1FBJxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 05:53:40 -0400
Received: by gxk21 with SMTP id 21so260799gxk.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 02:53:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110602032437.3b911574@tpl.lwn.net>
References: <1306934205-15154-1-git-send-email-ygli@marvell.com>
	<20110602032437.3b911574@tpl.lwn.net>
Date: Thu, 2 Jun 2011 17:53:39 +0800
Message-ID: <BANLkTi=fkO2pSuPmJU-xOma1u08jtJxsvA@mail.gmail.com>
Subject: Re: [PATCH V2] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kassey Lee <ygli@marvell.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl, qingx@marvell.com,
	ytang5@marvell.com, leiwen@marvell.com, jwan@marvell.com,
	hzhuang1@marvell.com, njun@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi, Jonathan:
          yes, you are right,  this driver uses most of the low level
code from cafe-ccic.c.
          I am so sorry to miss the your email and refer info from
cafe-ccic.c  in my driver, really appreciate your work.

         the point  that I write mv_camera.c is to base the soc_camera
+ vidieobuf2, other than manage the buffer by our-self which is done
in cafe-ccic.c.
          I am OK to wait for your work on Armada 610, is this based
on soc_camera + videobuf2 ?
          let's make it a more graceful driver.

thanks


On Thu, Jun 2, 2011 at 5:24 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed,  1 Jun 2011 21:16:45 +0800
> Kassey Lee <ygli@marvell.com> wrote:
>
>> This driver exports a video device node per each CCIC
>> (CMOS Camera Interface Controller)
>> device contained in Marvell Mobile PXA910 SoC
>> The driver is based on soc-camera + videobuf2 frame
>> work, and only USERPTR is supported.
>
> This device looks awfully similar to the Cafe controller; you must
> certainly have known that, since some of the code in your driver is
> clearly copied (without attribution) from cafe_ccic.c.
>
> As it happens, I've just written a driver for the Armada 610 SoC found
> in the OLPC 1.75 system; I was planning to post it as early as next
> week.  I took a different approach, though: rather than duplicating the
> Cafe code, I split that driver into core and platform parts, then added
> a new platform piece for the Armada 610.  I do believe that is a better
> way of doing things.
>
> That said, your driver has useful stuff that mine doesn't - MIPI
> support, for example.
>
> I'm traveling, but will be back next week.  I'll send out my work after
> that; then I would really like to find a way to make all these pieces
> work together with a common core for cafe-derived controllers.  Make
> sense?
>
> Thanks,
>
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
