Return-path: <mchehab@gaivota>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643Ab1ACUNb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 15:13:31 -0500
Received: from mail-iy0-f174.google.com (mail-iy0-f174.google.com [209.85.210.174])
	(authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p03KDURA022998
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 12:13:30 -0800
Received: by iyi12 with SMTP id 12so12390530iyi.19
        for <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 12:13:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinimPHSRXfWtu+eiv3Y4WZ6PGrbB3sZKBvw2Muy@mail.gmail.com>
References: <AANLkTinPEYyLrTWqt1r0QgoYmsv2Xg16qGKo5yTqu9FO@mail.gmail.com> <AANLkTinimPHSRXfWtu+eiv3Y4WZ6PGrbB3sZKBvw2Muy@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Jan 2011 12:13:08 -0800
Message-ID: <AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com>
Subject: Re: Problem with em28xx driver in Gumstix Overo
To: Marcos Alejandro Saldivia Delgado <marcos.saldivia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Marcos,

[ full email quoted for new cc's ]

you really would be much better off sending a diff rather than trying
to explain what changes you did, but quite frankly, even if you did
that, I'd still want this to go through the actual maintainers of the
em28xx driver.

The USB error sounds like some independent unrelated issue, I have no
ideas on it.

                   Linus

On Mon, Jan 3, 2011 at 5:14 AM, Marcos Alejandro Saldivia Delgado
<marcos.saldivia@gmail.com> wrote:
>
> Hi Linus .
>
> My name is Marcos Saldivia, and I have a problem with the gumstix Overo
> board when trying to capture video with a usb card  that it uses the em28xx
> driver.
> I tried to connect this capture card, it recognized it without problem .
> and /dev/video0 appears ok.
> but it does not capture nothing .
>
> probe with gstreamer, mplayer and and with this:
>
> cat /dev/video0 >> sample.mpg
>
> and always the file size is 0
>
> And Modify em28xx-core.c
> Original:
> /* FIXME: this only function read values from dev */
> int em28xx_resolution_set(struct em28xx *dev)
> {
> int width, height;
> width = norm_maxw(dev);
> height = norm_maxh(dev);
>
> /* Properly setup VBI */
> dev->vbi_width = 720;
> if (dev->norm & V4L2_STD_525_60)
> dev->vbi_height = 12;
> else
> dev->vbi_height = 18;
>
> if (!dev->progressive)
> height >>= norm_maxh(dev);
>
> em28xx_set_outfmt(dev);
>
>
> Make it:
> /* FIXME: this only function read values from dev */
> int em28xx_resolution_set(struct em28xx *dev)
> {
> int width, height;
> width = norm_maxw(dev);
> height = norm_maxh(dev);
>
> /* Properly setup VBI */
> dev->vbi_width = 720;
> if (dev->norm & V4L2_STD_525_60)
> dev->vbi_height = 12;
> else
> dev->vbi_height = 18;
>
> // if (!dev->progressive)
> // height >>= norm_maxh(dev);
>
> em28xx_set_outfmt(dev);
>
>
> Once this change is applied, the video is shown ok, but around the 10
> minutes it sends the following message
>
> em28xx #0: cannot change alternate number to 0 (error=-110)
> ehci-omap ehci-omap.0: force halt; handshake fa064814 00004000 00000000 ->
> -110 submit of urb 1 failed (error=-108)
>
> and it does not work ,it is only necessary to reboot and it returns to
> happen the same
>
> you can help me?
>
> thank you very much for any information.
>
> Regards.
>
> --
> Marcos Saldivia Delgado
>
>
